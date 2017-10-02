# equio

Smart contract to allow entities to invest ETH into ICOs, receive ICO tokens from the ICO into the contract, and then distribute those ICO tokens back to investors in proportion to their ETH contribution.

## Contents

* [Installation](#installation)
* [Developing](#developing)
* [Deployment](#deployment)

## Installation

### Prerequisites

* Homebrew >= 1.3.4 (if using OSX)
* Parity >= 1.7.0
* Node.js >= 8.1.4
* Yarn >= 1.1.0

If you don't have Homebrew

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

If you're not using OSX, you can use a different package manager, or install the other pre-requisites manually.

If you don't have Parity

```bash
brew tap paritytech/paritytech
brew install parity --stable
```

If you don't have Node.js

```bash
brew install nvm
nvm install node
```

If you don't have Yarn

```bash
brew install yarn
```

### Instructions

Run Parity and go to http://127.0.0.1:3001/ and make sure you see something. If you see something, it's working :)

Let Parity sync to the current block, but you can move on to the next step while it does that

Install packages (this might take a while the first time)

```bash
yarn install
```

## Developing

Start Parity at the beginning of each coding session

### Tools

TODO

## Testing

### Setup

#### Initial Items

1. Change Parity to use the Kovan testnet in `Settings > Parity`
2. Create a new account on the Kovan testnet called `Equio Test`
3. Create another account called `TestCoin ICO Contract`

#### Tokens

1. Create a new secret gist on GitHub called `Kovan Testnet Faucet Verification for Equio Test` and the content being plaintext of just the Ethereum public address from `Equi Test`
2. Get some tokens from the faucet (replace `GIST_URL` with your gist URL from the previous step)

```bash
curl http://github-faucet.kovan.network/url --data "address=GIST_URL"
```

### Deployment

1. Follow the deployment process for the genesis contract
2. Follow the deployment process for a new syndicated ICO contract

Variable              | Value
--------------------- | -----
`_name`               | TestCoin ICO Syndication
`_sale`               | TestCoin ICO Contract
`_token`              | TestCoin ICO Contract
`password_hash`       | (Get the hash from https://emn178.github.io/online-tools/keccak_256.html, prefix the resulting hash with 0x, and make sure you save the password and hash to 1Password)
`_earliest_buy_block` | 0
`_earliest_buy_time`  | 0

### Contract

1. In Parity, go to `Accounts > Equio Test` and click on the transaction hash which executed `generate` on the `Equio Genesis` contract (this should open Etherscan in a new tab)
2. Click on the `to` address to load the contract
3. Click on the `Verify and Publish` link
3. In Parity, go to `Contracts` and then (finish this later)

## Deployment

### Releasing the Genesis Contract (one time only)

1. In Parity, go to `Contracts > Develop`
2. Paste the source of `equio.sol` into the contract source field
3. Click the `Compile` button on the top right corner
4. Click the `Select a contract` dropdown and select `EquioGenesis`
5. Click the `Deploy` button on the top right corner
6. Call the contract `Equio Genesis`
7. Set the contract description to `The genesis contract for creating Equio smart contract for equitable group investments on the Ethereum network`
8. Post the transaction and wait for the transaction is mined, then go to the Contracts section index and verify the contract has been created

### Releasing a New Syndicated ICO Contract (once for each new syndication as they come up)

1. In Parity, go to Contracts and click on the `Equio Genesis` contract
2. Click the `Execute` button

Variable              | Type    | Description                                                     | Example
--------------------- | ------- | --------------------------------------------------------------- | -------
`_name`               | string  | What you want to call the Equio contract                        | TestCoin ICO Syndication
`_sale`               | address | Where the funds get sent to from the Equi contract              | 0x12345...
`_token`              | address | ERC20 token address                                             | 0x98765...
`_password_hash`      | bytes32 | Keccak256 hash of the kill switch password                      | 0x911...
`_earliest_buy_block` | uint256 | Earliest block that the sale address will accept funds          | 4114554
`_earliest_buy_time`  | uint256 | Earliest Unix timestamp that the sale address will accept funds | 1506922638

Post the transaction and wait for the transaction to be mined

### Usage

Start Parity before creating each new Equio contract

The rest below needs to be edited into the above structure.

-----

- Record the address of the new Equio contract returned by the generate function.
- Use https://etherscan.io/verifyContract to verify the generated contract source code.
- Share the new Equio contract's address and password.
- Investors should look up the contract address received to check for the expected source code.
- Investments must be made with an amount over 1 finney. Amounts less than this will trigger a withdrawal.
- Anyone with the password can call the kill switch function.
- Someone must call the buy_sale function to trigger sending funds from the contract to the ICO address.
