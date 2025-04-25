import { loadFixture, ethers, expect } from "./setup";

//npx hardhat test - run test in console

describe("Payments", function () {
  async function deploy() {
    const [user1, user2] = await ethers.getSigners();

    const Factory = await ethers.getContractFactory("Payments");
    // payments - binding to the contract. Allows calling functions from the "Payments" contract.
    const payments = await Factory.deploy();
    await payments.waitForDeployment();

    return { user1, user2, payments };
  }

  it("What should the test do", async function () {
    const { user1, user2, payments } = await loadFixture(deploy);

    console.log(await payments.getAddress());
    console.log(user1.address);
    //payments.target returns the contract address. The line checks the asress for correctness
    expect(payments.target).to.be.properAddress;
  });

  it("Balance equal 0?", async function () {
    const { user1, user2, payments } = await loadFixture(deploy);

    payments.currentBalance();
  });

  it("should be possible to send funds", async function () {
    const { user1, user2, payments } = await loadFixture(deploy);
    const sum = 100000000000000; //wei
    const msg = "hello from hardhat";

    //console.log(await ethers.provider.getBalance(user1.address));
    const tx = await payments.connect(user2).pay(msg, { value: sum });
    //console.log(await ethers.provider.getBalance(user1.address));
    //console.log(await ethers.provider.getBalance(user2.address));

    await tx.wait(1);

    await expect(tx).to.changeEtherBalance(user2, -sum);
    const newPayment = await payments.getPayment(user2.address, 0)

    expect(newPayment.timestamp)

  });
});
