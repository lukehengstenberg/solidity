
pragma solidity ^0.4.10;
import "./ParticipartoryBudgeting.sol";

// The Citizen contract is deployed by a "citizen" to enable voting on proposals
// via the ParticipartoryBudgeting contract. 
contract Citizen {

    ParticipartoryBudgeting pb;

    constructor (ParticipartoryBudgeting _pb) public {
       pb = _pb;
    }

    function vote(uint proposal, uint token) public {
       pb.vote(proposal, token);
    }
    
}

