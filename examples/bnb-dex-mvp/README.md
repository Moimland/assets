# Next Step: PancakeSwap V2-style BNB DEX Scaffold

This folder adds a concrete **next step** after the MVP guide: a minimal Solidity scaffold to start coding immediately.

## Included

- `contracts/core/PancakeFactory.sol`
  - `createPair(tokenA, tokenB)`
  - sorted token storage and reverse lookup in `getPair`
- `contracts/core/PancakePair.sol`
  - pair initialization and reserve state placeholders
- `contracts/periphery/PancakeRouter.sol`
  - deadline guard and starter swap/addLiquidity signatures
- `contracts/interfaces/IWBNB.sol`
  - BNB wrapping interface for router integration

## What to implement next

1. Add ERC-20 interactions (`transferFrom`, `transfer`) and LP token mint/burn.
2. Implement AMM invariant math (`x*y=k`) + 0.25% fee in pair swap path.
3. Add router quoting/library methods (`getAmountsOut`, `getAmountsIn`).
4. Write Foundry tests for:
   - pair creation constraints,
   - add/remove liquidity,
   - single/multi-hop swaps,
   - deadline and slippage reverts.

## Notes

- This is intentionally a **scaffold**, not production-ready DEX logic.
- Audit and fuzzing are mandatory before any mainnet deployment.
