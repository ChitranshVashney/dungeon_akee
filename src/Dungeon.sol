// SPDX-License-Identifier: None

pragma solidity =0.8.20;

/* NPCs */
import "./NPC.sol";
import "./Villager.sol";
import "./Mathematican.sol";
import "./FinalBoss.sol";

/* Objects */
import "./Spawner.sol";

/* Helpers */
// import "../lib/forge-std/src/console.sol";

contract Dungeon {
    Spawner public $spawner;
    NPC public $storyTeller;
    NPC public $mathematican;
    NPC public $finalBoss;

    mapping(bytes4 => bool) public $quests;
    uint256 public $traps;
    address public $challenger;

    event Subtitles(string subtitles);

    /*
        Modifiers
    */

    modifier takeQuest() {
        require($quests[msg.sig] == false, "Quest already taken");
        $quests[msg.sig] = true;
        _;
    }

    modifier onlyHumans() {
        uint256 size;
        assembly {
            size := extcodesize(caller())
        }
        require(size <= 0, "You're trying to trick me with a contract!");
        _;
    }

    modifier cleanRoom() {
        require(
            $quests[this.removeWeb1.selector] == true &&
                $quests[this.removeWeb2.selector] == true &&
                $quests[this.removeWeb3.selector] == true,
            "These functions cannot be called"
        );
        _;
    }

    modifier altarFound() {
        require(
            $quests[this.dodgeTraps.selector] == true,
            "These functions cannot be called"
        );
        _;
    }

    modifier bossSpawned() {
        require(
            $quests[this.spawnFinalBoss.selector] == true,
            "These functions cannot be called"
        );
        _;
    }

    modifier lootGained() {
        require(
            $quests[this.lockedChest.selector] == true,
            "These functions cannot be called"
        );
        _;
    }

    modifier challenger() {
        require(msg.sender == $challenger, "You're not the challenger");
        _;
    }

    constructor() {
        // init dungeon
        $spawner = new Spawner();
        $storyTeller = NPC(
            _spawn(keccak256("storyTeller"), type(Villager).creationCode)
        );
        $mathematican = NPC(
            _spawn(keccak256("mathematican"), type(Mathematican).creationCode)
        );
        $traps = 3;
        // mint potential rewards
        _mint(address(this), 100_000);
    }

    /*
        Collect tokens from dungeon
    */

    // get 300 tokens
    function removeWeb1(uint256 slashes) external takeQuest {
        unchecked {
            _attempt(
                slashes == 666,
                300,
                msg.sender,
                "Devil's cut!",
                "Caught in web1"
            );
        }
    }

    // get 500 tokens
    function removeWeb2(uint256 slashes) external takeQuest {
        unchecked {
            _attempt(
                (((((slashes * 3) ^ 2) % 1000) + $traps) * 2) == 666,
                500,
                msg.sender,
                "Devil's cut!",
                "Caught in web2"
            );
        }
    }

    // get 3000 tokens
    function removeWeb3(uint256 slashes) external takeQuest {
        unchecked {
            _attempt(
                abi.decode(
                    $mathematican.interaction(abi.encode(slashes)),
                    (uint256)
                ) == 666,
                3000,
                msg.sender,
                "Devil's cut!",
                "Caught in web3"
            );
        }
    }

    // get 750 tokens
    function findMoreTraps() external takeQuest {
        uint256 traps = uint256(block.timestamp /* + block.prevrandao */) % 6;
        traps == 0 || traps == 1 ? traps += 2 : traps;
        $traps = traps;
        _attempt(
            traps == 5,
            750,
            msg.sender,
            "Nicely done!",
            "You missed some traps."
        );
    }

    // get 1000 tokens
    function etherForTokens() external takeQuest {
        _attempt(
            address(this).balance == 1000,
            1000,
            msg.sender,
            "Etheeer!",
            "You failed."
        );
        _muhahaha();
    }

    // get 1500 tokens
    function lockedChest(uint256 pin) external takeQuest {
        require(pin != 1234, "You're cheatin'");
        uint32 allowed_range_pin = uint32(pin);
        _attempt(
            allowed_range_pin == 1234,
            1500,
            msg.sender,
            "Gotcha.",
            "Incorrect pin."
        );
    }

    // get something
    function gamble(
        function(address, uint256) external rollin,
        uint256 buyIn
    ) external takeQuest {
        rollin(address(this), (buyIn / 1000) * buyIn);
        _attempt(
            buyIn <= 2000,
            buyIn,
            msg.sender,
            "Nice game.",
            "You're too greedy."
        );
    }

    // one wish in front of altar
    function spawnNPC(
        bytes32 secretSubstance,
        bytes memory lifeform
    ) public altarFound takeQuest {
        $spawner.spawnNPC(secretSubstance, lifeform);
    }

    // get 2500 tokens
    function assignChallenger() external cleanRoom onlyHumans takeQuest {
        $challenger = msg.sender;
        _attempt(1 == 1, 2500, msg.sender, "Buy something useful.", "Wut?");
    }

    // get 10000 tokens
    function spawnFinalBoss()
        external
        challenger
        altarFound
        cleanRoom
        lootGained
        takeQuest
    {
        $finalBoss = NPC(
            _spawn(
                keccak256("finalBoss"),
                abi.encodePacked(
                    type(FinalBoss).creationCode,
                    abi.encode(msg.sender)
                )
            )
        );
    }

    function finalBoss() external bossSpawned takeQuest {
        uint256 defeated;
        address f = address($finalBoss);
        assembly {
            defeated := extcodesize(f)
        }
        _attempt(
            defeated == 0,
            10000,
            msg.sender,
            "What a legend!",
            "You have been defecated"
        );
    }

    // get something
    function dodgeTraps() external {
        if ($traps == 0) {
            $quests[msg.sig] = true;
            emit Subtitles("You dodged all traps.");
            return;
        }
        _attempt($traps >= 0, 250 * $traps, msg.sender, "Doge!", "You failed.");
        _muhahaha();
        $traps--;
    }

    /*
        Helper part
    */

    function _attempt(
        bool condition,
        uint256 value,
        address to,
        string memory good,
        string memory bad
    ) private {
        if (condition) {
            this.transfer(to, value);
            emit Subtitles(good);
        } else {
            this._burn(address(this), value);
            emit Subtitles(bad);
        }
    }

    function _spawn(
        bytes32 secretSubstance,
        bytes memory lifeform
    ) private returns (address payable) {
        return payable($spawner.spawnNPC(secretSubstance, lifeform));
    }

    function _muhahaha() private {
        msg.sender.call{value: 0}("");
    }

    /*
        Evaluation part
    */

    function evaluate(address hackeer) external view returns (uint256) {
        return $balances[hackeer];
    }

    /*
        ERC20 part
    */

    uint256 public $totalSupply;
    mapping(address => uint256) public $balances;
    mapping(address => mapping(address => uint256)) public $allowed;

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return $balances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require($balances[msg.sender] >= _value);
        $balances[msg.sender] -= _value;
        $balances[_to] += _value;
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(
            $balances[_from] >= _value && $allowed[_from][msg.sender] >= _value
        );
        $balances[_to] += _value;
        $balances[_from] -= _value;
        $allowed[_from][msg.sender] -= _value;
        return true;
    }

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        $allowed[msg.sender][_spender] = _value;
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256 remaining) {
        return $allowed[_owner][_spender];
    }

    function _mint(address _to, uint256 _amount) private {
        $totalSupply += _amount;
        $balances[_to] += _amount;
    }

    function _burn(address _from, uint256 _amount) external {
        require(_from == address(this), "You don't have such power.");
        require($balances[_from] >= _amount);
        $totalSupply -= _amount;
        $balances[_from] -= _amount;
    }

    receive() external payable {
        revert("You can't bribe the dungeon!");
    }

    fallback() external {
        revert("Fall back stranger.");
    }
}
