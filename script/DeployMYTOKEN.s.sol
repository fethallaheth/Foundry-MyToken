//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {MYTOKEN} from "../src/MYTOKEN.sol";

contract DeployMyToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;
    function run() public returns(MYTOKEN){
        vm.startBroadcast();
            MYTOKEN myToken = new MYTOKEN(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return myToken;
    }
}