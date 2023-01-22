
pragma solidity ^0.4.25;

// Contract representing a faucet to support one charity account.
// Stores ETH by calling the payable fallback function and then gives out a
// specific amount to a given beneficiary address.
contract CharityFaucet { 
    address owner;
    address charity;
    bool installable;
    
    constructor () public {
        owner = msg.sender;
        installable = true;  }
        
    // Install charity account that will have control over this faucet
    function install (address _charity) public {
        require(msg.sender == owner);   // only owner can install at most once
        require(installable);
        installable = false;
        charity = _charity;  }
            
    // Give out ether to beneficiary
    function give(address beneficiary, uint amount) public returns (bool){
        require(msg.sender == charity);  // only charity can request transfer
        // Send amount to address that requested it
        return beneficiary.send(amount); }
            
    function () external payable {}      // Accept any incoming amount
}