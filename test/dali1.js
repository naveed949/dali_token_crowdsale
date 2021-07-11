const dali1 = artifacts.require("DALI");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("dali1", function (/* accounts */) {
  it("should assert true", async function () {
    await dali1.deployed();
    return assert.isTrue(true);
  });
});
