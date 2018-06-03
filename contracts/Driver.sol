pragma solidity ^0.4.16;

// Every mobile has their own contract name !
contract Driver {  
    struct Drivers{
        uint256 credit;     
        bytes32 driverName;
        uint256 count;
        uint256 isStore; 
    }

    event DriverInformation(
        address indexed driver, 
        bytes32 driverName, 
        uint256 credit,
        uint256 count
    );

    mapping(address => Drivers) public driversStruct;
    address[] driverList;
    
    function setDriverInformation(address _driver,bytes32 _driverName, uint256 _credit) 
        public 
    {
        if(driversStruct[_driver].isStore == 0) {
            driverList.push(_driver);
            driversStruct[_driver].isStore = 1;
            driversStruct[_driver].count = 0;
            driversStruct[_driver].credit = 0;
        }
        driversStruct[_driver].credit = _credit;
        driversStruct[_driver].driverName = _driverName;
        
        emit DriverInformation(_driver, driversStruct[_driver].driverName, driversStruct[_driver].credit, driversStruct[_driver].count);
    }
    
    function getDriverInformation(address _driver) 
        public   
        view
        returns (bytes32,uint256,uint256)
    {
        return (
            driversStruct[_driver].driverName,
            driversStruct[_driver].credit,
            driversStruct[_driver].count
        );
    }

    function getAllDriverInformation() 
        public
        view
        returns (uint, bytes32[], uint256[], uint256[])
    {
        uint dataLength = driverList.length;
        bytes32[] memory driverName = new bytes32[](dataLength);
        uint256[] memory credit = new uint256[](dataLength);
        uint256[] memory count = new uint256[](dataLength);

        for (uint i = 0; i < dataLength; i++) {
            driverName[i] = driversStruct[driverList[i]].driverName;
            credit[i] = driversStruct[driverList[i]].credit;
            count[i] = driversStruct[driverList[i]].count;
        }

        return (dataLength, driverName, credit, count);
    }
    
    function giveCreditForDriver(address _driver, uint256 credit) 
        public
        returns(uint256, uint256)
    {
        driversStruct[_driver].credit += credit;
        driversStruct[_driver].count += 1;

        return (
            driversStruct[_driver].credit,
            driversStruct[_driver].count
        );
    }
}