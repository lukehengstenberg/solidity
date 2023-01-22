pragma solidity ^0.4.10;
import "./ParticipartoryBudgeting.sol";
import "./PBCitizen.sol";

// This contract runs tests for the Participartory Budgeting contract.
contract TestPB {

    ParticipartoryBudgeting pb;
    Citizen[9] citizen;

    constructor () public {
       uint8[] memory args  = new uint8[](3);
       args[0] = 10;
       args[1] = 40;
       args[2] = 50;
       pb = new ParticipartoryBudgeting(3,args);
       for (uint i = 0; i < 9; i++) {
          citizen[i] = new Citizen(pb);
          pb.giveRightToVote( address(citizen[i]) );
       }
    }

    function vote(uint8 from, uint proposal, uint token) internal {
       citizen[from].vote(proposal, token);
    }
    
    // attempt to vote using 120 tokens when only 100 are available (edge case)
    function experiment1 () public {
       vote(0,0,40);
       vote(0,1,40);
       vote(0,2,40);
    }
    
    // attempt to vote after voting has closed (edge case)
    function experiment2 () public {
       vote(0,0,40);
       vote(0,1,40);
       pb.winningProposals();
       vote(1,2,100);
    }
    
    // vote for a mixture of proposals and then calculate the winner
    function experiment3 () public {
       vote(0,0,40);
       vote(0,1,40);
       vote(0,2,20);
       vote(1,2,80);
       vote(2,2,100);
       vote(3,2,100);
       vote(4,2,100);
       vote(5,2,100);
       pb.winningProposals();
    }
    
    function proposalWon(uint p) public view returns (bool) {
        return pb.proposalWon(p);
    }

}
