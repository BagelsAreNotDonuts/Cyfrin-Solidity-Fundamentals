// Get funds from users
// Withdraw Funds
//Set a maximum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//We move our functions involving the aggregator and price into a library so that we can use them on all uint256
import {PriceConverter} from "./PriceConverter.sol";

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

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    //Since we want to get the actual value of 5 dollars of ETH from the internet, external to the blockchain, we can use an Oracle.
    //We can use Chainlink Data Feeds
    uint256 public constant MINIMUM_USD = 5e18; //We make it $5 with 18 decimals places to match up with our require's conversion rate, since it will return a number with 18 decimals
    //Typically you use all caps and underscores for constant variable naming. Using const reduces gas costs.

    address[] public funders;
    //We create a mapping which maps a funder to an amount funded, and we access it via the variable, addressToAmountFunded
    mapping(address funders => uint256 amountFunded) public addressToAmountFunded;

    //Remember, constructors are functions that are called immediately upon deploying.
    //We want to set it so that this contract has an owner, and only that owner address can call withdraw.
    address public immutable i_owner;
    //immutable makes it cost less gas
    constructor() {
        i_owner = msg.sender;
    }

    //Making something payable allows for actual ETH to be sent
    function fund() public payable {
    //Allow users to send $
    //Have a minumum $ sent
    //1. How do we send ETH to this contract?
    //more than 1 ETH is required for funding. The Fund function will be run, but once it hits the require, it will revert the changes if the conditions are not met and refund gas.
    require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough"); // 1e18 = 1 ETH = 1000000000000000000 WEI = 1 * 10 ** 18, exponent, it means 1 followed by 18 zeros
    // Since getConversionRate is from our library and acts upon all uint256, which msg is, msg will be able to use it. And msg will be passed to the first parameter in it.


    //We can push the address of who sent us the money to an array
    funders.push(msg.sender);
    //finds the key, the address of the funder, adds the value, the number of WEI
    addressToAmountFunded[msg.sender] += msg.value;


    }

    function withdraw() public onlyOwner{
        //When we withdraw we want to set all the funders' amounts to zero.
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){ 
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        //Completely reset the array
        funders = new address[](0);

        //actually withdraw funds to the requested address

        // 3 methods to do this
        //We need to change msg.sender from a normal address to a payable address.

        //transfer, if transfer fails, sends an error automatically reverses
        //payable(msg.sender).transfer(address(this /*this refers to the ENTIRE contract*/).balance);
        //send, if transfer fails returns a bool, we need to add the error handling and revert manually
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess, "Send failed.");
        //call, returns two variables, but we only care about one. Data returned is in bytes, so it'd be bytes memory dataReturned. Bytes is an array, so memory defined that we put in memory.
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}(""); 
        //The ("") is the payload of the call, it is empty because we are only sending ether. If we weren't we could put in a function signature to trigger some function in the recipient contract if that is needed. Like updating some status for them when they recieve the money.
        require(callSuccess, "Call failed");
    }

    //So that we can apply this property to any function we want, like withdraw.
    modifier onlyOwner() {
        if(msg.sender == i_owner){revert NotOwner();}
        //Using custom errors can replace 'require'keywords because it is more gas efficient.

        //The _; means execute the code inside the functiion AFTER the modifier. You can change the order.
        _;
    }

    //What happens if someone sends ETH without calling the fund function?
    //Solidity has two special functions.
    //From here, the address that sent us money will automatically be routed to the fund function.
    receive() external payable {
        fund();
    }
    fallback() external payable {
        fund();
    }

}