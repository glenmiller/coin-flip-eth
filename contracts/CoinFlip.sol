pragma solidity 0.5.12;

import "./provableAPI.sol";

contract CoinFlip is usingProvable
{
	mapping(bytes32 => address) public userAddressMap;

	mapping(address => UserData) public userDataMap;

	struct UserData
	{
		bool headTailFlag;
		uint betValue;
	}

	event betResults(address userAddress, bool wonFlag);

	event errorMessage(string message);

	constructor() public
	{
		provable_setProof(proofType_Ledger);
	}

	function __callback(bytes32 inQueryId, string memory inResult, bytes memory inProof) public
	{
		require(msg.sender == provable_cbAddress());
		if (provable_randomDS_proofVerify__returnCode(inQueryId, inResult, inProof) != 0)
		{
			// Emit some error to the front end or ignore if this was someone trying to fake a win.  Need to look into this more.
		}
		else
		{
			address theUserAddress = userAddressMap[inQueryId];
			uint256 theRandomNumber = uint256(keccak256(abi.encodePacked(inResult))) % 2;
			calcWinLoss(theUserAddress, theRandomNumber);
		}

		delete(userAddressMap[inQueryId]);
	}

	function bet(bool inHeadTailFlag) public payable returns(bool successFlag)
	{
		UserData memory theUserData = userDataMap[msg.sender];
		if (theUserData.betValue == 0)
		{
			theUserData.headTailFlag = inHeadTailFlag;
			theUserData.betValue = msg.value;
			userDataMap[msg.sender] = theUserData;

			bytes32 theQueryId = provable_newRandomDSQuery(0, 1, 200000);
			userAddressMap[theQueryId] = msg.sender;
		}
		else
		{
			emit errorMessage("Already Playing!");
		}

		return (true);
	}

	function depositETH() public payable
	{
	}

	function calcWinLoss(address inUserAddress, uint256 inRandomNumber) private
	{
		bool theWonFlag = false;

		UserData memory theUserData = userDataMap[inUserAddress];
		bool theRandomHeadTailFlag = inRandomNumber == 0 ? false : true;
		if (theUserData.headTailFlag == theRandomHeadTailFlag)
		{
			theWonFlag = true;
			uint theValue = theUserData.betValue * 2;
			address payable theUserAddress = address(uint160(inUserAddress));
			theUserAddress.transfer(theValue);
		}

		delete(userDataMap[inUserAddress]);

		emit betResults(inUserAddress, theWonFlag);
	}
}
