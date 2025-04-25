import { loadFixture, ethers, expect } from "./setup";

describe(" contract SmartCounter", () => {
  async function deploy() {
    const [owner, user1] = await ethers.getSigners();
    const Factory = await ethers.getContractFactory("SmartCounter");
    const contract = await Factory.deploy();
    await contract.waitForDeployment();

    return { owner, user1, contract };
  }

  it("Function increment()", async () => {
    const { owner, user1, contract } = await loadFixture(deploy);

    await contract.setAge(2 ** 256 - 1);
    const tx = await contract.increment();
    await expect(tx).to.reverted;
  });

  it("Function decrement()", async () => {
    const { owner, user1, contract } = await loadFixture(deploy);

    await contract.setAge(1);
    const tx = await contract.decrement();
    //await expect(tx).to.reverted();
  });
});
