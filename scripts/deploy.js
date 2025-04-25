const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  const NDToken = await hre.ethers.getContractFactory("NDToken");
  const ndToken = await NDToken.deploy(deployer.address);
  await ndToken.deployed();
  console.log("NDToken deployed to:", ndToken.address);

  const TokenSale = await hre.ethers.getContractFactory("TokenSale");
  const tokenSale = await TokenSale.deploy(ndToken.address, deployer.address);
  await tokenSale.deployed();
  console.log("TokenSale deployed to:", tokenSale.address);

  const tx = await ndToken.transfer(tokenSale.address, hre.ethers.utils.parseUnits("50000000", 18));
  await tx.wait();
  console.log("Transferred 50 million ND to TokenSale contract");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
