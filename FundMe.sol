// Get funds from users
// Withdraw Funds
//Set a maximum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts@1.4.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

//This interface allows my contract to know WHAT functions it can call on the Chainlink aggregator contract.
//For instance I can call version and get the version of the Aggregator from the deployed contract that exists. 
//You can import the interface from Chainlink's github without needing a local copy of it.

// interface AggregatorV3Interface {
//   function decimals() external view returns (uint8);

//   function description() external view returns (string memory);

//   function version() external view returns (uint256);

//   function getRoundData(
//     uint80 _roundId
//   ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

//   function latestRoundData()
//     external
//     view
//     returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
// }

contract FundMe {

    //Since we want to get the actual value of 5 dollars of ETH from the internet, external to the blockchain, we can use an Oracle.
    //We can use Chainlink Data Feeds
    uint256 public minimumUsd = 5e18; //We make it $5 with 18 decimals places to match up with our require's conversion rate, since it will return a number with 18 decimals

    address[] public funders;
    //We create a mapping which maps a funder to an amount funded, and we access it via the variable, addressToAmountFunded
    mapping(address funders => uint256 amountFunded) public addressToAmountFunded;

    //Making something payable allows for actual ETH to be sent
    function fund() public payable {
    //Allow users to send $
    //Have a minumum $ sent
    //1. How do we send ETH to this contract?
    //more than 1 ETH is required for funding. The Fund function will be run, but once it hits the require, it will revert the changes if the conditions are not met and refund gas.
    require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough"); // 1e18 = 1 ETH = 1000000000000000000 WEI = 1 * 10 ** 18, exponent, it means 1 followed by 18 zeros
    //We can push the address of who sent us the money to an array
    funders.push(msg.sender);
    //finds the key, the address of the funder, adds the value, the number of WEI
    addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;


    }

    function withdraw() public{}

    function getPrice() public view returns (uint256){
        //We need the Address for the Sepolia testnet for ETH/USD, 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //We need the ABI

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        //This is the price of ETH in terms of USD
        //msg.value will have 18 decimals. We know that we get 8 decimal places from our answer cause that's just how it returns.
        //So we add on 10 decimals to get the WEI value, the amount of ETH.
        return uint256(answer * 1e10);
      
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() public view returns (uint256){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();

    }

    //0x694AA1769357215DE4FAC081bf1f309aDC325306

}