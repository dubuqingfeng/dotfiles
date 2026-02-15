import fs from "node:fs/promises";
import path from "node:path";

export function parseArgs(argv) {
  const out = { _: [] };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (!a.startsWith("--")) {
      out._.push(a);
      continue;
    }
    const eq = a.indexOf("=");
    if (eq !== -1) {
      out[a.slice(2, eq)] = a.slice(eq + 1);
      continue;
    }
    const k = a.slice(2);
    const v = argv[i + 1];
    if (!v || v.startsWith("--")) {
      out[k] = true;
      continue;
    }
    out[k] = v;
    i++;
  }
  return out;
}

export function die(msg, code = 1) {
  process.stderr.write(String(msg).trimEnd() + "\n");
  process.exit(code);
}

export function reqArg(args, key, hint = null) {
  const v = args[key];
  if (v === undefined || v === null || v === true || String(v).trim() === "") {
    die(`Missing --${key}${hint ? ` (${hint})` : ""}`);
  }
  return v;
}

export function toInt(x, fallback = null) {
  if (x === undefined || x === null) return fallback;
  const n = Number.parseInt(String(x), 10);
  return Number.isFinite(n) ? n : fallback;
}

export function toBigInt(x, fallback = null) {
  if (x === undefined || x === null) return fallback;
  try {
    // Accept: 123, "123", "0xabc"
    return BigInt(String(x));
  } catch {
    return fallback;
  }
}

export async function readJsonMaybe(filePath) {
  const abs = path.resolve(process.cwd(), filePath);
  const raw = await fs.readFile(abs, "utf8");
  return JSON.parse(raw);
}

export function tryParseJson(x) {
  if (x === undefined || x === null) return null;
  try {
    return JSON.parse(String(x));
  } catch {
    return null;
  }
}

export function isFilePathLike(x) {
  const s = String(x || "");
  return (
    s.endsWith(".json") ||
    s.includes("/") ||
    s.includes("\\") ||
    s.startsWith(".")
  );
}

