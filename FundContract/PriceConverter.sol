// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts@1.4.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() internal view returns (uint256){
        //We need the Address for the Sepolia testnet for ETH/USD, 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //We need the ABI

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        //This is the price of ETH in terms of USD
        //msg.value will have 18 decimals. We know that we get 8 decimal places from our answer cause that's just how it returns.
        //So we add on 10 decimals to get the WEI value, the amount of ETH.
        return uint256(answer * 1e10);
      
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() internal view returns (uint256){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();

    }

}