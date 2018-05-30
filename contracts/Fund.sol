pragma solidity ^0.4.16;

import "./SafeMath.sol";
import "./EMOToken.sol";

contract Fund {
    address emotoCoinAddress;
    address company = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint companyRatio = 40;
    uint dividendsRatio = 50; // stock dividens for investors.
    uint EMOtotalSupply = EMOToken_totalSupply();
    
    EMOToken instanceEmotoCoin = EMOToken(emotoCoinAddress);

    function Fund(address _EMOTokenAddress) {
        emotoCoinAddress = _EMOTokenAddress;
    }
    
    function EMOToken_balanceOf(address _investor) constant returns (uint) {
        return instanceEmotoCoin.balanceOf(_investor);
    }
    
    function EMOToken_totalSupply() constant returns (uint256) {
        return instanceEmotoCoin.totalSupply();
    }
    
    struct Investors {
        bytes32 name;  // (up to 32 bytes)
        uint256 tokenNumber; // check how many cash amount of investors
    }
    
    mapping(address => Investors) public investorsStruct;
    address[] investorsList; // list of question keys so we can enumerate them

    function setInvestors(address _investor, bytes32 _investorName) 
        public 
        payable 
        returns(bool) 
    {
        
        // if no data in list, push into the investorsList...
        if(EMOToken_balanceOf(_investor) == 0) {
            investorsList.push(_investor);
        }
        
        investorsStruct[_investor].name = _investorName;

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
        return (investorsStruct[index].name, investorsStruct[index].tokenNumber);
    }
    
    function getTotalProfit()
        public
        constant
        returns(uint)
    {
        return address(this).balance;
    }
    
    // Calculate investors dividends.
    function getDividendsValue() 
        public 
        constant 
        returns(uint) 
    {
        uint funds = address(this).balance;
        uint dividens = funds * SafeMath.percent(dividendsRatio, 100, 3) / 1000;
        return dividens;
    }
    
    // Calculate company's dividends.
    function getCompanyDividendsValue() 
        public 
        constant 
        returns(uint) 
    {
        uint funds = address(this).balance;
        uint dividens = funds * SafeMath.percent(companyRatio, 100, 3) / 1000;
        return dividens;
    }
    
    // Stock Dividend from Retained Earnings
    // redistributed profit to all the investors.
    function refund() 
        payable 
        public 
    {
        uint companyProfit = getCompanyDividendsValue();
        uint totalDividen = getDividendsValue();
        uint dividen;
        company.transfer(companyProfit);
        
        // repay all the money to every invenstor
        for (uint i = 0; i <  investorsList.length; i++) {
          //  Calculate shareholding ratio for each investor.
            dividen = totalDividen * SafeMath.percent(EMOToken_balanceOf(investorsList[i]), EMOtotalSupply , 3) / 1000;
            investorsList[i].transfer(dividen);
        }
    }
    
    function () 
        public 
        payable 
    {
    }
}