// SPDX-License-Identifier: None

pragma solidity =0.8.20;

import "./NPC.sol";

contract Villager is NPC {
    function interaction(bytes memory) external override returns (bytes memory output) {
        return "Just go to the dungeon, stranger, you'll die or get tokens."
            " Everything what you find in the dungeon can be considered as yours."
            " Beware of traps and webs and try to defeat the dungeon boss."
            " If you do so, whole Etherea will be grateful to you."
            " I know about some (hopefully) useful maps of the dungeon for you."
            " They are in a locked chest in the dungeon."
            " Farewell.";
    }
}
