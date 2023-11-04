program token.aleo {
    // On-chain storage of an `account` map, with `address` as the key,
    // and `u64` as the value.
    mapping account: address => u64;

    record token {
        // Represents a token with an owner and an amount.
        owner: address,
        amount: u64,
    }

    /* Transfer Tokens */

    // The function `transfer_public` transfers tokens publicly to a receiver.
    transition transfer_public(public receiver: address, public amount: u64) {
        return then finalize_transfer_public(self.caller, receiver, amount);
    }

    finalize finalize_transfer_public(public sender: address, public receiver: address, public amount: u64) {
        // Decrease the sender's token balance by the specified amount.
        let sender_amount: u64 = Mapping::get_or_use(account, sender, 0u64);
        Mapping::set(account, sender, sender_amount - amount);

        // Increase the receiver's token balance by the specified amount.
        let receiver_amount: u64 = Mapping::get_or_use(account, receiver, 0u64);
        Mapping::set(account, receiver, receiver_amount + amount);
    }

    // The function `transfer_private` sends tokens from a token record to a receiver.
    transition transfer_private(sender: token, receiver: address, amount: u64) -> (token, token) {
        // Calculate the remaining tokens for the sender.
        let difference: u64 = sender.amount - amount;
        let remaining: token = token {
            owner: sender.owner,
            amount: difference,
        };
        // Create a new token record for the receiver.
        let transferred: token = token {
            owner: receiver,
            amount: amount,
        };
        return (remaining, transferred);
    }

    // The function `transfer_private_to_public` converts tokens from a token record to public tokens.
    transition transfer_private_to_public(sender: token, public receiver: address, public amount: u64) -> token {
        // Calculate the remaining tokens for the sender.
        let difference: u64 = sender.amount - amount;
        let remaining: token = token {
            owner: sender.owner,
            amount: difference,
        };
        // Increase the receiver's public token balance by the specified amount.
        return remaining then finalize_transfer_private_to_public(receiver, amount);
    }

    finalize finalize_transfer_private_to_public(public receiver: address, public amount: u64) {
        // Increase the receiver's public token balance by the specified amount.
        let current_amount: u64 = Mapping::get_or_use(account, receiver, 0u64);
        Mapping::set(account, receiver, current_amount + amount);
    }

    // The function `transfer_public_to_private` converts public tokens to a token record for the receiver.
    transition transfer_public_to_private(public receiver: address, public amount: u64) -> token {
        // Create a new token record for the receiver.
        let transferred: token = token {
            owner: receiver,
            amount: amount,
        };
        // Decrease the caller's public token balance by the specified amount.
        return transferred then finalize_transfer_public_to_private(self.caller, amount);
    }

    finalize finalize_transfer_public_to_private(public sender: address, public amount: u64) {
        // Decrease the sender's public token balance by the specified amount.
        let current_amount: u64 = Mapping::get_or_use(account, sender, 0u64);
        Mapping::set(account, sender, current_amount - amount);
    }

    /* Mint Tokens */

    // The function `mint_public` issues tokens publicly to a receiver on the network.
    transition mint_public(public receiver: address, public amount: u64) {
        // Mint tokens publicly by invoking the computation on-chain.
        return then finalize_mint_public(receiver, amount);
    }

    finalize finalize_mint_public(public receiver: address, public amount: u64) {
        // Increment the receiver's token balance by the specified amount.
        let current_amount: u64 = Mapping::get_or_use(account, receiver, 0u64);
        Mapping::set(account, receiver, current_amount + amount);
    }

    // The function `mint_private` initializes a new token for the receiver.
    transition mint_private(receiver: address, amount: u64) -> token {
        return token {
            // Set the owner of the new token.
            owner: receiver,
            // Set the token amount.
            amount: amount,
        };
    }
}
