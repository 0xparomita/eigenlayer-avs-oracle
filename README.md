# EigenLayer AVS Oracle

In 2026, **EigenLayer and Restaking** form the backbone of modular Ethereum security. This repository provides a professional-grade template for building an Actively Validated Service (AVS). It demonstrates how an oracle network can utilize restaked ETH security instead of relying on a native token pool.

## System Architecture
- **AVS Governance:** Smart contracts handling operator registration, task creation, and slashing challenges.
- **Operator Node:** An off-chain service that monitors tasks, processes off-chain data calculations, and signs responses.
- **Aggregator Node:** Collects BLS signatures from multiple operators and posts the aggregate proof back to Ethereum.

## Quick Start
1. Install project dependencies: `npm install`
2. Spin up a local testing environment using Hardhat or Anvil.
3. Start the mock operator node: `node operator.js`

## Technical Details
- Solidity ^0.8.24
- Ethers.js v6
- BLS Signature Library integrations
