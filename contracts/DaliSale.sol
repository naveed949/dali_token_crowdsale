// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract DaliSale is Ownable{
  using SafeMath for uint256;
  IERC20 DALI;
  uint256 public price = 100; // $1 = 100 penny
  uint256 public ethPrice = 2500; // 1 eth = 2500 USDs
  constructor(address token) {
    DALI = IERC20(token);
  }
  function buyDali() payable external {
    uint256 eths_ = msg.value;
  //  uint256 daliPrice_ = calcPrice(); // pass time if price recalculation is time specific
    uint256 totalEthsInPennies = (eths_.mul(ethPrice.mul(100))).div(1 ether);
    uint256 daliAmount_ = (totalEthsInPennies.div(price)).mul(1 ether); 
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
      totalValue_ = (totalValue_.mul(ethPrice.mul(100))).div(1 ether); // ethPrice*100 to make sure price in pennies
      PriceInCents_ = totalValue_.div( ethPrice);
    }
     return PriceInCents_;
  }
function withdrawToBuyNFT(address payable recipient, uint256 value) public onlyOwner {
  require(address(this).balance >= value,"insufficient funds");
  recipient.transfer(value);
  emit Withdraw(recipient, value);
}
function depositProfit(uint256 ethNewPrice) public payable onlyOwner {
  require(ethNewPrice > 0,"invalid eth price, it should be in USD");
  
  uint256 oldPrice;
  ethPrice = ethNewPrice;
  
  emit Deposit(msg.value);
  // price recalculation upon each deposit
  oldPrice = price;
  price = calcPrice();

  emit Price(price, oldPrice);
}


  event Purchase(address indexed buyer, uint256 amount);
  event Withdraw(address recipient, uint256 amount);
  event Deposit(uint256 amount);
  event Price( uint256 newPrice, uint256 oldPrice);
}
