// SPDX-License-Identifier: None

pragma solidity =0.8.20;

contract NPC {
    function interaction(bytes memory input) external virtual returns (bytes memory output) {
        return bytes(hex"42");
    }

    function kill(address backpack) external virtual {
        selfdestruct(payable(backpack));
    }

    function givelife(bytes memory lifeform) external virtual payable {
        assembly {
            if iszero(create(0, add(lifeform, 32), mload(lifeform))) {
                revert(0, 0)
            }
            selfdestruct(caller())
        }
    }

    receive () external payable {}
}