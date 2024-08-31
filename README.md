# Dungeon Game Quest Summary

## Quest Overview

This document provides a summary of the quests completed in the Dungeon game, along with details about the balance changes for the player after each quest.

## Summary of Quests

1. **removeWeb1**

   - **Input:** `666`
   - **Expected Balance Change:** 300
   - **New Balance:** `700`

2. **removeWeb2**

   - **Input:** `776`
   - **Expected Balance Change:** 800
   - **New Balance:** `800`

3. **dodgeTraps** (x3)

   - **Input:** N/A
   - **Expected Balance Changes:**
     - After 1st quest: `1550`
     - After 2nd quest: `2050`
     - After 3rd quest: `2300`

4. **findMoreTraps**

   - **Input:** N/A
   - **New Balance:** `3050`

5. **Additional dodgeTraps** (x5)

   - **Expected Balance Changes:**
     - After 4th quest: `4300`
     - After 5th quest: `5300`
     - After 6th quest: `6050`
     - After 7th quest: `6550`
     - After 8th quest: `6800`

6. **etherForTokens**

   - **Input:** N/A
   - **New Balance:** `7800`

7. **lockedChest**

   - **Input:** `4294968530`
   - **New Balance:** `9300`

8. **gamble** (2000 buy-in)

   - **Input:** `help.rollin`
   - **New Balance:** `11300`

9. **removeWeb3**

   - **Input:** `255`
   - **Expected Balance Change:** No gain expected (Balance remains `11300`).

10. **assignChallenger**
    - **Expected Final Balance Change:** +2500
    - **Final Balance:** `13800`

## Important Notes

- **Time Limitation for Final Boss:**
  The time is up for solving the final boss. Ensure that quests related to the final challenge are prioritized.

- **Issue with removeWeb3 Quest:**
  The `removeWeb3` quest seems to be incorrectly designed, as the maximum value allowed of
  ```solidity
  abi.decode(
            $mathematican.interaction(abi.encode(slashes)),
            (uint256)
            )
  ```
  is `255`, while `666` is a required.

### Suggestion:

**Adjust the Quest Parameters:**
Consider revising the value in the `removeWeb3` function from `666` to `255` if game logic permits.

---

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
