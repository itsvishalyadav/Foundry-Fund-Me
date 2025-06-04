// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
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

    function testMinDollar() public view {
        assertEq(fundMe.MINIMUM_AMT(), 5e8);
    }

    function testOwner() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testCorrectPriceFeedVerion() public view {
        uint version = fundMe.getVersion();
        assertEq(version, 4); // Assuming the version is 4, change as per actual version
    }

    function testFundFailDueToLessETH() public {
        vm.expectRevert();
        fundMe.fund(); //no amount send in fund function so it will revert and eventually this test case passes
    }

    function testFundFuncUpdateMapping() public funded {
        //vm.prank(USER); //next txn will be made by USER
        //fundMe.fund{value: AMT_TO_SEND}();         //commenting both lines because of funded modifier
        uint amountFunded = fundMe.getAddressToAmtFunded(USER);
        assertEq(amountFunded, AMT_TO_SEND);
    }

    function testFundFuncUpdateFunders() public funded {
        //vm.prank(USER); //next txn will be made by USER
        //fundMe.fund{value: AMT_TO_SEND}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        // instead of using below lines again and again in different tests
        // we can make a modifier and use that
        // vm.prank(USER);
        // fundMe.fund{value: AMT_TO_SEND}();

        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawFromSingleFunder() public funded {

        // User will fund --> owner will withdraw --> check balances


        // Arrange
        uint ownerInitialBalance = fundMe.getOwner().balance;
        uint contractInitialBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner()); // simulate the owner calling the function
        fundMe.withdraw();

        // Assert
        uint ownerFinalBalance = fundMe.getOwner().balance;
        uint contractFinalBalance = address(fundMe).balance;

        assertEq(
            ownerFinalBalance,
            contractInitialBalance + ownerInitialBalance,
            "Owner balance incorrect after withdrawal"
        );
        assertEq(
            contractFinalBalance,
            0,
            "Contract balance should be zero after withdrawal"
        );
    }

    function testWithdrawFromMultipleFunders() public {
        // no funded modifier used because multiple users will fund now
        // Users will fund --> owner will withdraw --> check balances

        // Arrange
        uint160 noOfFunders = 10;
        uint160 startingFunderIndex = 1;

            // multiple users ko pahle kuch balance denge
            // fir wo users contract me fund karenge
        for (uint160 i = startingFunderIndex; i < noOfFunders; i++) {
            // vm.prank new address
            // vm.deal new address
            // instead of doing  both we have hoax that does both simul
            hoax(address(i), AMT_TO_SEND);  //hoax-->agla txn address(i) karega aur saath me address(i) ko AMT_TO_SEND ether bhi de diye
            fundMe.fund{value: AMT_TO_SEND}();
        }

        uint ownerInitialBalance = fundMe.getOwner().balance;
        uint contractInitialBalance = address(fundMe).balance;

        // Act

        // vm.prank(fundMe.getOwner()); // simulate the owner calling the function
        // fundMe.withdraw();
        // instead of above we can also use
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert
        uint ownerFinalBalance = fundMe.getOwner().balance;
        uint contractFinalBalance = address(fundMe).balance;

        assertEq(
            ownerFinalBalance,
            contractInitialBalance + ownerInitialBalance,
            "Owner balance incorrect after withdrawal"
        );
        assertEq(
            contractFinalBalance,
            0,
            "Contract balance should be zero after withdrawal"
        );
    }

    function testCheaperWithdrawFromMultipleFunders() public {
        // no funded modifier used because multiple users will fund now
        // Users will fund --> owner will withdraw --> check balances

        // Arrange
        uint160 noOfFunders = 10;
        uint160 startingFunderIndex = 1;

            // multiple users ko pahle kuch balance denge
            // fir wo users contract me fund karenge
        for (uint160 i = startingFunderIndex; i < noOfFunders; i++) {
            // vm.prank new address
            // vm.deal new address
            // instead of doing  both we have hoax that does both simul
            hoax(address(i), AMT_TO_SEND);  //hoax-->agla txn address(i) karega aur saath me address(i) ko AMT_TO_SEND ether bhi de diye
            fundMe.fund{value: AMT_TO_SEND}();
        }

        uint ownerInitialBalance = fundMe.getOwner().balance;
        uint contractInitialBalance = address(fundMe).balance;

        // Act

        // vm.prank(fundMe.getOwner()); // simulate the owner calling the function
        // fundMe.withdraw();
        // instead of above we can also use
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        // Assert
        uint ownerFinalBalance = fundMe.getOwner().balance;
        uint contractFinalBalance = address(fundMe).balance;

        assertEq(
            ownerFinalBalance,
            contractInitialBalance + ownerInitialBalance,
            "Owner balance incorrect after withdrawal"
        );
        assertEq(
            contractFinalBalance,
            0,
            "Contract balance should be zero after withdrawal"
        );
    }

    modifier funded() {
        vm.prank(USER); //next txn will be made by USER
        fundMe.fund{value: AMT_TO_SEND}();
        _;
    }
}
