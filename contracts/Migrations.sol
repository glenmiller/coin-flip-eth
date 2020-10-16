pragma solidity ^0.5.0;

contract Migrations
{
	uint public last_completed_migration;

	address public owner;

	modifier restricted()
	{
		if (msg.sender == owner) _;
	}

	constructor() public
	{
		owner = msg.sender;
	}

	function setCompleted(uint inCompleted) public restricted
	{
		last_completed_migration = inCompleted;
	}

	function upgrade(address inNewAddress) public restricted
	{
		Migrations theUpgraded = Migrations(inNewAddress);
		theUpgraded.setCompleted(last_completed_migration);
	}
}
