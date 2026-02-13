//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FundToken {
    //1.通证名字
    string public tokenName;
    //2.通证简称
    string public tokenSymbol;
    //3.通证发行的数量
    uint256 public totalSupply;
    //4.owner地址
    address public owner;
    //5.balance address =>uint256
    mapping(address => uint256) public balances;

    constructor(string memory _tokenName,string memory _tokenSymbol){
        tokenName=_tokenName;
        tokenSymbol=_tokenSymbol;
        owner=msg.sender;
    }

    //获取通证
    function mint(uint256 amountToMint) public  {
        balances[msg.sender] += amountToMint;
        totalSupply += amountToMint;
    }

    //transfer同证
    function transfer(address payee, uint256 amount) public {
        require(balances[msg.sender] >= amount, "you do not have enough balance to transfer");
        balances[msg.sender] -=amount;
        balances[payee] +=amount;

    }
    
    //查看某一个地址的通证数量
    function balanceOf(address addr) public view returns(uint256) {
        return balances[addr];
    } 

}