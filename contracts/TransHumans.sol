// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Base64.sol";


contract TransHumans is ERC721, ERC721Enumerable {
    using Counters for Counters.Counter;

    Counters.Counter private _idCounter;
    uint256 public maxSupply;

    constructor(uint256 _maxSupply) ERC721("TransHumans", "THS") {
        maxSupply = _maxSupply;
    }
    //definiedo max supply de los NFTs con relacion a current.
    function mint() public {
        uint256 current = _idCounter.current();
        require(current < maxSupply, "No TransHumans Left");
        
        _safeMint(msg.sender, current);

    }
    //construyendo tokenURI para conectar la METADATA del NFT con el archivo json
    function tokenURI(uint256 tokenId) public view override returns (string memory)
    {
        require(
            //_exists import ERC721 OpenZeppelin
            _exists(tokenId),
            "ERC721 Metadata: URI query for nonexistent token"
        );
        //metodo abi sirve para concatenar strings
        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{ "name": "TransHumans #',
                tokenId,
                '", "description": "TransHumans are randomized Avataaars stored on chain to teach DApp development", "image": "',
                "// TODO: Calculate image URL",
                '"}'
            )
        );
        //concatenacion de los datos JSON con el formato base64 HTTPS
        return string(abi.encodePacked("data:application/json;base64,", jsonURI));
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) 
        internal 
        override(ERC721, ERC721Enumerable) 
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
