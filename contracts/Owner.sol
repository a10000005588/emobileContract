pragma solidity ^0.4.16;

contract Owenr {
    // when contract deployed to the blockchain, will triiger this owned() function...
    function Owner() public { owner = msg.sender; }
    address owner;
  
    modifier onlyOwner {
        if (msg.sender != owner)
            revert();
        _;
    }
}