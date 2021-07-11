// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
contract DALI {
  constructor(string memory name, string memory symbol) ERC20(name, symbol) public {
    // name DALI
    // symbol DALI
    // supply 100M
    // 1M = 100000000
  }

}
