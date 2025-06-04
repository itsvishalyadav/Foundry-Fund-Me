// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe,WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    // we have created a dummy user who will mock to send transacctions
    // used to remove confusion of where to use msg.sender and where address(this)
    address USER = makeAddr("user");
    // we also have to give him some balance to start with
    uint public constant STARTING_BALANCE = 10 ether;

    uint public constant AMT_TO_SEND = 0.1 ether;

    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public{
        FundFundMe fundFundMe=new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe=new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance==0);
    }
}
