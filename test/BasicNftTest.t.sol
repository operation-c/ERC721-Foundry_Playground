// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { BasicNft } from "../src/BasicNft.sol";
import { Test, console } from "forge-std/Test.sol";
import { DeployBasicNft } from "../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address private USER = makeAddr("user");
    string public constant PUG =
      "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";


    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expected = "BasicNft";
        string memory actual = basicNft.name();

        assert(keccak256(abi.encodePacked(expected)) == keccak256(abi.encodePacked(actual)));
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNft.mintNFT(PUG);

        // validating that the user has a balance of 1 nft
        assert(basicNft.balanceOf(USER) == 1);
        
        // validating to see if the PUG meta data matches the matadata or token counter 0 
        assert(keccak256(abi.encodePacked(PUG)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));

        console.log("Token URI:", basicNft.tokenURI(0));
        console.log("PUG URI:", PUG);
    }
}