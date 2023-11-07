Created by yumsan11
---

# Token Transfer and Minting Program

This Aleo program defines a set of functions for transferring and minting tokens on the Aleo network. The program uses a combination of public and private transactions to ensure secure and private token transfers.

## Program Structure

- **On-Chain Storage**: The program maintains an on-chain storage called `account`, which is a mapping of `address` to `u64`. This storage keeps track of token balances for different users.

- **Token Record**: The program defines a `token` record that represents a token with an owner's `address` and an `amount` of tokens.

## Transfer Tokens

### `transfer_public`

- Publicly transfers tokens from the caller to a specified receiver.

### `transfer_private`

- Privately transfers tokens from a token record to a specified receiver.

### `transfer_private_to_public`

- Converts tokens from a token record to public tokens for a specified receiver.

### `transfer_public_to_private`

- Converts public tokens back into a token record for the receiver.

## Mint Tokens

### `mint_public`

- Issues tokens publicly to a specified receiver on the network.

### `mint_private`

- Initializes a new token with a specified amount for the receiver.

## Usage

You can deploy and interact with this program on the Aleo network to enable secure and private token transfers. The program uses public and private transactions to ensure the privacy and security of token operations.

---

This readme provides a high-level overview of the program's structure and functionality. Users can deploy and interact with this program on the Aleo network to manage token transfers and minting securely and privately.
