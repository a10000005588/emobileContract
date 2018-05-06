pragma solidity ^0.4.16;

import "./Math.sol";
import "./Owner.sol";

// Every mobile has their own contract name !
contract Emobile {
    bytes plate;  // mobile license-plate
    uint256 initialFund = 5000000000000000000;  // Gogoro2 price : 60000 $NT
    uint256 timestamp;
    string driverName;
    address driverAddress;
    bool isLock;
    
    uint company_ratio = 5;
    uint driver_ratio = 45;

    struct Investors {
        bytes32 name;  // (up to 32 bytes)
        uint256 funds; // check how many amount the investor send 
    }
    
    mapping(address => Investors) public investorsStruct;
    address[] investorsList; // list of question keys so we can enumerate them

    function setDriver(string _driverName) 
        public 
    {
        driverName = _driverName;
    }
    
    function setInvestors(address _investor, bytes32 _investorName, uint256 _fund) 
        private 
        returns(bool) 
    {
        if(_fund < 1000000000000000000) {
            revert();
        }
        
        // if no data in list, push into the investorsList...
        if(investorsStruct[_investor].funds == 0) {
            investorsList.push(_investor);
        }
        
        investorsStruct[_investor].name = _investorName;
        investorsStruct[_investor].funds = _fund;
        
        return true;
    }
    
    function getInvestorCount() 
        public 
        constant 
        returns(uint) 
    {
        return investorsList.length;
    }
    
    function getInvestors(address index) 
        public 
        constant 
        returns(bytes32, uint256) 
    {
        return (investorsStruct[index].name, investorsStruct[index].funds);
    }

    function getProfitValue() 
        public 
        constant 
        returns(uint) 
    {
        // return the profit of contract of emobile.
        return address(this).balance;
    }
    
    function getMobileInformation() 
        public
        constant
        returns(bytes, uint256, string, bool, uint256) 
    {
        return (plate, initialFund, driverName, isLock, timestamp);
    }
    
    function payCoinForDriver(uint256 _price) 
        public 
        payable 
        returns(bool)
    {
        // check whether the passenger has enough ether or not.
        if(msg.sender <= 0) {
            revert("No money");
        }
        // input the mobile and passenger's address
        // and caculated the milage and get price
        bool res = address(this).send(_price);
        return res;
    }
    
    function investForDriver(bytes32 _investorName, uint256 _fund) 
        public 
        payable 
        returns(bool) 
    {
        // msg.sender, william, 10
        // delegate the specific emobile contract address, and then saving the investors information.
        // need record what fund the investor send.
        setInvestors(msg.sender, _investorName, _fund);
        // send to specific emobile address.
        bool res = address(this).send(_fund);
        return res;
    }
    // redistributed profit to all the investors.
    function repay(uint precision) 
        public 
    {
        uint totalAmount = getProfitValue();
        if(totalAmount <= initialFund) {
            revert();
        }
        uint totalProfit =  totalAmount - initialFund;
        uint totalProfitUnit = Math.div(totalProfit, 10 ** precision);
      
        // repay all the money to every invenstor
        for (uint i = 0; i <  investorsList.length; i++) {
            // investors[0] for company investors[1] for passenger, investors[2] and other are investors...
            // Calculate each investors funding ratio...
            uint ratio = Math.percent(investorsStruct[investorsList[i]].funds, totalAmount, precision);
            investorsList[i].transfer(totalProfitUnit * ratio);
        }
    }
    // return all the funds back to the investors.
    function refund() 
        private
    {
        uint totalAmount = getProfitValue();
        uint totalAmountUnit = Math.div(totalAmount, 10 ** 3);

        if(address(this).balance < initialFund) {
            revert();
        }
         // repay all the money to every invenstor
        for (uint i = 0; i <  investorsList.length; i++) {
            // check the investor's ratio
            uint ratio = Math.percent(investorsStruct[investorsList[i]].funds, totalAmount, 3);
            investorsList[i].transfer(totalAmountUnit * ratio);
        }
    }
    
    function () 
        public 
        payable 
    {
    }
}