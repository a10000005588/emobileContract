pragma solidity ^0.4.16;

import "./SafeMath.sol";

contract Fund {
    /*
       Problem:
         1. For couting fund. Calculation will take too mush gas.
         2. How to control the amount of who has hold the EMO tokens ?
    */
    
    uint initialFund = 100000000000000000000; // 100 ether
    uint companyFee = 5;
    uint dividendsRatio = 40; // stock dividens for investors.
    
    struct Investors {
        bytes32 name;  // (up to 32 bytes)
        uint256 funds; // check how many cash amount of investors
    }
    
    mapping(address => Investors) public investorsStruct;
    address[] investorsList; // list of question keys so we can enumerate them
 
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
    
    function getInvestors (address index) 
        public 
        constant 
        returns(bytes32, uint256) 
    {
        return (investorsStruct[index].name, investorsStruct[index].funds);
    }
    
    function getTotalProfit()
        public
        constant
        returns(uint)
    {
        return address(this).balance;
    }
    
    // Calulate Dividends.
    function getDividendsValue() 
        public 
        constant 
        returns(uint) 
    {
        uint funds = address(this).balance;
        uint dividens = funds * SafeMath.percent(100, dividendsRatio, 3);
        return dividens;
    }
    
    // Stock Dividend from Retained Earnings
    // redistributed profit to all the investors.
    function refund(uint precision) 
        public 
    {
        uint Profit = getDividendsValue();
        if(Profit <= initialFund) {
            revert();
        }
        uint ProfitUnit = SafeMath.safeDiv(Profit, 10 ** precision);
      
        // repay all the money to every invenstor
        for (uint i = 0; i <  investorsList.length; i++) {
            // Investors[0] for company investors[1] for passenger, investors[2] and other are investors...
            // Calculate shareholding ratio for each investor.
            uint ratio = SafeMath.percent(investorsStruct[investorsList[i]].funds, Profit, precision);
            investorsList[i].transfer(ProfitUnit * ratio);
        }
    }
    
    function () 
        public 
        payable 
    {
    }
}