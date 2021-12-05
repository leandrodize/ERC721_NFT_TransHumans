// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./ADN_TransHumans.sol";
import "./Base64.sol";


contract TransHumans is ERC721, ERC721Enumerable, ADNTransHumans{
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _idCounter;
    uint256 public maxSupply;
    mapping(uint256 => uint256) public tokenADN;

    constructor(uint256 _maxSupply) ERC721("TransHumans", "THS") {
        maxSupply = _maxSupply;
    }
    //definiedo max supply de los NFTs con relacion a current.
    function mint() public {
        uint256 current = _idCounter.current();
        require(current < maxSupply, "No TransHumans Left :(");
        
        tokenADN[current] = deterministPseudoRandomADN(current, msg.sender);
        _safeMint(msg.sender, current);
        _idCounter.increment();
    }
    //funcion de la API de los NFTs
    function _baseURI() internal pure override returns (string memory){
        return "https://avataaars.io/";
    }
    function _paramsURI(uint256 _adn) internal view returns (string memory) {
            string memory params;

            {
                params = string(
                    abi.encodePacked(
                        "accessoriesType=",
                        getAccesoriesType(_adn),
                        "&clotheColor=",
                        getClotheColor(_adn),
                        "&clotheType=",
                        getClotheType(_adn),
                        "&eyeType=",
                        getEyeType(_adn),
                        "&eyebrowType=",
                        getEyeBrowType(_adn),
                        "&facialHairColor=",
                        getFacialHairColor(_adn),
                        "&facialHairType=",
                        getFacialHairType(_adn),
                        "&hairColor=",
                        getHairColor(_adn),
                        "&hatColor=",
                        getHatColor(_adn),
                        "&graphicType=",
                        getGraphicType(_adn),
                        "&mouthType=",
                        getMouthType(_adn),
                        "&skinColor=",
                        getSkinColor(_adn)
                    )
                );
            }

        return string(abi.encodePacked(params, "&topType=", getTopType(_adn)));
    }
    //Funcion que detectara el la imagen del NFT
    function imageByADN(uint256 _adn) public view returns (string memory){
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramsURI(_adn);

        return string(abi.encodePacked(baseURI, "?", paramsURI));
    }
    //construyendo tokenURI para conectar la METADATA del NFT con el archivo json
    function tokenURI(uint256 tokenId) public view override returns (string memory)
    {
        require(
            //_exists import ERC721 OpenZeppelin
            _exists(tokenId),
            "ERC721 Metadata: URI query for nonexistent token"
        );
        uint256 adn = tokenADN[tokenId];
        string memory image = imageByADN(adn);
        //metodo abi sirve para concatenar strings
        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{ "name": "TransHumans #',
                tokenId.toString(),
                '", "description": "TransHumans are randomized Avataaars stored on chain to teach DApp development", "image": "',
                image,
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
