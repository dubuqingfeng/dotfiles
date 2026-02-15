#!/usr/bin/env node
import {
  createPublicClient,
  http,
  parseEther,
  formatEther,
  formatUnits,
  isAddress,
  decodeFunctionData
} from "viem";
import {
  mainnet,
  optimism,
  arbitrum,
  base,
  polygon,
  bsc,
  avalanche,
  sepolia,
  optimismSepolia,
  arbitrumSepolia,
  baseSepolia,
  polygonAmoy
} from "viem/chains";

import { CHAIN_ALIASES, DEFAULT_RPCS, envRpcFor, normalizeChainAlias } from "./rpcs.mjs";
import {
  parseArgs,
  die,
  reqArg,
  toInt,
  toBigInt,
  readJsonMaybe,
  tryParseJson,
  isFilePathLike
} from "./utils.mjs";

const CHAINS = {
  ethereum: mainnet,
  optimism,
  arbitrum,
  base,
  polygon,
  bsc,
  avalanche,
  sepolia,
  optimismSepolia,
  arbitrumSepolia,
  baseSepolia,
  polygonAmoy
};

function printJson(obj) {
  process.stdout.write(
    JSON.stringify(
      obj,
      (_k, v) => (typeof v === "bigint" ? v.toString() : v),
      2
    ) + "\n"
  );
}

function getRpcUrls({ chainKey, rpc }) {
  const urls = [];
  if (rpc) urls.push(String(rpc));
  const envRpc = envRpcFor(chainKey);
  if (envRpc) urls.push(String(envRpc));
  const builtin = DEFAULT_RPCS[chainKey] || [];
  urls.push(...builtin);

  const seen = new Set();
  return urls.filter((u) => u && !seen.has(u) && seen.add(u));
}

function printHelp() {
  const text = `
Usage:
  node scripts/evm.mjs <cmd> [--chain <alias>] [--rpc <url>] ...

Commands:
  rpc --chain <alias>                         Show built-in RPC list (and env override).
  chain-list                                   List supported chains/aliases.
  health --chain <alias>                       Test all known RPCs for a chain (latency + chainId check).
  chain-info --chain <alias>                  Print chainId + latest block number.
  balance --chain <alias> --address <0x..>     Get native token balance.
  erc20-balance --chain <alias> --token <0x..> --address <0x..>
                                              Get ERC20 balance + decimals + symbol.
  tx --chain <alias> --hash <0x..>             Get transaction.
  receipt --chain <alias> --hash <0x..>        Get transaction receipt.
  wait --chain <alias> --hash <0x..> [--confirmations 1]
                                              Wait for receipt.
  call --chain <alias> --contract <0x..> --abi <file.json> --fn <name> [--args '[...]']
                                              Read-only contract call.
  ens-address --name <vitalik.eth>             Resolve ENS name to address (ETH mainnet only).
  ens-name --address <0x..>                    Reverse-resolve ENS name (ETH mainnet only).
  erc20-balances --address <0x..> --tokens '[\"0x..\",\"0x..\"]'
                                              Get multiple ERC20 balances.
  token-info --token <0x..>                    Get ERC20 basic info (name/symbol/decimals/totalSupply).
  erc721-balance --collection <0x..> --address <0x..>
                                              Get ERC721 balanceOf.
  nft-owner --nft <0x..> --id <tokenId>        Get ERC721 ownerOf.
  nft-metadata --nft <0x..> --id <tokenId>     Get ERC721 tokenURI + name/symbol.
  erc1155-balance --token <0x..> --address <0x..> --id <tokenId>
                                              Get ERC1155 balanceOf.
  estimate-gas --to <0x..> [--value 0.1] [--data 0x..]
                                              Estimate gas for a call/tx.
  gas-price                                    Get gasPrice and latest block baseFeePerGas.
  block [--number <n>] [--txs]                 Get latest block or block by number.
  decode --abi <file.json> --data <0x..>       Decode calldata using ABI.
  is-contract --address <0x..>                 Check if address has bytecode.
  simulate --contract <0x..> --abi <file.json> --fn <name> [--args '[...]'] --from <0x..>
                                              Simulate a contract write (no tx sent).
  multicall --calls <fileOrJson>               Batch read via multicall (see docs).
  events --contract <0x..> --abi <file.json> [--event <name>] [--from-block <n>] [--to-block <n>]
                                              Fetch contract events.
  broadcast --raw <0xSignedTx> [--wait] [--confirmations 1]
                                              Broadcast a signed raw transaction (requires --yes).

Chain aliases (examples):
  eth|ethereum|mainnet, op|optimism, arb|arbitrum, base, polygon|matic, bsc|binance, avax|avalanche,
  sepolia, op-sepolia, arb-sepolia, base-sepolia, amoy

RPC override priority:
  --rpc > EVM_RPC_<CHAINKEY> (e.g. EVM_RPC_ETHEREUM) > EVM_RPC > built-in defaults
`;
  process.stdout.write(text.trimStart());
  process.stdout.write("\n");
}

