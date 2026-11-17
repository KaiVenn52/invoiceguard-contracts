// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
/// @notice Local-test fixture only. Never substituted for official tUSD8 on testnet.
contract TestToken {
    string public constant name = "Local test token"; uint8 public constant decimals = 6;
    mapping(address=>uint256) public balanceOf;
    mapping(address=>mapping(address=>uint256)) public allowance;
    bool public taxed;
    function setTaxed(bool v) external { taxed=v; }
    function mint(address to,uint256 n) external { balanceOf[to]+=n; }
    function approve(address to,uint256 n) external returns(bool) { allowance[msg.sender][to]=n;return true; }
    function transferFrom(address from,address to,uint256 n) external returns(bool) { require(balanceOf[from]>=n&&allowance[from][msg.sender]>=n,"funds/allowance");allowance[from][msg.sender]-=n;balanceOf[from]-=n;balanceOf[to]+=taxed?n-1:n;return true; }
}
