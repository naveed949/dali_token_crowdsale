// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
contract DALI is ERC20{
  constructor(string memory name, string memory symbol, uint256 supply_) ERC20(name, symbol) {
    // name DALI
    // symbol DALI
    // supply 100M
    // 1M = 100000000
    _mint(msg.sender, supply_);
  }

}
