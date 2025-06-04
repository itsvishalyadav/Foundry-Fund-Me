// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // for this we need two things
        // 1.Address--(from chainlink,ETH/USD)--0x694AA1769357215DE4FAC081bf1f309aDC325306
        // 2.ABI

        (, int256 ethInUSD,,,) = priceFeed.latestRoundData();
        return uint256(ethInUSD);
    }

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 valueInUSD = (ethPrice * ethAmount) / 1e18;
        return valueInUSD;
    }
}
