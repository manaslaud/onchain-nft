// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC721Base.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
contract nft is ERC721Base {

      constructor(
        address _defaultAdmin,
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps
    )
        ERC721Base(
            _defaultAdmin,
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps
        )
    {}
    string[] private blockchains=["word","word2","word3","word4"];
    string[] private blockchains2=["xyz1","Solana","Solidity","test"];
    string[] private blockchains3=["Ethereum","manas","4","5"];
    string[] private svgParts=[' <rect width="100" height="100" style="fill:blue;" />','<circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />','<defs> <pattern id="polka-dots" x="0" y="0" width="25" height="25" patternUnits="userSpaceOnUse"> <circle cx="12.5" cy="12.5" r="10" style="stroke: none; fill: blue;" /></pattern> </defs><rect width="100" height="100" style="fill: url(#polka-dots);" />',' <defs> <pattern id="horizontal-lines" patternUnits="userSpaceOnUse" width="10" height="10"> <line x1="0" y1="5" x2="10" y2="5" style="stroke:black; stroke-width:2" /> </pattern> </defs> <rect width="100" height="100" style="fill: url(#horizontal-lines);" />'];

    function randomNum() private view returns (uint) {
    uint randomHash = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
    return randomHash % 4;
} 




    function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory){
        uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
        string memory output = sourceArray[rand % sourceArray.length];
        return output;  
          }
           function tokenURI(uint256 tokenId) override public view returns (string memory){
        string[10] memory parts;

        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="#f904ab" /><text x="10" y="20" class="base">';

        parts[1] = getBlockchain(tokenId);

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = getDapp(tokenId);

        parts[4] = '</text><text x="10" y="60" class="base">';

        parts[5] = getToken(tokenId);

        parts[6] = '</text>';
        uint256 idx=randomNum();
        
        parts[7]=svgParts[idx];

        parts[8]='<rect width="10%" height="10%" fill="#d0d6b5" />';

        parts[9]='</svg>';

        string memory output = 
            string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7],parts[8],parts[9]));

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "NFT TOKEN PRODUCED ON CHAIN: ', toString(tokenId), '", "description": "OnChain NFTs created using Thirdweb, SC in Solidity", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));
        
        return output;
    }
     function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
     function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
    
    function getBlockchain(uint256 tokenId) public view returns (string memory){
        return pluck(tokenId, "Blockchains", blockchains);
    }

    function getDapp(uint256 tokenId) public view returns (string memory){
        return pluck(tokenId, "Dapps", blockchains2);
    }

    function getToken(uint256 tokenId) public view returns (string memory){
        return pluck(tokenId, "Tokens", blockchains3);
    }

    function claim(uint256 _amount) public {
        require(_amount > 0 && _amount < 6);
        _safeMint(msg.sender, _amount);
    }

}