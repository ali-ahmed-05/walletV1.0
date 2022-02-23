// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Account.sol";
import "./interfaces/IAccountDeployer.sol";
import "./interfaces/IBadgeMintable.sol";
import "hardhat/console.sol";

// userAccount[_msgSender()]=address(account); //change

contract Wallet is Admin{

    using Counters for Counters.Counter;
    Counters.Counter private _accounts;

    address private iAccountDeployer;
    address private badgeNFT;

    constructor(address _iAccountDeployer , address _badgeNFT) Admin(){
      iAccountDeployer = _iAccountDeployer;
      badgeNFT = _badgeNFT;
    }

   //0x3B2FA3fB4c7eD3bC495F276DC60782b635bB04d9

  struct WalletItem {

    uint itemId;
    address nftContract;
    uint256 tokenId;
    address payable owner;

  }

  struct gameDetails{

      address manager;
      uint256 limit;
      address[] accounts;

    }

    address[] private Accounts;

    mapping(uint256 => address) public idToAccount;
    mapping(address => address) public userAccount;
    mapping(uint256 => WalletItem) private idToWalletItem;
    mapping(address=> mapping(uint256=>bool)) public NFTexist;
    mapping(address =>mapping(uint256=>address)) private ownerOf;
    mapping(address =>mapping(uint256=>uint256)) private _nftToId; 
    mapping(address=> uint256)public balance;
    mapping(address => mapping(address =>gameDetails)) private gameTomanager;
    mapping(address => address) private gamemanager;

    //fee
    //[]
    //limit -100

    function setGameManager(address game ,address _manager)public onlyOwner{
        gamemanager[game] =  _manager;
    }

    function setGameAccountslimit(address game , uint256 limit)public{ // onlyGameManager //change limit
      require(gameTomanager[game][_msgSender()].accounts.length < limit ,"limit is less than accounts generated "); // accounts length - limit changed camparision
      gameTomanager[game][_msgSender()].limit = limit;
    }

    function createAccount(address vault_,address game , uint8 _nftType) public returns(address) {
      address _manager = gamemanager[game];
      require(_manager != address(0),"game does not exist");
      require(gameTomanager[game][_manager].accounts.length < gameTomanager[game][_manager].limit ,"account request exceeds limit");

      address account = IAccountDeployer(iAccountDeployer).deploy(admin_contract_addr(),_msgSender(),vault_,badgeNFT);
      IBadgeMintable(badgeNFT).createToken("URI", account, _nftType);

      Accounts.push(address(account));
      userAccount[_msgSender()]=address(account); //change
      gameTomanager[game][_manager].accounts.push(account);
      console.log(gameTomanager[game][_manager].accounts.length);
      console.log(gameTomanager[game][_manager].limit);
      return address(account);
    }

    function getGameSubAccounts(address game)public view returns(address[] memory){
      address _manager = gamemanager[game];
      return gameTomanager[game][_manager].accounts;
    }

    function getUserAccounts()public view returns(address[] memory){
      return Accounts;
    }
    
}