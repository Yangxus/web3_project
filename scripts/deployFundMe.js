const { Contract } = require("ethers")
const { ethers } = require("hardhat")

async function main(){
    const fundMeFactory =await ethers.getContractFactory("Found")
    const FundMe = await fundMeFactory.deploy(10)
    await FundMe.waitForDeployment()
    console.log('合约部署成功，地址：'+FundMe.target)
    if(hre.network.config.chainId== 11155111){
        // 等待 5 个确认
        await FundMe.deploymentTransaction().wait(5)
        await hre.run("verify:verify",{
            address:FundMe.target,
            constructorArguments:[10]
        });
    }
    
}

main().then().catch((error) => {
    console.error(error)
    process.exit(1)
})