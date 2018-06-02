import "./Driver.sol";
pragma solidity ^0.4.16;

contract Emoto {
    int numberOfEmotos;
    address fundContractAddress;
    address driverContractAddress;

    constructor (address _driverContractAddress, address _fundContractAddress) public {
        driverContractAddress = _driverContractAddress;
        fundContractAddress = _fundContractAddress;
        Driver(driverContractAddress);
    }

    struct Emotos {
        bytes32 plate;  // mobile license-plate
        bytes32 driverName;
        address driverAddress;
        uint isStore;
        bool isLock;
    }
    
    mapping(address => Emotos) public emotoStruct;
    address[] emotoList; // list of question keys so we can enumerate them

    function setEmotoInfomation(
        address _emoto, 
        bytes32 _plate, 
        bytes32 _driverName,
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
    
    function setFundAddress(address _fundContractAddress)
        public
    {
        fundContractAddress = _fundContractAddress;
    }
    
    function getFundAddress()
        public
        view
        returns (address)
    {
        return fundContractAddress;
    }
    
    function getMobileInformation(address _emoto) 
        public
        view
        returns(bytes32, bytes32, address, bool) 
    {
        return (
            emotoStruct[_emoto].plate,
            emotoStruct[_emoto].driverName,
            emotoStruct[_emoto].driverAddress,
            emotoStruct[_emoto].isLock
        );
    }
    
    function createPayment(uint256 credit, address driverAddress) 
        public
        payable
    {
        // check whether the passenger has enough ether or not.
        if(msg.sender.balance <= msg.value) {
            revert("Money isn't enough!");
        }

        Driver(driverContractAddress).giveCreditForDriver(driverAddress,credit);
        fundContractAddress.transfer(msg.value);
    }
    
    function () 
        public 
        payable 
    {
    }
}