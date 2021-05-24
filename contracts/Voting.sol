// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
        if (b > a) return (false, 0);
        return (true, a - b);
    }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    unchecked {
        require(b <= a, errorMessage);
        return a - b;
    }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    unchecked {
        require(b > 0, errorMessage);
        return a / b;
    }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    unchecked {
        require(b > 0, errorMessage);
        return a % b;
    }
    }
}

contract Voting {
    using SafeMath for uint256;
    using SafeMath for uint8;

    mapping(uint256 => Poll) public polls;
    uint256 public pollsAmount = 0;

    struct Poll {
        string title;
        string question;
        mapping(uint8 => Answer) answers;
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

    event CreatePoll(uint256 indexed _pollID, string indexed _title, string indexed _question);
    event CreateAnswer(uint256 indexed _pollID, uint8 indexed _answerID, string indexed _answer);
    event StartPoll(uint256 indexed _pollID);
    event ClosePoll(uint256 indexed _pollID);
    event Vote(uint256 indexed _pollID, uint8 indexed _answerID);

    function createPoll(string memory _title, string memory _question) public returns (uint256) {
        polls[pollsAmount].title = _title;
        polls[pollsAmount].question = _question;
        polls[pollsAmount].started = false;
        polls[pollsAmount].closed = false;
        polls[pollsAmount].exists = true;
        polls[pollsAmount].owner = msg.sender;

        emit CreatePoll(pollsAmount, _title, _question);

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

        emit CreateAnswer(_pollID, answerID, _answer);

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

        emit StartPoll(_pollID);
    }

    function closePoll(uint256 _pollID) public {
        require(polls[_pollID].exists, "Voting: Poll doesn't exist");
        require(msg.sender == polls[_pollID].owner, "Voting: You are not an owner of poll");

        polls[_pollID].closed = true;

        emit ClosePoll(_pollID);
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

        emit Vote(_pollID, _answerID);
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
