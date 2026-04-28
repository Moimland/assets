// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IWBNB} from "../interfaces/IWBNB.sol";

contract PancakeRouter {
    error Expired();
    error InvalidPath();

    address public immutable factory;
    address public immutable WBNB;

    constructor(address _factory, address _wbnb) {
        factory = _factory;
        WBNB = _wbnb;
    }

    modifier ensure(uint256 deadline) {
        if (deadline < block.timestamp) revert Expired();
        _;
    }

    // NOTE: placeholder signatures for next implementation step.
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external ensure(deadline) returns (uint256 amountA, uint256 amountB, uint256 liquidity) {
        tokenA; tokenB; amountADesired; amountBDesired; amountAMin; amountBMin; to;
        return (0, 0, 0);
    }

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external ensure(deadline) returns (uint256[] memory amounts) {
        if (path.length < 2) revert InvalidPath();
        amountIn; amountOutMin; to;
        amounts = new uint256[](path.length);
    }

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable ensure(deadline) returns (uint256[] memory amounts) {
        if (path.length < 2 || path[0] != WBNB) revert InvalidPath();
        IWBNB(WBNB).deposit{value: msg.value}();
        amountOutMin; to;
        amounts = new uint256[](path.length);
    }
}
