// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {

    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;
    uint256 private s_tokenCounter;

    enum Mood {
        HAPPY,
        SAD
    }

    error MoodNFT___CantFlipMoodIfNotOwner();

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(string memory sadSvg, string memory happySvg) ERC721("Mood Nft", "MN") {
        s_sadSvgImageUri = sadSvg;
        s_happySvgImageUri = happySvg;
        s_tokenCounter = 0;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY; // setting the default enum value(happy) to every new minted token 
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) { imageURI = s_happySvgImageUri; }
        else { imageURI = s_sadSvgImageUri; }

        // we're using `abi.encodePacked` to concatenate our disparate strings into one object. This allows us to easily parameterize things a little bit.
        // we are now concatinating the data type prefix with the JSON Object 
        // data:application/json;base64, ... JSON Object ...
        return string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "', 
                            name(), 
                            '", "description": "An NFT that reflects your mood!", "attributes": [{"trait_type": "Mood", "value": 100}], "image": "', imageURI,'"}')
                    )
                )
            )
        );
    }

    // prepending the base64 hash with the below data type prefix in order for our browser to read the tokenURI JSON data
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }


    function flipMood(uint256 tokenId) public {
        // get the owner of the token
        address owner = ownerOf(tokenId);

        // only want the owner of nft to change the mood
        _checkAuthorized(owner, msg.sender, tokenId);

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) { s_tokenIdToMood[tokenId] = Mood.SAD; }
        else { s_tokenIdToMood[tokenId] = Mood.HAPPY; }


    }




}