async function getClient({ chainAlias, rpc }) {
  const chainKey = normalizeChainAlias(chainAlias);
  if (!chainKey) die(`Missing/invalid --chain. Try: --chain eth`);
  const chain = CHAINS[chainKey];
  if (!chain) die(`Unsupported chain key: ${chainKey}`);

  const uniq = getRpcUrls({ chainKey, rpc });
  if (!uniq.length) die(`No RPC configured for chain: ${chainKey}`);

  // Try RPCs in order and return the first that answers.
  const errors = [];
  for (const url of uniq) {
    try {
      const client = createPublicClient({
        chain,
        transport: http(url, { timeout: 10_000, retryCount: 1 })
      });
      const got = await client.getChainId();
      if (got !== chain.id) {
        throw new Error(`RPC chainId mismatch: expected ${chain.id}, got ${got}`);
      }
      return { client, chain, chainKey, rpcUrl: url };
    } catch (e) {
      errors.push({ url, error: String(e?.message || e) });
    }
  }

  die(
    JSON.stringify(
      {
        error: "All RPC endpoints failed",
        chain: chainKey,
        tried: errors
      },
      null,
      2
    )
  );
}

function reqAddress(label, v) {
  if (!v) die(`Missing --${label}`);
  if (!isAddress(v)) die(`Invalid address for --${label}: ${v}`);
  return v;
}

function reqHash(v) {
  if (!v) die(`Missing --hash`);
  if (!String(v).startsWith("0x") || String(v).length !== 66) die(`Invalid tx hash: ${v}`);
  return v;
}

function reqEnsOnMainnet(chainKey) {
  if (chainKey !== "ethereum") die(`ENS only supported on Ethereum mainnet. Use: --chain eth`);
}

function reqYes(args) {
  if (!args.yes) die(`Refusing to run write op without --yes`);
}

