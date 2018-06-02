pragma solidity ^0.4.16;

import "./SafeMath.sol";
import "./Owned.sol";

contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}

contract EMOToken is ERC20Interface, Owned {
    address creator;
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
    uint public _numberOfSoldToken;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
    address[] investorsList; // list of question keys so we can enumerate them

    struct Investors {
        bytes32 name;  // (up to 32 bytes)
        uint256 tokenNumber; // check how many cash amount of investors
    }
    mapping(address => Investors) public investorsStruct;

    function EMOToken() public {
        creator = msg.sender;
        symbol = "EMO";
        name = "Emoto Token";
        decimals = 1;
        _totalSupply = 1000;
        balances[0xca35b7d915458ef540ade6068dfe2f44e8fa733c] = _totalSupply;
        Transfer(address(0), 0xca35b7d915458ef540ade6068dfe2f44e8fa733c, _totalSupply);
    }

    function totalSupply() public constant returns (uint) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint256 tokens) public returns (bool success) {
        if (balances[to] == 0) {
            investorsList.push(to);
        }
        
        balances[msg.sender] = SafeMath.sub(balances[msg.sender], tokens);
        balances[to] = SafeMath.add(balances[to], tokens);
        
        Transfer(msg.sender, to, tokens);
        return true;
    }
    
    function getInvestorList(uint256 index) public view returns (address) {
        return investorsList[index];
    }
    
    function getInvestorListLength() public view returns (uint256) {
        return investorsList.length;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = SafeMath.sub(balances[from], tokens);
        allowed[from][msg.sender] = SafeMath.sub(allowed[from][msg.sender], tokens);
        balances[to] = SafeMath.add(balances[to], tokens);
        emit Transfer(from, to, tokens);
        
        return true;
    }

    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }

    function () public payable {
        revert();
    }

    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
}