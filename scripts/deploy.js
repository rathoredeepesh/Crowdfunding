const hre = require("hardhat");

async function main() {
  const goal = hre.ethers.utils.parseEther("10"); // 10 ETH goal
  const durationInDays = 7;

  const CrowdFund = await hre.ethers.getContractFactory("CrowdFund");
  const crowdFund = await CrowdFund.deploy(goal, durationInDays);

  await crowdFund.deployed();

  console.log(`CrowdFund deployed to: ${crowdFund.address}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
