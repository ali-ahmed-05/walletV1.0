// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import "./interfaces/IBadgeMintable.sol";

contract Badge is ERC721 , Ownable , IBadgeMintable{
    using Counters for Counters.Counter;
     using Strings for uint256;
     Counters.Counter private _tokenIds;
     address contractAddress;
     address private walletAddress;

     uint256 public maxSupply;
     
     address[] public whitelistedAddresses;

    uint256 public Bronze;//0
    uint256 public Silver;//1
    uint256 public Gold;//2



    mapping(address => bool) private _owner;
    mapping(address => uint256) public addressMintedBalance;
    mapping(uint256 => uint256) public nftType;
    
     // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

     // Mapping from owner to list of owned token IDs
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _tokenIdType;

    // Array with all token ids, used for enumeration
    uint256[] private _allTokens;

    // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;
    //,address pubSale
    constructor() ERC721("badge", "BT") {
        _owner[_msgSender()] = true;
        
    }

    modifier onlyWallet() {
        require( walletAddress == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function tokenType(uint256 id)public view returns(uint256){
        return _tokenIdType[id];
    }

    function baseURI() public view returns(string memory){
        return "https://ipfs.io/ipfs/";
    }

      function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = baseURI();

        if (bytes(base).length == 0) {
            return _tokenURI;
        }
     
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
    }

    function _setwalletAddress(address _wallet) public onlyOwner {
        require(_wallet != address(0) , "cant assign zero address");
        walletAddress = _wallet;
        _owner[_wallet] = true;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

  

    function addOwner(address owner_) public override onlyWallet {
        require(walletAddress == _msgSender(),"cannot Assign owner");
        _owner[owner_]=true;
    }


    function createToken(string memory _tokenURI , address account,uint8 _nftType) public override returns(uint) {
        require(_owner[_msgSender()]==true,"Not authorized to mint");   
        require(addressMintedBalance[account] < 5,"you have minted 5 NFTs");  
        require(inc_nftType(_nftType));
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        
        _mint(account, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        _tokenIdType[newItemId]=_nftType;
        addressMintedBalance[account]++;
        return newItemId;
    }

    //returns the total number of Nfts minted from this contract

    function totalSupply() private view returns(uint256){
        return _tokenIds.current();
    }

   
    function inc_nftType(uint8 no) private returns(bool){

            if(no==0){
                Bronze++;
                return true;
            }else if(no==1){
               
                Silver++;
                return true;
            }else if(no==2){
               
                Gold++;
                return true;
            }else{
                require(false,"Type not found");
                return false;
            }
    }

    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);

        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256) {
        require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[owner][index];
    }

    function tokenByIndex(uint256 index) public view virtual  returns (uint256) {
        require(index <= totalSupply(), "ERC721Enumerable: global index out of bounds");
        return _allTokens[index];
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);

        if (from == address(0)) {
            _addTokenToAllTokensEnumeration(tokenId);
        } else if (from != to) {
            _removeTokenFromOwnerEnumeration(from, tokenId);
        }
        if (to == address(0)) {
            _removeTokenFromAllTokensEnumeration(tokenId);
        } else if (to != from) {
            _addTokenToOwnerEnumeration(to, tokenId);
        }
    }

   
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        uint256 length = ERC721.balanceOf(to);
        _ownedTokens[to][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
    }

    
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
       

        uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

      
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId;  
            _ownedTokensIndex[lastTokenId] = tokenIndex; 
        }

        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }

    
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
       

        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId];
        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; 
        _allTokensIndex[lastTokenId] = tokenIndex; 


        delete _allTokensIndex[tokenId];
        _allTokens.pop();
    }
}