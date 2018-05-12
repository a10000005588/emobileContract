pragma solidity ^0.4.16;

// Every mobile has their own contract name !
contract Driver {  
    struct Drivers{
        uint credit ;     
        string driverName;
        string phone;
        address driverAddress;
        uint isStore;
        
    }
    
    mapping(address => Drivers) public driversStruct;
    address[] driverList;
    
    function setDriver(address _driver,string _driverName ,uint256 _credit, address _driverAddress, string _phone) 
        public 
    {
        if(driversStruct[_driver].isStore == 0) {
            driverList.push(_driver);
            driversStruct[_driver].isStore = 1;
        }
        
        driversStruct[_driver].credit = _credit;
        driversStruct[_driver].driverName = _driverName;
        driversStruct[_driver].driverAddress = _driverAddress;
        driversStruct[_driver].phone = _phone;

    }
    
    function getDriverInformation(address _driver) 
        public  
        constant 
        returns (uint, string, string)
    {
        return (
            driversStruct[_driver].credit,
            driversStruct[_driver].driverName,
            driversStruct[_driver].phone
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