const DALI = artifacts.require("DALI");
const SALE = artifacts.require("DaliSale");
const truffleAssert = require('truffle-assertions');

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("DALI-SALE", function ( accounts) {
  let Dali;
  let Sale;
  let owner = accounts[0]
  let investerA = accounts[1]
  let investerB = accounts[1]
  let user = accounts[2]

  it("should deploy DALI & Crowdfunding contracts", async function () {
    let name = 'DALI'
    let symbol = 'DALI'
    let supply = web3.utils.toWei("100000000")
   Dali =  await DALI.new(name,symbol,supply, {from: owner});
   Sale = await SALE.new(Dali.address, {from: owner});
   // transfering DALI tokens to Sale contract for sale
   let tx = await Dali.transfer(Sale.address, web3.utils.toWei("1000000"))
   assert.exists((Dali.address && Sale.address));
  
  });
  it("investerA should invest 1 Eth", async function () {
    
   let tx = await Sale.buyDali({from: investerA, value: web3.utils.toWei("1")})
   truffleAssert.eventEmitted(tx, 'Purchase', async (ev)=>{
    console.log("investerA got: "+web3.utils.fromWei(ev.amount)+" DALI")
     return ev.buyer == investerA && ev.amount.toString() == "2500"
   })
  
  });
  it("investerB should invest 1 Eth", async function () {
    
    let tx = await Sale.buyDali({from: investerB, value: web3.utils.toWei("1")})
    truffleAssert.eventEmitted(tx, 'Purchase', async (ev)=>{
      console.log("investerB got: "+web3.utils.fromWei(ev.amount)+" DALI")
      return ev.buyer == investerB && ev.amount.toString() == "2500"
    })
   
   });
   it("Platform should withdraw 1 ETH to buy&sell NFT", async function () {
    let amount = web3.utils.toWei("1")
    let tx = await Sale.withdrawToBuyNFT(owner, amount, {from: owner})
    truffleAssert.eventEmitted(tx, 'Withdraw', async (ev)=>{
      return ev.recipient == owner && ev.amount.toString() == amount
    })
   
   });
   it("Deposit profit of 100% i.e 2 ETH", async function () {
    let amount = web3.utils.toWei("1")
    let ethPrice = '2500'
    let oldPrice = await Sale.price()
    let tx = await Sale.depositProfit(ethPrice,  {from: owner, value: amount})
    let newPrice = await Sale.price()
    truffleAssert.eventEmitted(tx, 'Price', async (ev)=>{
      console.log("New Price of DALIA in Cents: "+ newPrice.toString())
      return ev.newPrice.toString() == newPrice.toString() && ev.oldPrice.toString() == oldPrice.toString()
    })
   
   });
   it("investerA should invest 1 Eth", async function () {
    
    let tx = await Sale.buyDali({from: investerA, value: web3.utils.toWei("1")})
    truffleAssert.eventEmitted(tx, 'Purchase', async (ev)=>{
      console.log("investerA got: "+web3.utils.fromWei(ev.amount)+" DALI")
      return ev.buyer == investerA && ev.amount.toString() == "1250"
    })
  });
});