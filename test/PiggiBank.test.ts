import { loadFixture, ethers, expect } from "./setup";

describe("PiggyBank", function() {
    async function deploy() {
        const [user1, user2] = await ethers.getSigners();

        const Factory = await ethers.getContractFactory("PiggyBank");
        const piggyBank = await Factory.deploy();
        await piggyBank.waitForDeployment();

        return {user1, user2, piggyBank };
    }
    it("Test piggy bank", async function (){
        const {user1, user2, piggyBank} = await loadFixture(deploy);
        const amount = ethers.parseEther("1.0")

        const contractAddress = await piggyBank.getAddress();
        const balanceBefore = await ethers.provider.getBalance(contractAddress);
        console.log(balanceBefore);

        const tx = await user2.sendTransaction({
            to: contractAddress,
            value: amount
        });
        await expect(tx).to.not.reverted;

        const balanceAfter = await ethers.provider.getBalance(contractAddress);
        console.log(balanceAfter);

        await piggyBank.connect(user1).withdraw();
        const balanceAfter2 = await ethers.provider.getBalance(contractAddress);
        console.log(balanceAfter2);

    })


})