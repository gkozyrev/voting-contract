// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Voting {
    using SafeMath for uint256;
    using SafeMath for uint8;

    mapping(uint256 => Poll) public polls;
    uint256 public pollsAmount = 0;

    struct Poll {
        string title;
        string question;
        mapping(uint => Answer) answers;
        uint8 answersAmount;
        uint8 resolved;
        bool started;
        bool closed;
        bool exists;
        address owner;
        mapping(address => bool) whitelisted;
    }

    struct Answer {
        string answer;
        uint256 votes;
        bool exists;
        mapping(address => bool) voters;
    }

    address owner;

    constructor() {
        owner = msg.sender;
    }

    function createPoll(string memory _title, string memory _question) public returns (uint256) {
        polls[pollsAmount].title = _title;
        polls[pollsAmount].question = _question;
        polls[pollsAmount].started = false;
        polls[pollsAmount].closed = false;
        polls[pollsAmount].exists = true;
        polls[pollsAmount].owner = msg.sender;

        pollsAmount = pollsAmount + 1;

        return pollsAmount;
    }

    function addAnswer(uint256 _pollID, string memory _answer) public returns (uint256) {
        require(polls[_pollID].exists, "Voting: Poll doesn't exist");
        require(!polls[_pollID].started, "Voting: Poll is already started");
        require(!polls[_pollID].closed, "Voting: Poll is closed");

        uint8 answerID = polls[_pollID].answersAmount;

        polls[_pollID].answers[answerID].answer = _answer;
        polls[_pollID].answers[answerID].exists = true;
        polls[_pollID].answers[answerID].voters[msg.sender] = false;

        polls[_pollID].answersAmount = answerID + 1;

        return answerID;
    }

    function addWhitelistAddress(uint256 _pollID, address _address) public {
        require(polls[_pollID].exists, "Voting: Poll doesn't exist");
        require(msg.sender == polls[_pollID].owner, "Voting: You are not an owner of poll");

        polls[_pollID].whitelisted[_address] = true;
    }

    function addManyWhitelistAddress(uint256 _pollID, address[] memory _addresses) public {
        require(polls[_pollID].exists, "Voting: Poll doesn't exist");
        require(msg.sender == polls[_pollID].owner, "Voting: You are not an owner of poll");

        for (uint256 i = 0; i < _addresses.length; i++) {
            polls[_pollID].whitelisted[_addresses[i]] = true;
        }
    }

    function startPoll(uint256 _pollID) public {
        require(polls[_pollID].exists, "Voting: Poll doesn't exist");
        require(msg.sender == polls[_pollID].owner, "Voting: You are not an owner of poll");

        polls[_pollID].started = true;
    }

    function closePoll(uint256 _pollID) public {
        require(polls[_pollID].exists, "Voting: Poll doesn't exist");
        require(msg.sender == polls[_pollID].owner, "Voting: You are not an owner of poll");
        polls[_pollID].closed = true;
    }

    function vote(uint256 _pollID, uint8 _answerID) public {
        require(polls[_pollID].exists, "Voting: Poll doesn't exist");
        require(polls[_pollID].answers[_answerID].exists, "Voting: Answer doesn't exist");
        require(polls[_pollID].started, "Voting: Poll is not started");
        require(!polls[_pollID].closed, "Voting: Poll is already closed");
        require(polls[_pollID].whitelisted[msg.sender] || polls[_pollID].owner == msg.sender, "Voting: Opps, no such address in whitelist");
        require(!polls[_pollID].answers[_answerID].voters[msg.sender], "Voting: You have already voted");

        polls[_pollID].answers[_answerID].voters[msg.sender] = true;
        polls[_pollID].answers[_answerID].votes.add(1);
    }

    function getPollQuestion(uint256 _pollID) public view returns (string memory) {
        require(polls[_pollID].exists, "Voting: Poll doesn't exist");
        string memory _answer = polls[_pollID].question;
        return _answer;
    }

    function getAnswer(uint256 _pollID, uint8 _answerID) public view returns (string memory) {
        require(polls[_pollID].exists, "Voting: Poll doesn't exist");
        require(polls[_pollID].answers[_answerID].exists, "Voting: Answer doesn't exist");
        string memory _answer = polls[_pollID].answers[_answerID].answer;
        return _answer;
    }

    function getAnswerVotes(uint256 _pollID, uint8 _answerID) public view returns (uint256) {
        require(polls[_pollID].exists, "Voting: Poll doesn't exist");
        require(polls[_pollID].answers[_answerID].exists, "Voting: Answer doesn't exist");
        uint256 _votes = polls[_pollID].answers[_answerID].votes;
        return _votes;
    }

    function getAnswersIdRange(uint256 _pollID) public view returns (uint8, uint8) {
        return (0, polls[_pollID].answersAmount - 1);
    }
}
