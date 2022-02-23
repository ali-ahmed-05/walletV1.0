// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Context.sol";



contract RentVault is ReentrancyGuardUpgradeable , Context {
    
  uint256 private tokenId;
    
  using Counters for Counters.Counter;
  Counters.Counter private _itemIds;
  Counters.Counter private _itemsRented;

  address payable owner;
  
  function initialize()public initializer{
    owner = payable(msg.sender);
  }

  struct MarketItem {
    uint itemId;
    address nftContract;
    uint256 tokenId;
    address payable seller;
    address payable owner;
    uint256 price;
    bool sold;
    bool _isRent;
  }
  
  struct Rent{
      address tenant;
      uint256 totalTime;
      uint256 start;
  }
  
  mapping(address=> mapping(uint256=>bool)) private NFTexist;
  mapping(uint256 => MarketItem) private idToMarketItem;
  mapping(uint256 => Rent) private idToRent;
  

  event MarketItemCreated (
    uint indexed itemId,
    address indexed nftContract,
    uint256 indexed tokenId,
    address seller,
    address owner,
    uint256 price,
    bool sold,
    bool _isRent
  );

  

  function createMarketRentItem(
    address nftContract,
    uint256 tokenId,
    uint256 price,
    uint256 _seconds
  ) public payable nonReentrant {
    require(NFTexist[nftContract][tokenId] == false, "NFT already Exist on the market");
    require(price > 0, "Price must be at least 1 wei");
    NFTexist[nftContract][tokenId] = true;
   
    _itemIds.increment();
    uint256 itemId = _itemIds.current();
    
    idToRent[itemId].totalTime = _seconds;
    
    idToMarketItem[itemId] =  MarketItem(
      itemId,
      nftContract,
      tokenId,
      payable(msg.sender),
      payable(address(0)),
      price,
      false,
      true
    );

    IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

    emit MarketItemCreated(
      itemId,
      nftContract,
      tokenId,
      msg.sender,
      address(0),
      price,
      false,
      true
    );
  }

  function updateRentTime(uint256 itemId, uint256 _seconds) public {
    require(idToMarketItem[itemId].seller == _msgSender() , "You are not the owner");
    idToRent[itemId].totalTime = _seconds;
  }

  function createMarketRent(
    uint256 itemId
    ) public payable nonReentrant {
      uint price;
      uint tokenId = idToMarketItem[itemId].tokenId;
      address buyer;
    
    
    price = idToMarketItem[itemId].price;
    require(msg.value == price, "Please submit the asking price in order to complete the purchase");  
    
    idToRent[itemId].tenant = payable(msg.sender);
    idToRent[itemId].start = block.timestamp;
    idToMarketItem[itemId].seller.transfer(msg.value);  
    _itemsRented.increment();
    
  }

  function getPrice(uint256 itemId) public view returns(uint256){
    return idToMarketItem[itemId].price;
  }
  
  function updateRentCheck(uint256 itemId) public returns(bool){
      uint256 _endingUnix = idToRent[itemId].totalTime + idToRent[itemId].start;
      _endingUnix = _endingUnix * 1 seconds;
      if(_endingUnix > block.timestamp){
          return true;
      }
      else{
        idToRent[itemId].tenant = address(0);
        idToRent[itemId].start = 0;
        idToRent[itemId].totalTime = 0;
        return false;
      }
  }
  
  function play(uint256 itemId) public returns(bool){
      require(updateRentCheck(itemId) == true ,  "update func :: You are not the Authorized to play");
      require(idToRent[itemId].tenant == msg.sender , "address :: You are not the Authorized to play");
      return true;
  }

  function getBackRentedItem(uint256 itemId)public{
      require(updateRentCheck(itemId) == false);
      updateRentCheck(itemId); 
  }

  function RemoveItemFromVault(uint256 itemId)public returns(bool){
     updateRentCheck(itemId);
    require(idToRent[itemId].tenant == address(0),"Remove can occur after rent expires");
    require(idToMarketItem[itemId].seller == _msgSender() , "You are not the owner");
      IERC721(idToMarketItem[itemId].nftContract).transferFrom( 
      address(this),
      _msgSender(), 
      idToMarketItem[itemId].tokenId);
      return true;
  }

  /* Returns all unrented market items */
  function fetchVaultItems() public view returns (MarketItem[] memory) {
    uint itemCount = _itemIds.current();
    uint unsoldItemCount = _itemIds.current() - _itemsRented.current();
    uint currentIndex = 0;

    MarketItem[] memory items = new MarketItem[](unsoldItemCount);
    for (uint i = 0; i < itemCount; i++) {
      if (idToMarketItem[i + 1].owner == address(0)) {
        uint currentId = i + 1;
        MarketItem storage currentItem = idToMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }

  /* Returns onlyl items that a user has purchased */
  function fetchMyNFTs() public view returns (MarketItem[] memory) {
    uint totalItemCount = _itemIds.current();
    uint itemCount = 0;
    uint currentIndex = 0;

    for (uint i = 0; i < totalItemCount; i++) {
      if (idToMarketItem[i + 1].owner == msg.sender) {
        itemCount += 1;
      }
    }

    MarketItem[] memory items = new MarketItem[](itemCount);
    for (uint i = 0; i < totalItemCount; i++) {
      if (idToMarketItem[i + 1].owner == msg.sender) {
        uint currentId = i + 1;
        MarketItem storage currentItem = idToMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }
  

}
