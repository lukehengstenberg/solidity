
pragma solidity ^0.4.25;
import "./CharityFaucet.sol";

// Contract representing a Charity account.
// Sends funds to a beneficiary using ETH stored in the CharityFaucet contract.
contract Charity { 
    
    CharityFaucet cfaucet;
    address beneficiary;
    
    // Creates a new charity.
    // Initialises the faucet and beneficiary with the provided addresses.
    constructor (address _cfaucet, address _beneficiary) public {
        cfaucet = CharityFaucet(_cfaucet);
        beneficiary = _beneficiary;
    }
    
    // Donates money to the beneficiary when called.
    function donate() public payable{ 
        // Checks that the faucet has enough balance, throws error if false.
        require(
            cfaucet.give(beneficiary, msg.value) == true,
            "Insufficient funds in faucet."
            );
        // Transfers money to the beneficiary. 
        beneficiary.transfer(msg.value);
    }
}
