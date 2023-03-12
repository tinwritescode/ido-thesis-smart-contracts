import { BigNumber } from "ethers";
import { ethers, network } from "hardhat";
import { deployContract } from "../test/utils";

async function main() {
  const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const unlockTime = currentTimestampInSeconds + 60;

  const lockedAmount = ethers.utils.parseEther("0.001");

  const timeUnitInSecs = 60;
  const rewardRatio = {
    numerator: 1,
    denominator: 10000,
  };
  const totalSupply = BigNumber.from("1000000000");
  const lockTime = ONE_YEAR_IN_SECS;

  const address: Record<string, string> = {};
  address["stakingToken"] = await deployContract(
    "Erc20",
    totalSupply,
    "HCMUS IT Token",
    "HIT"
  );
  address["rewardToken"] = address["stakingToken"];

  switch (network.name) {
    case "hardhat": {
      address["WETH"] = await deployContract(
        "Erc20",
        totalSupply,
        "Wrapped Ether",
        "WETH"
      );
      break;
    }
    case "polygonMumbai": {
      address["WETH"] = "0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889"; // WMATIC
    }
  }

  const Staking = await ethers.getContractFactory("Staking");
  const stakingContract = await Staking.deploy(
    timeUnitInSecs,
    rewardRatio.numerator,
    rewardRatio.denominator,
    address["stakingToken"],
    address["rewardToken"],
    address["WETH"],
    lockTime
  );

  await stakingContract.deployed();

  console.log("Staking deployed to:", stakingContract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
