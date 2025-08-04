// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.24; // Stating our version

contract SimpleStorage{
    // Basic Types: boolean, uint, int, address, bytes
    uint256 myFavoriteNumber;

    //uint256[] listOfFavoriteNumbers;

    //A new type, each person has a favorite numer and a name.
    struct Person{
        uint256 favoriteNumber;
        string name;
    }

    mapping(string => uint256) public nameToFavoriteNumber;

    Person[] public listOfPeople;

    //Virtuals makes a function overridable
    function store(uint256 _favoriteNumber) virtual public {
        myFavoriteNumber = _favoriteNumber;
    }

    //Adding view disallows modification of state. It just allows reading of something. 'Pure' functions do that and also disallow even reading from state or storage.
    function retrieve() public view returns(uint256){
        return myFavoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listOfPeople.push(Person(_favoriteNumber,_name));// Creating a new person and storing them in the array and adds the person to the array
        nameToFavoriteNumber[_name] = _favoriteNumber; //maps someone's name to their favorite numbers so you can search a name to get their number in this mapping data structure
    }


}