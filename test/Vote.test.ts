import { loadFixture, ethers, expect } from "./setup";

describe("Vote Test", async function () {
  async function deploy() {
    const names = ["boba", "biba", "beba", "buba"];
    const duration = 300;
    const maxVotes = 10;
    const [owner, user1] = await ethers.getSigners();
    const Factory = await ethers.getContractFactory("Vote");
    const contractVote = await Factory.deploy(names, duration, maxVotes);
    await contractVote.waitForDeployment();

    return { owner, user1, contractVote };
  }

  it("Test", async () => {
    const { owner, user1, contractVote } = await loadFixture(() => deploy());
  });
});