function parseJsonArrayOrDie(label, v) {
  const parsed = tryParseJson(v);
  if (!Array.isArray(parsed)) die(`--${label} must be a JSON array, e.g. --${label} '[\"0x..\"]'`);
  return parsed;
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const cmd = args._[0];
  if (!cmd || cmd === "help" || args.help) return printHelp();

  if (cmd === "rpc") {
    const chainKey = normalizeChainAlias(args.chain);
    if (!chainKey) die(`Missing/invalid --chain. Try: --chain eth`);
    printJson({
      chain: chainKey,
      envOverride: envRpcFor(chainKey),
      builtins: DEFAULT_RPCS[chainKey] || [],
      resolvedPriority: getRpcUrls({ chainKey, rpc: null })
    });
    return;
  }

  if (cmd === "chain-list") {
    const out = {};
    for (const [alias, key] of Object.entries(CHAIN_ALIASES)) {
      out[key] ??= [];
      out[key].push(alias);
    }
    for (const k of Object.keys(out)) out[k].sort();
    printJson({ chains: Object.keys(CHAINS).sort(), aliases: out });
    return;
  }

  if (cmd === "health") {
    const chainKey = normalizeChainAlias(args.chain);
    if (!chainKey) die(`Missing/invalid --chain. Try: --chain eth`);
    const chain = CHAINS[chainKey];
    if (!chain) die(`Unsupported chain key: ${chainKey}`);
    const urls = getRpcUrls({ chainKey, rpc: args.rpc });
    if (!urls.length) die(`No RPC configured for chain: ${chainKey}`);

    const results = [];
    for (const url of urls) {
      const started = Date.now();
      try {
        const c = createPublicClient({
          chain,
          transport: http(url, { timeout: 10_000, retryCount: 1 })
        });
        const [rpcChainId, blockNumber] = await Promise.all([c.getChainId(), c.getBlockNumber()]);
        const ms = Date.now() - started;
        results.push({
          url,
          ok: rpcChainId === chain.id,
          rpcChainId,
          expectedChainId: chain.id,
          blockNumber,
          latencyMs: ms
        });
      } catch (e) {
        const ms = Date.now() - started;
        results.push({ url, ok: false, latencyMs: ms, error: String(e?.message || e) });
      }
    }

    printJson({ chain: chainKey, chainId: chain.id, results });
    return;
  }

  const { client, chainKey, rpcUrl, chain } = await getClient({
    chainAlias: args.chain,
    rpc: args.rpc
  });

  if (cmd === "ens-address") {
    reqEnsOnMainnet(chainKey);
    const name = String(reqArg(args, "name", "e.g. vitalik.eth"));
    const address = await client.getEnsAddress({ name });
    printJson({ chain: chainKey, rpc: rpcUrl, name, address });
    return;
  }

  if (cmd === "ens-name") {
    reqEnsOnMainnet(chainKey);
    const address = reqAddress("address", args.address);
    const name = await client.getEnsName({ address });
    printJson({ chain: chainKey, rpc: rpcUrl, address, name });
    return;
  }

  if (cmd === "chain-info") {
    const [chainId, blockNumber] = await Promise.all([
      client.getChainId(),
      client.getBlockNumber()
    ]);
    printJson({ chain: chainKey, chainId, rpc: rpcUrl, blockNumber });
    return;
  }

  if (cmd === "balance") {
    const address = reqAddress("address", args.address);
    const bal = await client.getBalance({ address });
    printJson({
      chain: chainKey,
      chainId: chain.id,
      rpc: rpcUrl,
      address,
      wei: bal,
      ether: formatEther(bal)
    });
    return;
  }

  if (cmd === "erc20-balance") {
    const address = reqAddress("address", args.address);
    const token = reqAddress("token", args.token);

    const erc20Abi = [
      {
        name: "balanceOf",
        type: "function",
        stateMutability: "view",
        inputs: [{ name: "account", type: "address" }],
        outputs: [{ type: "uint256" }]
      },
      {
        name: "decimals",
        type: "function",
        stateMutability: "view",
        inputs: [],
        outputs: [{ type: "uint8" }]
      },
      {
        name: "symbol",
        type: "function",
        stateMutability: "view",
        inputs: [],
        outputs: [{ type: "string" }]
      }
    ];

    const [raw, decimals, symbol] = await Promise.all([
      client.readContract({
        address: token,
        abi: erc20Abi,
        functionName: "balanceOf",
        args: [address]
      }),
      client.readContract({ address: token, abi: erc20Abi, functionName: "decimals" }),
      client
        .readContract({ address: token, abi: erc20Abi, functionName: "symbol" })
        .catch(() => null)
    ]);

    const dec = Number(decimals);
    printJson({
      chain: chainKey,
      chainId: chain.id,
      rpc: rpcUrl,
      token,
      address,
      raw,
      decimals: dec,
      symbol,
      formatted: formatUnits(raw, dec)
    });
    return;
  }

  if (cmd === "erc20-balances") {
    const address = reqAddress("address", args.address);
    const tokens = parseJsonArrayOrDie("tokens", args.tokens);
    const results = {};
    for (const token of tokens) {
      const t = reqAddress("token", token);
      const sub = await client.readContract({
        address: t,
        abi: [
          {
            name: "balanceOf",
            type: "function",
            stateMutability: "view",
            inputs: [{ name: "account", type: "address" }],
            outputs: [{ type: "uint256" }]
          },
          {
            name: "decimals",
            type: "function",
            stateMutability: "view",
            inputs: [],
            outputs: [{ type: "uint8" }]
          },
          {
            name: "symbol",
            type: "function",
            stateMutability: "view",
            inputs: [],
            outputs: [{ type: "string" }]
          }
        ],
        functionName: "balanceOf",
        args: [address]
      });
      const decimals = await client.readContract({
        address: t,
        abi: [
          {
            name: "decimals",
            type: "function",
            stateMutability: "view",
            inputs: [],
            outputs: [{ type: "uint8" }]
          }
        ],
        functionName: "decimals"
      });
      const symbol = await client
        .readContract({
          address: t,
          abi: [
            {
              name: "symbol",
              type: "function",
              stateMutability: "view",
              inputs: [],
              outputs: [{ type: "string" }]
            }
          ],
          functionName: "symbol"
        })
        .catch(() => null);
      const dec = Number(decimals);
      results[t] = {
        raw: sub,
        decimals: dec,
        symbol,
        formatted: formatUnits(sub, dec)
      };
    }
    printJson({ chain: chainKey, chainId: chain.id, rpc: rpcUrl, address, results });
    return;
  }

  if (cmd === "token-info") {
    const token = reqAddress("token", args.token);
    const tokenInfoAbi = [
      { name: "name", type: "function", stateMutability: "view", inputs: [], outputs: [{ type: "string" }] },
      { name: "symbol", type: "function", stateMutability: "view", inputs: [], outputs: [{ type: "string" }] },
      { name: "decimals", type: "function", stateMutability: "view", inputs: [], outputs: [{ type: "uint8" }] },
      { name: "totalSupply", type: "function", stateMutability: "view", inputs: [], outputs: [{ type: "uint256" }] }
    ];
    const [name, symbol, decimals, totalSupply] = await Promise.all([
      client.readContract({ address: token, abi: tokenInfoAbi, functionName: "name" }),
      client.readContract({ address: token, abi: tokenInfoAbi, functionName: "symbol" }).catch(() => null),
      client.readContract({ address: token, abi: tokenInfoAbi, functionName: "decimals" }),
      client.readContract({ address: token, abi: tokenInfoAbi, functionName: "totalSupply" })
    ]);
    const dec = Number(decimals);
    printJson({
      chain: chainKey,
      chainId: chain.id,
      rpc: rpcUrl,
      token,
      name,
      symbol,
      decimals: dec,
      totalSupply,
      totalSupplyFormatted: formatUnits(totalSupply, dec)
    });
    return;
  }

  if (cmd === "erc721-balance") {
    const collection = reqAddress("collection", args.collection);
    const address = reqAddress("address", args.address);
    const bal = await client.readContract({
      address: collection,
      abi: [
        {
          name: "balanceOf",
          type: "function",
          stateMutability: "view",
          inputs: [{ name: "owner", type: "address" }],
          outputs: [{ type: "uint256" }]
        }
      ],
      functionName: "balanceOf",
      args: [address]
    });
    printJson({ chain: chainKey, chainId: chain.id, rpc: rpcUrl, collection, address, balance: bal });
    return;
  }

  if (cmd === "nft-owner") {
    const nft = reqAddress("nft", args.nft);
    const id = toBigInt(reqArg(args, "id", "tokenId"), null);
    if (id === null) die(`Invalid --id`);
    const owner = await client.readContract({
      address: nft,
      abi: [
        {
          name: "ownerOf",
          type: "function",
          stateMutability: "view",
          inputs: [{ name: "tokenId", type: "uint256" }],
          outputs: [{ type: "address" }]
        }
      ],
      functionName: "ownerOf",
      args: [id]
    });
    printJson({ chain: chainKey, chainId: chain.id, rpc: rpcUrl, nft, tokenId: id, owner });
    return;
  }

  if (cmd === "nft-metadata") {
    const nft = reqAddress("nft", args.nft);
    const id = toBigInt(reqArg(args, "id", "tokenId"), null);
    if (id === null) die(`Invalid --id`);
    const abi = [
      {
        name: "tokenURI",
        type: "function",
        stateMutability: "view",
        inputs: [{ name: "tokenId", type: "uint256" }],
        outputs: [{ type: "string" }]
      },
      {
        name: "name",
        type: "function",
        stateMutability: "view",
        inputs: [],
        outputs: [{ type: "string" }]
      },
      {
        name: "symbol",
        type: "function",
        stateMutability: "view",
        inputs: [],
        outputs: [{ type: "string" }]
      }
    ];
    const [name, symbol, tokenURI] = await Promise.all([
      client.readContract({ address: nft, abi, functionName: "name" }).catch(() => null),
      client.readContract({ address: nft, abi, functionName: "symbol" }).catch(() => null),
      client.readContract({ address: nft, abi, functionName: "tokenURI", args: [id] })
    ]);
    printJson({ chain: chainKey, chainId: chain.id, rpc: rpcUrl, nft, tokenId: id, name, symbol, tokenURI });
    return;
  }

  if (cmd === "erc1155-balance") {
    const token = reqAddress("token", args.token);
    const address = reqAddress("address", args.address);
    const id = toBigInt(reqArg(args, "id", "tokenId"), null);
    if (id === null) die(`Invalid --id`);
    const bal = await client.readContract({
      address: token,
      abi: [
        {
          name: "balanceOf",
          type: "function",
          stateMutability: "view",
          inputs: [
            { name: "account", type: "address" },
            { name: "id", type: "uint256" }
          ],
          outputs: [{ type: "uint256" }]
        }
      ],
      functionName: "balanceOf",
      args: [address, id]
    });
    printJson({ chain: chainKey, chainId: chain.id, rpc: rpcUrl, token, address, tokenId: id, balance: bal });
    return;
  }

  if (cmd === "tx") {
    const hash = reqHash(args.hash);
    const tx = await client.getTransaction({ hash });
    printJson({ chain: chainKey, chainId: chain.id, rpc: rpcUrl, tx });
    return;
  }

  if (cmd === "receipt") {
    const hash = reqHash(args.hash);
    const receipt = await client.getTransactionReceipt({ hash });
    printJson({ chain: chainKey, chainId: chain.id, rpc: rpcUrl, receipt });
    return;
  }

  if (cmd === "wait") {
    const hash = reqHash(args.hash);
    const confirmations = toInt(args.confirmations, 1) ?? 1;
    const receipt = await client.waitForTransactionReceipt({ hash, confirmations });
    printJson({
      chain: chainKey,
      chainId: chain.id,
      rpc: rpcUrl,
      confirmations,
      receipt
    });
    return;
  }

  if (cmd === "estimate-gas") {
    const to = reqAddress("to", args.to);
    const value = args.value ? parseEther(String(args.value)) : undefined;
    const data = args.data ? String(args.data) : undefined;
    const gas = await client.estimateGas({ to, value, data });
    printJson({ chain: chainKey, chainId: chain.id, rpc: rpcUrl, to, value, data, estimatedGas: gas });
    return;
  }

  if (cmd === "gas-price") {
    const [gasPrice, block] = await Promise.all([client.getGasPrice(), client.getBlock()]);
    printJson({
      chain: chainKey,
      chainId: chain.id,
      rpc: rpcUrl,
      gasPrice,
      baseFeePerGas: block.baseFeePerGas ?? null,
      blockNumber: block.number
    });
    return;
  }

  if (cmd === "block") {
    const number = args.number !== undefined ? toBigInt(args.number, null) : null;
    const includeTransactions = Boolean(args.txs);
    const block = await client.getBlock(
      number === null ? { includeTransactions } : { blockNumber: number, includeTransactions }
    );
    printJson({
      chain: chainKey,
      chainId: chain.id,
      rpc: rpcUrl,
      number: block.number,
      hash: block.hash,
      parentHash: block.parentHash,
      timestamp: block.timestamp,
      miner: block.miner,
      gasLimit: block.gasLimit,
      gasUsed: block.gasUsed,
      baseFeePerGas: block.baseFeePerGas ?? null,
      transactions: block.transactions
    });
    return;
  }

  if (cmd === "decode") {
    const abi = await readJsonMaybe(reqArg(args, "abi", "abi json file"));
    const data = String(reqArg(args, "data", "0x..."));
    const decoded = decodeFunctionData({ abi, data });
    printJson({ decoded });
    return;
  }

  if (cmd === "is-contract") {
    const address = reqAddress("address", args.address);
    const bytecode = await client.getBytecode({ address });
    printJson({
      chain: chainKey,
      chainId: chain.id,
      rpc: rpcUrl,
      address,
      isContract: Boolean(bytecode && bytecode !== "0x"),
      bytecodeLength: bytecode ? bytecode.length : 0
    });
    return;
  }

  if (cmd === "simulate") {
    const contract = reqAddress("contract", args.contract);
    const from = reqAddress("from", args.from);
    const abi = await readJsonMaybe(reqArg(args, "abi", "abi json file"));
    const fn = String(reqArg(args, "fn", "functionName"));
    const parsedArgs =
      tryParseJson(args.args) ??
      (args.args ? die(`--args must be valid JSON, e.g. --args '[\"0x..\", 123]'`) : []);

    const sim = await client.simulateContract({
      address: contract,
      abi,
      functionName: fn,
      args: Array.isArray(parsedArgs) ? parsedArgs : die(`--args must be a JSON array`),
      account: from
    });
    printJson({ chain: chainKey, chainId: chain.id, rpc: rpcUrl, simulation: sim });
    return;
  }

  if (cmd === "multicall") {
    const raw = reqArg(args, "calls", "JSON string or JSON file path");
    const payload = isFilePathLike(raw) ? await readJsonMaybe(raw) : tryParseJson(raw);
    if (!payload) die(`--calls must be JSON or a .json file path`);
    const calls = Array.isArray(payload) ? payload : payload.contracts;
    if (!Array.isArray(calls)) die(`--calls JSON must be an array or {\"contracts\": [...]}`);

    const contracts = [];
    for (const c of calls) {
      if (!c || typeof c !== "object") die(`Invalid multicall item`);
      const address = reqAddress("address", c.address);
      let abi = c.abi;
      if (typeof abi === "string") abi = await readJsonMaybe(abi);
      if (!abi) die(`Missing abi for multicall item ${address}`);
      const functionName = String(reqArg(c, "functionName"));
      const argsArr = c.args ?? [];
      contracts.push({ address, abi, functionName, args: argsArr });
    }

    const results = await client.multicall({ contracts, allowFailure: true });
    printJson({ chain: chainKey, chainId: chain.id, rpc: rpcUrl, results });
    return;
  }

  if (cmd === "events") {
    const contract = reqAddress("contract", args.contract);
    const abi = await readJsonMaybe(reqArg(args, "abi", "abi json file"));
    const eventName = args.event ? String(args.event) : undefined;
    const fromBlock = args["from-block"] !== undefined ? toBigInt(args["from-block"], null) : null;
    const toBlock = args["to-block"] !== undefined ? toBigInt(args["to-block"], null) : null;
    const events = await client.getContractEvents({
      address: contract,
      abi,
      eventName,
      fromBlock: fromBlock === null ? undefined : fromBlock,
      toBlock: toBlock === null ? undefined : toBlock
    });
    printJson({ chain: chainKey, chainId: chain.id, rpc: rpcUrl, contract, eventName, fromBlock, toBlock, events });
    return;
  }

  if (cmd === "broadcast") {
    reqYes(args);
    const raw = String(reqArg(args, "raw", "0xSignedTx"));
    if (!raw.startsWith("0x") || raw.length < 10) die(`Invalid --raw signed tx`);

    const hash = await client.request({
      method: "eth_sendRawTransaction",
      params: [raw]
    });

    if (args.wait) {
      const confirmations = toInt(args.confirmations, 1) ?? 1;
      const receipt = await client.waitForTransactionReceipt({
        hash,
        confirmations
      });
      printJson({ chain: chainKey, chainId: chain.id, rpc: rpcUrl, hash, confirmations, receipt });
      return;
    }

    printJson({ chain: chainKey, chainId: chain.id, rpc: rpcUrl, hash });
    return;
  }

  if (cmd === "call") {
    const contract = reqAddress("contract", args.contract);
    if (!args.abi) die(`Missing --abi <file.json>`);
    if (!args.fn) die(`Missing --fn <functionName>`);
    const abi = await readJsonMaybe(args.abi);
    const parsedArgs =
      tryParseJson(args.args) ??
      (args.args ? die(`--args must be valid JSON, e.g. --args '[\"0x..\", 123]'`) : []);

    const result = await client.readContract({
      address: contract,
      abi,
      functionName: String(args.fn),
      args: Array.isArray(parsedArgs) ? parsedArgs : die(`--args must be a JSON array`)
    });

    printJson({
      chain: chainKey,
      chainId: chain.id,
      rpc: rpcUrl,
      contract,
      functionName: String(args.fn),
      args: parsedArgs,
      result
    });
    return;
  }

  die(`Unknown cmd: ${cmd}\n\nRun: node scripts/evm.mjs help`);
}

main().catch((e) => {
  die(String(e?.stack || e));
});
