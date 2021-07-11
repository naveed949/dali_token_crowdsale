// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract DaliSale is Ownable{
  using SafeMath for uint256;
  IERC20 DALI;
  uint256 price = 100; // $1 = 100 penny
  uint256 ethPrice = 250000; // 1 eth = 250000 pennies
  constructor(address token) {
    DALI = IERC20(token);
  }
  function buyDali() payable public {
    uint256 eths_ = msg.value;
  //  uint256 daliPrice_ = calcPrice(); // pass time if price recalculation is time specific
    uint256 daliAmount_ = eths_.mul(price); // eths_.div(price);
    require(daliAmount_ > 0, "insufficient value sent"); 

    DALI.transfer(msg.sender, daliAmount_);
    emit Purchase(msg.sender, daliAmount_);
  }

  function calcPrice() private view returns(uint256){
    uint256 totalValue_ = address(this).balance;
    uint256 PriceInCents_;
    if(totalValue_ < 1 ether){
      PriceInCents_ = 100; // $1
    } else{
      PriceInCents_ = totalValue_.div(ethPrice);
    }
     return PriceInCents_;
  }
function withdrawToBuyNFT(address payable recipient, uint256 value) public onlyOwner {
  require(address(this).balance >= value,"insufficient funds");
  recipient.transfer(value);
  emit Withdraw(recipient, value);
}
function depositProfit() public payable onlyOwner {
  emit Deposit(msg.value);
  // recalculation upon each deposit
  minPrice = calcPrice();
}


  event Purchase(address indexed buyer, uint256 amount);
  event Withdraw(address recipient, uint256 amount);
  event Deposit(uint256 amount);
}
