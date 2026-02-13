// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.20;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract Found{
    mapping (address => uint256) public au;
    
    AggregatorV3Interface internal dataFeed;

    uint256 constant  MINI_VALUE = 100*10**18;//wei

    uint256 constant TARGET = 200*10**18;

    address public owner;

    uint256 Dtime;

    uint256 lockTime;

    address erc20Addr;

    bool public getFundSuccess = false;

    constructor(uint256 _lockTmie){
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        owner= msg.sender;
         //msg当前交易，block当前区块
        Dtime=block.timestamp;
        lockTime=_lockTmie;
    }

    function foundMe () external  payable   {
        require(convertEthToUsd(msg.value)  > MINI_VALUE , "send more ETH");
        require(block.timestamp<(Dtime+lockTime),"window is closed");
        au[msg.sender]=msg.value;
    }

    // function test() public view returns (uint256)  {
    //     return convertEthToUsd(5);
    // }

    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    function convertEthToUsd(uint256 ethAmount) internal view returns (uint256)   {
        uint256 EthPrice = uint256(getChainlinkDataFeedLatestAnswer());
        return EthPrice * ethAmount / (10**8);

    } 
    function getFund()  external  windowClose{
         require(address(this).balance >= TARGET,"Target is not reached");
         require(msg.sender == owner,"This function can only called by owner");
        //  require(block.timestamp>(Dtime+lockTime),"window is not closed");
        bool success;
        (success,)=payable(msg.sender).call{value: address(this).balance }(""); 
        require(success,"transfer tx failed");
         au[msg.sender]=0;
         getFundSuccess = true;
    }

    function reFund() external windowClose {
        require(address(this).balance < TARGET,"Target is reached");
        require(au[msg.sender]!=0,"there is no fund for you"); 
        // require(block.timestamp>(Dtime+lockTime),"window is not closed");
        bool success;
        (success,)=payable(msg.sender).call{value: au[msg.sender] }(""); 
         require(success,"transfer tx failed");
         au[msg.sender]=0;
    }

    function setFunderToAmount(address funder,uint256 amountToUpdate) external {
        require(msg.sender==erc20Addr,"you do not have permission to call this function");
        au[funder]=amountToUpdate;

    }

    function setErc20Addr(address _erc20Addr) public {
        require(msg.sender == owner,"This function can only called by owner");
        erc20Addr=_erc20Addr;
    }

    modifier windowClose (){
        require(block.timestamp>(Dtime+lockTime),"window is not closed");
        _;
    }
}