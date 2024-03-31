# Decentralized Stablecoin

![DSCEngine Logo](assets/types-of-stablecoins.png)

## Description

The DSCEngine is a decentralized stablecoin system designed to maintain a 1 token = $1 peg. It is similar to DAI, but without fees, governance, and is only backed by WETH and WBTC. The system aims to be overcollateralized at all times, ensuring that the value of all collateral is greater than or equal to the dollar-backed value of the DSC token.

## Features

- **Exogenous Collateral**: The system is backed by external collateral tokens (e.g., WETH, WBTC).
- **Dollar Pegged**: The DSC token maintains a 1:1 peg to the US dollar.
- **Algorithmically Stable**: The system uses algorithmic mechanisms to maintain the stability of the DSC token.
- **Overcollateralized**: The value of all collateral tokens should always be greater than or equal to the dollar-backed value of the DSC token.

## Functionality

The DSCEngine contract handles the core logic for minting and redeeming DSC tokens, as well as depositing and withdrawing collateral. Here are the main functions:

1. **`depositCollateralAndMintDsc`**: Allows users to deposit collateral and mint DSC tokens in a single transaction.
2. **`depositCollateral`**: Enables users to deposit collateral tokens.
3. **`redeemCollateralForDsc`**: Allows users to redeem collateral and burn DSC tokens in a single transaction.
4. **`redeemCollateral`**: Enables users to redeem their deposited collateral tokens.
5. **`mintDsc`**: Allows users to mint new DSC tokens if they have sufficient collateral.
6. **`burnDsc`**: Enables users to burn their DSC tokens.
7. **`liquidate`**: Allows liquidators to liquidate users who have broken the health factor. Liquidators receive a bonus collateral as an incentive.

## Getting Started

To use the DSCEngine contract, you'll need to deploy it to an Ethereum network and interact with it using a compatible Ethereum client or library.

### Using Foundry

This project uses the [Foundry](https://getfoundry.sh/) toolchain for Ethereum smart contract development. Follow these steps to get started:

1. Clone the repository:

```bash
git clone https://github.com/fornitechibi/Foundry-Defi-StableCoin
cd Foundry-Defi-StableCoin
```

2. Install Foundry:

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

3. Build the contracts:

```bash
forge build
```

4. Run the tests:

```bash
forge test
```

5. Deploy the contracts to a network of your choice (e.g., Ethereum mainnet, testnets, or local development networks).

## Dependencies

The DSCEngine contract relies on the following dependencies:

- `@openzeppelin/contracts`: A library for secure smart contract development.
- `@chainlink/contracts`: Provides access to Chainlink's decentralized oracle network for fetching asset prices.

## Security Considerations

While the DSCEngine contract aims to be secure, it's important to note that smart contracts can have vulnerabilities and should be thoroughly audited before production use. Additionally, the use of external price feeds introduces potential risks related to oracle security and manipulation.

## License

This project is licensed under the [MIT License](LICENSE).
