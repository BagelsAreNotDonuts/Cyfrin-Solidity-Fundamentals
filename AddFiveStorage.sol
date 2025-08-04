
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {SimpleStorage} from "./SimpleStorage.sol";

//Inheritance
//To make a function overridable you need to add virtual to them
contract AddFiveStorage is SimpleStorage {

    //Override function
    function store(uint256 _newNumber) public override {
        myFavoriteNumber = _newNumber + 5;
    }

}
