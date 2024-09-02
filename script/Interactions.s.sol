// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { BasicNft } from "../src/BasicNft.sol";
import { DevOpsTools } from "../lib/foundry-devops/src/DevOpsTools.sol";

// purpose of this contract: interact with our contract programmatically
// instead of manually entering the contract address each time you want to mint a new NFT, this script automatically finds the most up-to-date BasicNft
contract MintBasicNft is Script {

    string public constant TOKENURI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";


    function run() external {
        // function is designed to retrieve the most recently deployed address of a specified contract on a given blockchain (specified by chainId)
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);

        // retrives the contract address
        mintNftOnContract(mostRecentlyDeployed);
    }

    // Once it has the address of the BasicNft contract, it programmatically interacts with that contract to mint a new NFT using a pre-defined metadata URI (TOKENURI).
    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNFT(TOKENURI);
        vm.stopBroadcast();
    }
} 