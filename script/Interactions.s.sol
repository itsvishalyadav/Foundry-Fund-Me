// interactions script is to interact with our contract in all ways-->
// like funding,withdrawing etc...

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

// we can allow foundry to run command from our machine
// to do that turn on ffi to true in foundry.toml

contract FundFundMe is Script {
    // forge script script/Interactions.s.sol:FundFundMe --rpc-url <YOUR_RPC> --broadcast

    uint256 AMT_TO_SEND = 0.1 ether;

    function fundFundMe(address mostRecentDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).fund{value: AMT_TO_SEND}();
        vm.stopBroadcast();
    }

    function run() external {
        // This script will be used to fund the FundMe contract
        // You can add the logic to interact with the FundMe contract here
        // For example, you can call the fund function with a specific amount
        // and address of the FundMe contract

        // we want to fund the most recent deployed contract
        // so we will use the some foundry-devops tools which helps to keep track of most recently deployed contract
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);

        fundFundMe(mostRecentDeployed);
    }
}

contract WithdrawFundMe is Script {
    // forge script script/Interactions.s.sol:fundFundMe
    uint256 public constant AMT_TO_SEND = 0.1 ether;

    function withdrawFundMe(address mostRecentDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        // This script will be used to fund the FundMe contract
        // You can add the logic to interact with the FundMe contract here
        // For example, you can call the fund function with a specific amount
        // and address of the FundMe contract

        // we want to fund the most recent deployed contract
        // so we will use the some foundry-devops tools which helps to keep track of most recently deployed contract
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);

        withdrawFundMe(mostRecentDeployed);
    }
}
