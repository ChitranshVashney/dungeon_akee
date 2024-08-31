// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Dungeon} from "../src/Dungeon.sol";
import "../src/Mathematican.sol";
import "../src/NPC.sol";

contract GambleHelper {
    // Mock rollin function to be used in the gamble test
    function rollin(address dungeonAddress, uint256 value) external {
        // Perform a no-op for now. In real scenarios, this function would implement some logic.
        // For example, we could transfer tokens from the dungeon to a player or a third party.
        // This is just a stub to simulate function signature matching.
    }
}

contract CounterTest is Test {
    Dungeon public dungeon;
    Mathematican public $mathematican;
    NPC public npc;
    GambleHelper public help;

    function setUp() public {
        dungeon = new Dungeon();
        $mathematican = new Mathematican();
        npc = new NPC();
        help = new GambleHelper();
    }

    function test_Increment() public {
        // Initialize with some ether
        (bool a, ) = address(1).call{value: 1000}("");

        vm.startPrank(address(1));

        console.log(
            "Starting balance of player:",
            dungeon.balanceOf(address(1))
        );

        console.log(">>> Player attempting quest: removeWeb1");
        dungeon.removeWeb1(666);
        console.log(
            "Balance after removeWeb1 quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 300

        console.log(">>> Player attempting quest: removeWeb2");
        dungeon.removeWeb2(776);
        console.log(
            "Balance after removeWeb2 quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 800

        console.log("________");
        console.log(">>> Player attempting quest: dodgeTraps (x3)");
        dungeon.dodgeTraps();
        console.log(
            "Balance after 1st dodgeTraps quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 1550

        dungeon.dodgeTraps();
        console.log(
            "Balance after 2nd dodgeTraps quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 2050

        dungeon.dodgeTraps();
        console.log(
            "Balance after 3rd dodgeTraps quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 2300

        console.log("________");
        console.log(">>> Warp time forward to simulate game progression");
        vm.warp(5);

        console.log(">>> Player attempting quest: findMoreTraps");
        dungeon.findMoreTraps();
        console.log(
            "Balance after findMoreTraps quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 3050

        console.log("________");
        console.log(">>> Player attempting additional dodgeTraps quests (x5)");
        dungeon.dodgeTraps();
        console.log(
            "Balance after 4th dodgeTraps quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 4300

        dungeon.dodgeTraps();
        console.log(
            "Balance after 5th dodgeTraps quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 5300

        dungeon.dodgeTraps();
        console.log(
            "Balance after 6th dodgeTraps quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 6050

        dungeon.dodgeTraps();
        console.log(
            "Balance after 7th dodgeTraps quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 6550

        dungeon.dodgeTraps();
        console.log(
            "Balance after 8th dodgeTraps quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 6800

        console.log("________");
        console.log(">>> Player interacting with NPC for Ether quest");
        (bool s, ) = address(npc).call{value: 1000}("");
        npc.kill(address(dungeon));

        console.log(">>> Player attempting quest: etherForTokens");
        dungeon.etherForTokens();
        console.log(
            "Balance after etherForTokens quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 7800

        console.log(">>> Player attempting quest: lockedChest with PIN");
        dungeon.lockedChest(4294968530);
        console.log(
            "Balance after lockedChest quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 9300

        console.log(">>> Player attempting quest: gamble with 2000 buy-in");
        dungeon.gamble(help.rollin, 2000);
        console.log(
            "Balance after gamble quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 11300

        console.log(">>> Player attempting quest: removeWeb3");
        dungeon.removeWeb3(
            0x8000000000000000000000000000000000000000000000000000000000000000
        );
        console.log(
            "Balance after removeWeb3 quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 11300 (no gain expected)

        console.log(">>> Player attempting quest: assignChallenger");
        dungeon.assignChallenger();
        console.log(
            "Final balance after assignChallenger quest:",
            dungeon.balanceOf(address(1))
        ); // Expected 13800

        console.log("________");
        console.log("Final balance of player:", dungeon.balanceOf(address(1)));
    }
}
