// Default public RPC endpoints (best-effort).
// These may rate-limit; callers can override via --rpc or env vars.

export const CHAIN_ALIASES = {
  eth: "ethereum",
  ethereum: "ethereum",
  mainnet: "ethereum",

  op: "optimism",
  optimism: "optimism",

  arb: "arbitrum",
  arbitrum: "arbitrum",

  base: "base",

  polygon: "polygon",
  matic: "polygon",

  bsc: "bsc",
  binance: "bsc",

  avax: "avalanche",
  avalanche: "avalanche",

  sepolia: "sepolia",
  "op-sepolia": "optimismSepolia",
  "optimism-sepolia": "optimismSepolia",
  "arb-sepolia": "arbitrumSepolia",
  "arbitrum-sepolia": "arbitrumSepolia",
  "base-sepolia": "baseSepolia",
  amoy: "polygonAmoy",
  "polygon-amoy": "polygonAmoy",
};

// Order matters: earlier URLs are preferred.
export const DEFAULT_RPCS = {
  ethereum: ["https://eth.llamarpc.com", "https://ethereum.publicnode.com"],
  optimism: ["https://mainnet.optimism.io", "https://optimism.publicnode.com"],
  arbitrum: [
    "https://arb1.arbitrum.io/rpc",
    "https://arbitrum-one.publicnode.com",
    "https://rpc.ankr.com/arbitrum",
  ],
  base: ["https://mainnet.base.org", "https://base.publicnode.com"],
  polygon: ["https://polygon-rpc.com", "https://polygon-bor.publicnode.com"],
  bsc: ["https://bsc-dataseed.binance.org", "https://bsc.publicnode.com"],
  avalanche: [
    "https://api.avax.network/ext/bc/C/rpc",
    "https://avalanche-c-chain.publicnode.com",
  ],
  sepolia: [
    "https://rpc.sepolia.org",
    "https://ethereum-sepolia.publicnode.com",
  ],
  optimismSepolia: [
    "https://sepolia.optimism.io",
    "https://optimism-sepolia.publicnode.com",
  ],
  arbitrumSepolia: [
    "https://sepolia-rollup.arbitrum.io/rpc",
    "https://arbitrum-sepolia.publicnode.com",
  ],
  baseSepolia: [
    "https://sepolia.base.org",
    "https://base-sepolia.publicnode.com",
  ],
  polygonAmoy: [
    "https://rpc-amoy.polygon.technology",
    "https://polygon-amoy.publicnode.com",
  ],
};

export function normalizeChainAlias(input) {
  const k = String(input || "").trim();
  if (!k) return null;
  return CHAIN_ALIASES[k] || null;
}

export function envRpcFor(chainKey) {
  // Allow: EVM_RPC, EVM_RPC_ETH, EVM_RPC_ETHEREUM, etc.
  const upper = String(chainKey || "").toUpperCase();
  return process.env.EVM_RPC || process.env[`EVM_RPC_${upper}`] || null;
}
