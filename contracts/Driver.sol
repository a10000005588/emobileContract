pragma solidity ^0.4.16;

// Every mobile has their own contract name !
contract Driver {  
    struct Drivers{
        uint credit ;     
        string driverName;
        uint isStore;
        
    }
    
    mapping(address => Drivers) public driversStruct;
    address[] driverList;
    
    function setDriverInformation(address _driver,string _driverName, uint256 _credit) 
        public 
    {
        if(driversStruct[_driver].isStore == 0) {
            driverList.push(_driver);
            driversStruct[_driver].isStore = 1;
        }
        
        driversStruct[_driver].credit = _credit;
        driversStruct[_driver].driverName = _driverName;
    }
    
    function getDriverInformation(address _driver) 
        public  
        view 
        returns (uint, string)
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