
pragma solidity ^0.4.25;

// Contract vulnerable to the Bay Fountain attack.
contract BayFountain {
    mapping (address => uint) public balances;
    
    function add() payable public {
        balances[msg.sender] = msg.value;
    }

    function give(address lucky) public {
        require(msg.sender != lucky);
    if (!lucky.call.value(balances[msg.sender])()) {
        revert();
    }
    balances[msg.sender] = 0;
    }
    
    function() payable public {
    }
}