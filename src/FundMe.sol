// get funds from users
// withdraw funds
// set minimum funding usd

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    using PriceConverter for uint;

    // instead of normal declaration
    // set it immuatable as we are not defining it and it is not changeable after contract is deployed
    // it will cost us less gas

    // address public owner;
    address private immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    // here we are setting this only one time so instead of using a variable we hould use constant
    // which will save a lot of gas for us

    // uint public minimumAmount = 5 * 1e8;
    uint public constant MINIMUM_AMT = 5 * 1e8;

    // we should make these private for more gas efficiency....now to get values of these we will use getter which are at the end of page
    address[] private s_funders;
    mapping(address => uint) private s_addressToAmtFunded;

    function getVersion() public view returns (uint) {
        return s_priceFeed.version();
    }

    function fund() public payable {
        // allow user to send money with a minimum usd limit

        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_AMT,
            "Send ether more than required amount"
        );
        //1e18=1*10**18, require is neccessary condition, msg.value gives amnt sent in wei

        // if the require statement is not fulfilled then it gets reverted...meaning it goes back to that point before executing the fund function

        s_funders.push(msg.sender);
        s_addressToAmtFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // require(msg.sender==i_owner,"Must be i_owner!!");    we have used modifier so no need

        for (uint i = 0; i < s_funders.length; i++) {
            s_addressToAmtFunded[s_funders[i]] = 0;
        }

        // now empty the s_funders array
        s_funders = new address[](0);

        // three ways to withdraw funds

        // 1.transfer

        // payable(msg.sender).transfer(address(this).balance);

        // 2.send

        // bool sendSuccess=payable(msg.sender).send(address(this).balance);

        // 3.call

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed");
    }

    // to make our function more gas efficient
    function cheaperWithdraw() public onlyOwner {
        uint fundersLength = s_funders.length;
        for (uint i = 0; i < fundersLength; i++) {
            s_addressToAmtFunded[s_funders[i]] = 0;
        }

        s_funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed");
    }

    // instead of writing the condition in every function required ,we can simple create a modifier and add the name of the modifier in any function declaration

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Must be i_owner!!");
        _; //if we put it first then the function will execute and then check the condition
    }

    // if someone send some eth to this contract without calling the fund function
    // example - directly sending eth to the contract addres which we get after deplot=ying the contract
    // doing this will not update the s_funders array abd their balances so-->
    // we use receive and fallback function which are pre defined special function

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // Getters
    function getAddressToAmtFunded(
        address funder
    ) external view returns (uint) {
        return s_addressToAmtFunded[funder];
    }
    function getFunder(uint index) external view returns (address) {
        return s_funders[index];
    }
    function getOwner() external view returns (address) {
        return i_owner;
    }
}
