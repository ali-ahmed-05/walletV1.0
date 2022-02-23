// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import "./interfaces/IAccountDeployer.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Account.sol";

contract AccountDeployer is IAccountDeployer {

    using Counters for Counters.Counter;
    Counters.Counter private nonce;
    
   struct Parameters {
            address admin;
            address owner;
            address vault;
            address badgeNft;
    }

    
    Parameters public override parameters;

    
    function deploy(
            address admin,
            address owner,
            address vault,
            address badgeNft
    ) external override returns (address account) {
        parameters = Parameters({admin: admin, owner: owner, vault: vault , badgeNft:badgeNft});
        account = address(new Account{salt: keccak256(abi.encode(admin, owner, vault, badgeNft, nonce , block.timestamp))}());
        nonce.increment();
        delete parameters;
    }
}