//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import  "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MYTOKEN is ERC20 {
   constructor(uint256 INITIAL_SUPPLY) ERC20("MYTOKEN","MTK"){
       _mint(msg.sender, INITIAL_SUPPLY);
   }
}