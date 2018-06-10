pragma solidity ^0.4.16;

import "./SafeMath.sol";
import "./EMOToken.sol";

contract Fund {
    address emotoCoinAddress;
    address company;
    uint companyRatio = 0;
    uint dividendsRatio = 100; // stock dividens for investors.

    function Fund(address _EMOTokenAddress) public payable{
        emotoCoinAddress = _EMOTokenAddress;
        company = msg.sender;
        EMOToken(emotoCoinAddress);
    }


    function EMO_balanceOf(address _investor) view public returns (uint) {
        return EMOToken(emotoCoinAddress).balanceOf(_investor);
    }
    
    function EMO_totalSupply() public view returns(uint){
        return EMOToken(emotoCoinAddress).totalSupply();
    }
    
    function EMO_getInvestorList(uint256 _index) public view returns(address) {
        return EMOToken(emotoCoinAddress).getInvestorList(_index);
    }
    
    function EMO_getInvestorListLength() public view returns(uint256) {
        return EMOToken(emotoCoinAddress).getInvestorListLength();
    }
    
    function getInvestorCount() 
        public 
        constant 
        returns(uint) 
    {
        return 0;
    }
    
    function getTotalProfit()
        public
        view
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
        uint EMOtotalSupply = EMO_totalSupply();
        // uint companyProfit = getCompanyDividendsValue();
        uint totalDividen = getDividendsValue();
        uint dividen;
        uint invenstorLength = EMO_getInvestorListLength();
        // company.transfer(companyProfit);
        
        // repay all the money to every invenstor
        for (uint256 i = 0; i < invenstorLength; i++) {
            //  Calculate shareholding ratio for each investor.
            address investor = EMO_getInvestorList(i);
            dividen = totalDividen * SafeMath.percent(EMO_balanceOf(investor), EMOtotalSupply , 3) / 1000;
            investor.transfer(dividen);
        }
    }
    
    function () 
        public 
        payable 
    {
    }
}