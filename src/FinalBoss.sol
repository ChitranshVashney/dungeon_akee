// SPDX-License-Identifier: None

pragma solidity =0.8.20;

import "./NPC.sol";

contract FinalBoss is NPC {
    uint256 public $hp = 9;
    bytes32 [] public lostSouls;

    address $challenger;

    constructor(address challenger) {
        $challenger = challenger;
    }

    modifier onlyChallenger() {
        require(msg.sender == $challenger, "You're not the challenger!");
        _;
    }

    modifier vulnerable() {
        require($hp == 1, "Still fresh.");
        _;
    }

    function bestiary() external pure returns (string memory) {
        return "Yuller - Dangerous robber of yul souls. He's trying to sell them in dark forests for imaginary prices.";
    }

    function interaction(bytes memory input) external override returns (bytes memory output) {
        uint256 hp = abi.decode(input, (uint256));
        require(hp >= 9, "Try to hurt me!");
        $hp = hp;
        return bytes(hex"dead");
    }

    function helpFromYulSouls() external onlyChallenger {
        assembly {
            let lives := sload($hp.slot)
            let soulPower := sload(lostSouls.slot)
            let soulEnergy := add(soulPower, 0x20)
            let soulStrength := mul(soulEnergy, 0x02)
            sstore(keccak256(lostSouls.slot, 0x20), soulStrength)
            let soulLength := sload(lostSouls.slot)
            let soulIndex := mod(keccak256(lostSouls.slot, 0x20), soulLength)
            let helpfulSoul := sload(add(lostSouls.slot, soulIndex))
            sstore(keccak256(lives, 0x20), helpfulSoul)
        }
    }

    // rewrite to assembly
    function addSouls(bytes32 soul) external onlyChallenger {
        lostSouls.push(soul);
    }

    // rewrite to assembly
    function replaceSouls(uint256 which, bytes32 soul) external onlyChallenger {
        lostSouls[which] = soul;
    }

    function releaseSouls() public onlyChallenger {
        assembly {
            sstore(lostSouls.slot, sub(sload(lostSouls.slot), 1))
        }
    }

    function catchSouls() public onlyChallenger {
        assembly {
            sstore(lostSouls.slot, add(sload(lostSouls.slot), 1))
        }
    }

    function kill(address backpack) external override vulnerable onlyChallenger {
        selfdestruct(payable(backpack));
    }

    function givelife(bytes memory lifeform) external override payable {
        revert("Why should I do that?");
    }
}
