//SPDX-License-Identifier:MIT

pragma  solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Found} from "./test.sol";

contract FundTokenERC20 is ERC20 {
    Found fundMe;
   constructor(address foundMeAddr) ERC20("FundTokenERC20","FT"){
        fundMe =Found(foundMeAddr); 
   } 

   function mint(uint256 amoutToMint) public  {
        require(fundMe.au(msg.sender)>=amoutToMint,"you cannot mint this many tokens");
        require(fundMe.getFundSuccess(),"The fundme is not complated yet");//getter
        _mint(msg.sender,amoutToMint);
        fundMe.setFunderToAmount(msg.sender,fundMe.au(msg.sender) - amoutToMint );
   }

   function claim(uint256 amountToClaim) public {
     require(balanceOf(msg.sender)>=amountToClaim,"You do not have enough ERC20 tokens");
     require(fundMe.getFundSuccess(),"The fundme is not complated yet");//getter
     _burn(msg.sender, amountToClaim);
   }
}