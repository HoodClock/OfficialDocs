// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HoneyPot {
    mapping(address => uint256) public balances;

    constructor() payable {
        require(msg.value > 0, "Contract must be funded");
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "No balance to withdraw");
        require(address(this).balance > 0, "Contract balance is zero");
        (bool sent, ) = msg.sender.call{value: balances[msg.sender]}("");
        require(sent, "Withdrawal failed!");
        balances[msg.sender] = 0;
    }

    // The trap: Funds cannot actually be withdrawn
    fallback() external payable {
        revert("Honeypot detected!");
    }
}
