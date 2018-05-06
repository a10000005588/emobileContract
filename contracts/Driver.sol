pragma solidity ^0.4.16;

// Every mobile has their own contract name !
contract Driver {  
    struct Drivers{
        uint256 credit ;      // -5~5
        string driverName;    //司機名稱
    }
    
    mapping(address => Drivers) public driversStruct;
    address[] driverList;
    
    function setDriver(address _driver,string _driverName , uint256 _credit) public returns(bool){
        driverList.push(_driver);
        driversStruct[_driver].credit = _credit;
        driversStruct[_driver].driverName = _driverName;
        return true;
    }
    
    function getDriver(address _driver) public  constant returns (uint256){
        driverList.push(_driver);
        return driversStruct[_driver].credit;
    }
}