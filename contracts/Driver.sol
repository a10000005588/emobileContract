pragma solidity ^0.4.16;

// Every mobile has their own contract name !
contract Driver {  
    struct Drivers{
        uint credit ;     
        bytes32 driverName;
        uint isStore; 
    }

    event DriverInformation(
        address indexed driver, 
        bytes32 driverName, 
        uint256 credit
    );


    mapping(address => Drivers) public driversStruct;
    address[] driverList;
    
    function setDriverInformation(address _driver,bytes32 _driverName, uint256 _credit) 
        public 
    {
        if(driversStruct[_driver].isStore == 0) {
            driverList.push(_driver);
            driversStruct[_driver].isStore = 1;
        }
        driversStruct[_driver].credit = _credit;
        driversStruct[_driver].driverName = _driverName;

        emit DriverInformation(_driver, driversStruct[_driver].driverName, driversStruct[_driver].credit);
    }
    
    function getDriverInformation(address _driver) 
        public   
        view
        returns (uint256, bytes32)
    {
        return (
            driversStruct[_driver].credit,
            driversStruct[_driver].driverName
        );
    }
    
    function giveCreditForDriver(address _driver, uint credit) 
        public
        returns(uint)
    {
        driversStruct[_driver].credit += credit;
        return driversStruct[_driver].credit;
    }
}