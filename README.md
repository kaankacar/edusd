# $edUSD: The Algorithmic Stablecoin of Edu Chain

**Contract Address:** `0x88CE6C21c53A602A3333C5970DB703Fb9e0dDBF6`

## Table of Contents

1. [Introduction](#introduction)
2. [What are Algorithmic Stablecoins?](#what-are-algorithmic-stablecoins)
3. [How $edUSD Maintains Its Peg](#how-edUSD-maintains-its-peg)
4. [Features](#features)
5. [Getting Started](#getting-started)
6. [Smart Contract](#smart-contract)
7. [Frontend](#frontend)
8. [Testing](#testing)
9. [Contributing](#contributing)
10. [License](#license)

## Introduction

$edUSD is an algorithmic stablecoin project built on the Edu Chain. It aims to demonstrate the principles of algorithmic stablecoins while providing a platform for learning and experimentation in the world of decentralized finance (DeFi).

## What are Algorithmic Stablecoins?

Algorithmic stablecoins are cryptocurrencies designed to maintain a stable value relative to a reference asset, typically the US Dollar, without being backed by traditional collateral. Instead, they use algorithms to automatically adjust the token supply based on market demand, aiming to maintain price stability.

Key characteristics of algorithmic stablecoins:

1. No traditional collateral backing
2. Supply adjustments based on market conditions
3. Utilization of smart contracts for autonomous operation
4. Potential for high scalability

## How $edUSD Maintains Its Peg

$edUSD employs several mechanisms to maintain its peg to the US Dollar:

1. **Rebasing Mechanism**: The smart contract periodically adjusts the total supply based on the current price of edUSD relative to its target price ($1).

   - If price > $1: The supply increases, theoretically reducing the price.
   - If price < $1: The supply decreases, theoretically increasing the price.

2. **Price Oracle**: $edUSD uses a Chainlink price feed to get accurate, real-time price data for decision-making.

3. **Rebase Cooldown**: To prevent excessive volatility, rebases can only occur after a set cooldown period (default: 1 hour).

4. **Adjustable Parameters**: The contract owner can fine-tune parameters such as target price, rebase percentage, and cooldown period to optimize stability.

## Features

- Algorithmic supply adjustments
- Chainlink price feed integration
- Claim function for users to receive $edUSD
- Ownable contract with adjustable parameters
- Comprehensive testing suite

## Getting Started

To interact with $edUSD:

1. Connect your wallet to the Edu Chain network.
2. Visit our website to view current $edUSD statistics and claim tokens.
3. (Optional) Interact directly with the smart contract using tools like ethers.js or web3.js.

## Smart Contract

The $edUSD smart contract is written in Solidity and includes the following key functions:

- `claim()`: Allows users to claim 1 $edUSD token.
- `rebase()`: Adjusts the total supply based on current price.
- `get$edUSDChainlinkPrice()`: Retrieves the current price from the Chainlink oracle.
- `setTargetPrice()`, `setRebaseCooldown()`, `setRebasePercentage()`: Owner functions to adjust parameters.

For a full understanding of the contract, please review the [source code](./contracts/$edUSD.sol).

## Frontend

Our frontend application provides an intuitive interface for interacting with the $edUSD ecosystem:

- Real-time price display
- Total and circulating supply information
- Claim functionality
- Educational resources about algorithmic stablecoins

To run the frontend locally:

```bash
npm install
npm run dev
```

## Testing

We use Foundry for comprehensive smart contract testing. To run the tests:

```bash
forge test
```

Our test suite covers various scenarios including:

- Initial setup verification
- Claim functionality
- Rebase mechanism
- Owner-only functions
- Edge cases and potential vulnerabilities

## Contributing

We welcome contributions to the $edUSD project! Please see our [CONTRIBUTING.md](./CONTRIBUTING.md) for details on how to get involved.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

---

$edUSD is an educational project and should not be used for real financial transactions. Always do your own research and understand the risks before interacting with any DeFi protocols.