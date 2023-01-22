
pragma solidity ^0.4.10;

// The ParticipartoryBudgeting contract is deployed by a "chairperson" to enable 
// certain "citizen" ETH addresses to vote on different proposals, calculating 
// which proposal has the most votes, and whether a specific proposal has been 
// successful.
contract ParticipartoryBudgeting {

    // The type for a single proposal.
    struct Proposal {
        uint8 threshold; // percentage threshold needed for proposal to be funded
        uint value; // accumulated token
        bool won; // decision
    }

    // A dynamically-sized array of ‘Proposal‘ structs.
    Proposal[] public proposals;

    // A state variable storing number of token per citizen (aka address).
    mapping(address => uint) public citizenlist;

    address public chairperson;
    bool private isClosed;
    uint private count;
    
    // Creates a new round to choose amongst ‘numProposal‘ proposals.
    // ’proposalThresholds’ is array of thresholds of length >= ‘numProposal‘.
    constructor(uint numberProposal, uint8[] memory proposalThresholds) public {
        // Checks there are sufficient proposal thresholds for number of proposals.
        require(
            proposalThresholds.length >= numberProposal,
            "The proposalThresholds must be >= the number of proposals."
            );
        // Assigns the chairperson as the person deploying contract.
        chairperson = msg.sender;
        // Provides chairperson with 100 tokens.
        citizenlist[chairperson] = 100;
        // Boolean signifies that the round is open. 
        isClosed = false;
        
        // Loops and initialises the proposals with provided thresholds.
        for (uint i = 0; i < proposalThresholds.length; i++) {
            proposals.push(Proposal({
                threshold: proposalThresholds[i],
                value: 0,
                won: false
            }));
        }
    }

    // Function gives ‘citizen‘ the right to participate in the round.
    function giveRightToVote(address citizen) public { 
        // Ensures function can only be called by chairperson.
        require(
            msg.sender == chairperson,
            "Only the chairperson gives the right to participate."
            );
        // Provides citizen with 100 tokens.
        citizenlist[citizen] = 100;
    }

    // Function gives tokenno of token to ’proposals[proposal]‘.
    function vote(uint proposal, uint tokenno) public { 
        // Requires that the citizen has enough tokens to vote.
        require(
            citizenlist[msg.sender] >= tokenno, 
            "Insufficient tokens to vote."
            );
        // Requires the round to be open.
        require(
            isClosed == false,
            "Voting has been closed."
            );
            
        // Deducts the pledged tokens from citizens balance.
        citizenlist[msg.sender] -= tokenno;
        // Adds the pledged tokens to the proposals balance.
        proposals[proposal].value += tokenno;
        // Increments the total count of tokens.
        count += tokenno;
    }

    // Function computes the winning proposals.
    function winningProposals() public { 
        // Ensures function can only be called by chairperson.
        require(
            msg.sender == chairperson,
            "Only the chairperson can compute winning proposals."
            );
        // Loops through all proposals calculating percentage of votes obtained.
        // Checks if percentage of votes is greater than or equal to the threshold.
        for (uint p = 0; p < proposals.length; p++){
            if (((proposals[p].value * 100) / count)  >= proposals[p].threshold ){
                // Sets proposal as won if condition is met.
                proposals[p].won = true;
            }
        }
        // Closes the round to prevent further voting.
        isClosed = true;
    }

    // Function returns whether proposal p has been successful.
    function proposalWon(uint p) public view returns (bool) { 
        // Requires the round to be closed.
        require(
            isClosed == true,
            "The round must be closed."
            );
        // Returns the boolean won signifying victory (true) or defeat (false). 
        return proposals[p].won;
    }
}