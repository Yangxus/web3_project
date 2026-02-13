// const { EtherscanPlugin } = require("ethers");

require("@nomicfoundation/hardhat-toolbox");
// require("dotenv").config({quiet: true});
require("@chainlink/env-enc").config();
const SEPOLIA_URL=process.env.SEPOLIA_URL
const PRIVATE_KEY=process.env.PRIVATE_KEY
const ECKYE= process.env.ECKYE
module.exports = {
  // defaultNetwork:"hardhat",
  solidity: "0.8.28",
  networks:{
    sepolia:{
      url:SEPOLIA_URL,
      accounts:[PRIVATE_KEY],
      chainId:11155111
    }
  },
  etherscan:{
    apiKey:ECKYE
  }
};
