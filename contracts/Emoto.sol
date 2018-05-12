pragma solidity ^0.4.16;

contract Emoto {
    int numberOfEmotos;
    address fundAddress;
    
    struct Emotos {
        bytes plate;  // mobile license-plate
        string driverName;
        address driverAddress;
        uint isStore;
        bool isLock;
    }
    
    mapping(address => Emotos) public emotoStruct;
    address[] emotoList; // list of question keys so we can enumerate them

    function setEmotoInfomation(
        address _emoto, 
        bytes _plate, 
        string _driverName,
        address _driverAddress
    ) 
        public 
    {
         // if no data in list, push into the emotoList...
        if(emotoStruct[_emoto].isStore == 0) {
            emotoList.push(_emoto);
            emotoStruct[_emoto].isStore = 1;
        }
        emotoStruct[_emoto].driverName = _driverName;
        emotoStruct[_emoto].driverAddress = _driverAddress;
        emotoStruct[_emoto].plate = _plate;
    }
    
    function setFundAddress(address _fundAddress)
        public
    {
        fundAddress = _fundAddress;
    }
    
    function getFundAddress()
        public
        view
        returns (address)
    {
        return fundAddress;
    }
    
    function getMobileInformation(address _emoto) 
        public
        view
        returns(bytes, string, address, bool) 
    {
        return (
            emotoStruct[_emoto].plate,
            emotoStruct[_emoto].driverName,
            emotoStruct[_emoto].driverAddress,
            emotoStruct[_emoto].isLock
        );
    }
    
    function payFee(uint256 _price) 
        public 
        payable 
    {
        // check whether the passenger has enough ether or not.
        if(msg.sender <= 0) {
            revert("No money");
        }
        // input the mobile and passenger's address
        // and caculated the milage and get price
        fundAddress.transfer(_price);
    }
    
    function () 
        public 
        payable 
    {
    }
}