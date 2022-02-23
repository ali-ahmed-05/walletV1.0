// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;


interface IBadgeMintable {
    function createToken(string memory _tokenURI , address account,uint8 _nftType) external returns(uint);
    function addOwner(address owner_) external;
}
