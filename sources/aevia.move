module movement::aevia {
    use std::signer;
    use aptos_framework::coin;
    use std::option;

    /// Represent a vault for a user
    struct Vault<phantom CoinType> has key, store {
        balance: coin::Coin<CoinType>,
    }

    /// Agent address authorized to manage funds
    struct AgentAuthority has key, store, drop {
        agent_address: option::Option<address>,
    }

    /// Allows the administrator to initialize the authorized agent
    public entry fun init_agent_authority(admin: &signer, agent_address: address) {
        let admin_addr = signer::address_of(admin);
        move_to<AgentAuthority>(admin, AgentAuthority {
            agent_address: option::some(agent_address),
        });
    }

    /// Allows the administrator to update the authorized agent address
    public entry fun update_agent_address(admin: &signer, new_agent_address: address) acquires AgentAuthority {
        let authority = borrow_global_mut<AgentAuthority>(signer::address_of(admin));
        authority.agent_address = option::some(new_agent_address);
    }

    /// Allows a user to deposit funds into their investment account
    public entry fun deposit<CoinType>(
        account: &signer,
        amount: u64
    ) acquires Vault {
        let user_addr = signer::address_of(account);

        if (!exists<Vault<CoinType>>(user_addr)) {
            move_to<Vault<CoinType>>(account, Vault {
                balance: coin::zero<CoinType>(),
            });
        };

        let coins = coin::withdraw<CoinType>(account, amount);
        let vault = borrow_global_mut<Vault<CoinType>>(user_addr);
        coin::merge(&mut vault.balance, coins);
    }

    /// Allows the agent to transfer funds from the user's investment account to another address (e.g. heir, investment)
    public entry fun transfer_from_vault<CoinType>(
        agent: &signer,
        from: address,
        to: address,
        amount: u64
    ) acquires Vault, AgentAuthority {
        let agent_addr = signer::address_of(agent);
        let authority = borrow_global<AgentAuthority>(agent_addr);
        let agent_address = *option::borrow(&authority.agent_address);
        assert!(agent_addr == agent_address, 0);

        let vault = borrow_global_mut<Vault<CoinType>>(from);
        let coins = coin::extract(&mut vault.balance, amount);
        coin::deposit<CoinType>(to, coins);
    }

    /// Allows to consult the balance of the user's investment account
    public fun get_balance<CoinType>(
        user: address
    ): u64 acquires Vault {
        let vault = borrow_global<Vault<CoinType>>(user);
        coin::value(&vault.balance)
    }
}
