// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.24;

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {

    //Creates a list accepting SimpleStorage contracts
    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageFunction() public {
        SimpleStorage newSimpleStorageContract = new SimpleStorage();

        listOfSimpleStorageContracts.push(newSimpleStorageContract);

    }

    function sfStore (uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {

        //Address is needed
        //ABI - Application Binary Interface is needed. Allows one contract to understand how the contract can be interacted with.
        // If you give it the ABI it will know what it can do

        SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        mySimpleStorage.store(_newSimpleStorageNumber);

    }

    function sfGet (uint256 _simpleStorageIndex) public view returns (uint256) {
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();

    }
}

