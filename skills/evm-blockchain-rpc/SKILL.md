---
name: evm-blockchain-rpc
description: EVM blockchain operations including balance queries, block, transactions, token transfers, smart contract interactions, and ENS lookups, and chain health check. Use when working with Ethereum, Polygon, Arbitrum, Optimism, Base, BSC, Avalanche, or other EVM-compatible chains.
allowed-tools: Read, Bash, WebFetch
---

# EVM Blockchain Operations

中文：这是一个面向 EVM 链的 Node.js 命令行工具（基于 `viem`），提供常用的链上查询与调试能力（余额/区块/交易/合约读取等），并预置多条公网 RPC，支持按需覆盖与切换。

English: A Node.js CLI for EVM chains powered by `viem`: it covers common on-chain querying and debugging tasks (balances, blocks, transactions, contract reads, etc.) and includes a set of preconfigured public RPC endpoints with easy overrides and switching.

## Quick Start (Node.js)

```bash
npm i
npm run evm -- help
```

## Supported Chains (Built-In)

- Mainnets: `eth|ethereum|mainnet`, `op|optimism`, `arb|arbitrum`, `base`, `polygon|matic`, `bsc|binance`, `avax|avalanche`
- Testnets: `sepolia`, `op-sepolia`, `arb-sepolia`, `base-sepolia`, `amoy`

要扩展更多链/别名/RPC：编辑 `scripts/rpcs.mjs`（`DEFAULT_RPCS`/别名）和 `scripts/evm.mjs`（`CHAINS`）。

## RPC Configuration

- 覆盖优先级：`--rpc` > `EVM_RPC_<CHAINKEY>`（例如 `EVM_RPC_ETHEREUM`）> `EVM_RPC` > 内置默认
- 查看当前链的内置 RPC + 环境变量覆盖：`npm run evm -- rpc --chain eth`

```bash
EVM_RPC_ETHEREUM=https://eth-mainnet.g.alchemy.com/v2/xxx npm run evm -- chain-info --chain eth
```

## Chain Health / 链健康检查

中文：
- 建议先看最新区块的 `timestamp` 是否接近当前时间（链是否持续出块、RPC 是否同步）。
- `timestamp` 是 Unix 秒；把它和当前时间做差即可。
- 不同链出块时间不同；如果落后“很多分钟”（例如 3-10 分钟以上），通常表示 RPC 卡住/不同步/被限流，建议换 RPC 再试。

English:
- Check whether the latest block `timestamp` is close to “now” (chain is producing blocks and your RPC is synced).
- `timestamp` is Unix seconds; compare it to the current time.
- Block times vary; if the latest block is behind by “many minutes” (e.g. >3–10 minutes), the RPC is often stuck/out-of-sync/rate-limited. Try another RPC.

```bash
npm run evm -- health --chain eth
npm run evm -- block --chain eth
```

## CLI Cheatsheet

### Network / Blocks / Gas

```bash
npm run evm -- chain-list
npm run evm -- chain-info --chain eth
npm run evm -- gas-price --chain eth
npm run evm -- estimate-gas --chain eth --to 0x... --value 0.1
npm run evm -- block --chain eth
npm run evm -- block --chain eth --number 20000000
npm run evm -- block --chain eth --txs
```

### Balances / Tokens / NFTs

```bash
npm run evm -- balance --chain eth --address 0x...
npm run evm -- erc20-balance --chain eth --token 0x... --address 0x...
npm run evm -- erc20-balances --chain eth --address 0x... --tokens '["0x...","0x..."]'
npm run evm -- token-info --chain eth --token 0x...
npm run evm -- erc721-balance --chain eth --collection 0x... --address 0x...
npm run evm -- nft-owner --chain eth --nft 0x... --id 123
npm run evm -- nft-metadata --chain eth --nft 0x... --id 123
npm run evm -- erc1155-balance --chain eth --token 0x... --address 0x... --id 1
```

### ENS (Ethereum Mainnet Only)

```bash
npm run evm -- ens-address --chain eth --name vitalik.eth
npm run evm -- ens-name --chain eth --address 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045
```

### Transactions

```bash
npm run evm -- tx --chain eth --hash 0x...
npm run evm -- receipt --chain eth --hash 0x...
npm run evm -- wait --chain eth --hash 0x... --confirmations 1
```

### Contract Tools

```bash
npm run evm -- call --chain eth --contract 0x... --abi ./abi.json --fn balanceOf --args '["0x..."]'
npm run evm -- is-contract --chain eth --address 0x...
npm run evm -- simulate --chain eth --contract 0x... --abi ./abi.json --fn transfer --args '["0x..","1000000"]' --from 0x...
npm run evm -- decode --abi ./abi.json --data 0x...
npm run evm -- events --chain eth --contract 0x... --abi ./abi.json --event Transfer --from-block 20000000 --to-block 20001000
```

Multicall (JSON string or `.json` file):

```json
{
  "contracts": [
    {
      "address": "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
      "abi": "./erc20.abi.json",
      "functionName": "balanceOf",
      "args": ["0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"]
    }
  ]
}
```

```bash
npm run evm -- multicall --chain eth --calls ./multicall.json
```

## Broadcast Transaction / 广播交易

只负责广播“已签名”的 raw tx（不处理私钥/签名）。

```bash
npm run evm -- broadcast --chain eth --raw 0x... --yes
npm run evm -- broadcast --chain eth --raw 0x... --yes --wait --confirmations 1
```

## Security Notes

- Never expose private keys in code or logs
- Always validate addresses before transactions
- Use testnets for development and testing
- Double-check recipient addresses for transfers
