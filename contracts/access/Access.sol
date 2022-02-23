// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Access is AccessControlEnumerable{

    using Counters for Counters.Counter;
    Counters.Counter private _accounts;
    uint256 gameID;

    mapping(bytes32 => uint256) private game_to_id; 

     
     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
     bytes32 public constant MASTER_ROLE = keccak256("MASTER_ROLE");
     bytes32 public constant CAPTAIN_ROLE = keccak256("CAPTAIN_ROLE");
     bytes32 public constant SCHOLAR_ROLE = keccak256("SCHOLAR_ROLE");

    constructor(address _owner){
        _setupRole(ADMIN_ROLE, _owner);
        gameID = 0;
    }

    function setupRole(bytes32 role, address account) public onlyRole(ADMIN_ROLE) {
        _setupRole(role,account);
    }

    // function setupGame(string memory game_name) public onlyRole(ADMIN_ROLE) {
    //     game_to_id[keccak256(game_name)] = gameID;
    // }
}