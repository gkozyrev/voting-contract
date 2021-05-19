pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract Voting {
    using SafeMath for uint256;

    mapping (unit256 => Poll) polls;
    unint256 pollsAmount = 0;

    struct Poll {
        string title;
        string question;
        mapping (uint => Answer) answers;
        uint64 answersAmount;
        uint64 resolved;
        bool started;
        bool closed;
        bool exists;
        address owner;
        mapping (address => bool) whitelisted;
    }

    struct Answer {
        string answer;
        unit256 votes;
        bool exists;
        mapping (address => bool) voters;
    }

    mapping (address => bool) public whitelist;

    function createPoll (string _title, string _question) public {
        pollsAmount.add(1);
        polls[pollsAmount].title = _name;
        polls[pollsAmount].question = _question;
        polls[pollsAmount].started = false;
        polls[pollsAmount].closed = false;
        polls[pollsAmount].exists = true;
        polls[pollsAmount].owner = msg.sender;
    }

    function addAnswer (uint256 _pollID, string _answer) public {
        require(!polls[_pollID].started, "Voting: Poll is already started");
        require(!polls[_pollID].closed, "Voting: Poll is already closed");

        polls[_pollID].answersAmount.add(1);
        polls[_pollID].answers[polls[_pollID].answersAmount].answer = _answer;
        polls[_pollID].answers[polls[_pollID].answersAmount].exists = true;
        polls[_pollID].answers[polls[_pollID].answersAmount].voters[msg.sender] = true;
    }

    function addWhitelistAddress (uint256 _pollID, address _address) public {
        require(msg.sender == polls[_pollID].owner, "Voting: You are not an owner of poll");
        polls[pollsAmount].whitelisted[_address] = true;
    }

    function addManyWhitelistAddress (uint256 _pollID, address[] _addresses) public {
        require(msg.sender == polls[_pollID].owner, "Voting: You are not an owner of poll");
        for (uint256 i = 0; i < _addresses.length; i++) {
            polls[pollsAmount].whitelisted[_addresses[i]] = true;
        }
    }

    function startPoll(uint256 _pollID) public {
        require(msg.sender == polls[_pollID].owner, "Voting: You are not an owner of poll");
        polls[_pollID].started = true;
    }

    function closePoll(uint256 _pollID) public {
        require(msg.sender == polls[_pollID].owner, "Voting: You are not an owner of poll");
        polls[_pollID].started = true;
    }

    function vote (uint256 _pollID, uint64 _answerID) public {
        require(polls[_pollID].exists, "Voting: Poll doesn't exist");
        require(polls[_pollID].answers[_answerID].exists, "Voting: Answer doesn't exist");
        require(polls[_pollID].answers[_answerID].whitelist[msg.sender], "Voting: Opps, no such address in whitelist");
        require(polls[_pollID].answers[_answerID].voters[msg.sender], "Voting: You have already voted");

        polls[_pollID].answers[_answerID].voters[msg.sender] = true;
        polls[_pollID].answers[_answerID].votes.add(1);
    }

    function getPollQuestion (uint256 _pollID) public view returns (string) {
        require(polls[_pollID].exists, "Voting: Poll doesn't exist");
        return polls[pollName].question;
    }

    function getAnswer (uint256 _pollID, uint64 _answerID) public view returns (string) {
        require(polls[_pollID].exists, "Voting: Poll doesn't exist");
        require(polls[_pollID].answers[_answerID].exists, "Voting: Answer doesn't exist");
        return polls[_pollID].answers[_answerID].answer;
    }

    function getPollCount (string pollName) public view returns (uint[3]) {
        require(doesPollExist(pollName));
        return [polls[pollName].count1, polls[pollName].count2, polls[pollName].count3];
    }

    function pollExists (uint256 _pollID) private view returns (bool) {
        return pools[_pollID].exists;
    }

    function hasAlreadyVoted (uint256 _pollID, uint64 _answerID) private view returns (bool) {
        return polls[_pollID].answers[_answerID].voters[msg.sender];
    }
}
