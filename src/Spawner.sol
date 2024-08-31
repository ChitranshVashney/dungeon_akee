// SPDX-License-Identifier: None

pragma solidity =0.8.20;

import "./NPC.sol";

import "../lib/forge-std/src/console.sol";

contract Spawner {
    address private $dungeon;

    constructor() {
        $dungeon = msg.sender;
    }

    modifier onlyDungeon() {
        require(msg.sender == $dungeon, "Only dungeon can spawn NPCs");
        _;
    }

    function spawnNPC(
        bytes32 secretSubstance,
        bytes memory lifeform
    ) public onlyDungeon returns (address) {
        NPC npc = new NPC{salt: secretSubstance}();
        npc.givelife(lifeform);
        return
            address(
                uint160(
                    uint256(
                        keccak256(
                            abi.encodePacked(
                                hex"d6_94",
                                uint160(
                                    uint256(
                                        keccak256(
                                            abi.encodePacked(
                                                hex"ff",
                                                address(this),
                                                secretSubstance,
                                                keccak256(
                                                    type(NPC).creationCode
                                                )
                                            )
                                        )
                                    )
                                ),
                                hex"01"
                            )
                        )
                    )
                )
            );
    }

    function whereSpawner() external view returns (address) {
        return $dungeon;
    }
}
