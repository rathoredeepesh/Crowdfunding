// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract CrowdFund {
    address public owner;
    uint public goal;
    uint public deadline;
    uint public raisedAmount;

    mapping(address => uint) public contributions;

    constructor(uint _goal, uint _durationInDays) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    modifier beforeDeadline() {
        require(block.timestamp < deadline, "Deadline passed");
        _;
    }

    modifier afterDeadline() {
        require(block.timestamp >= deadline, "Deadline not reached");
        _;
    }

    function contribute() public payable beforeDeadline {
        require(msg.value > 0, "Contribution must be greater than 0");
        contributions[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    function withdraw() public onlyOwner afterDeadline {
        require(raisedAmount >= goal, "Funding goal not reached");
        payable(owner).transfer(address(this).balance);
    }

    function refund() public afterDeadline {
        require(raisedAmount < goal, "Goal was met");
        uint amount = contributions[msg.sender];
        require(amount > 0, "No contributions found");
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
