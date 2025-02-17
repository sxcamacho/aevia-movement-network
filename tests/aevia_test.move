module tests::aevia_test {
    use std::signer;
    use std::option;
    use aptos_framework::coin;
    use movement::aevia;

    #[test]
    public fun test_init_agent_authority() {
        let admin = @0x1;
        let agent = @0x2;

        aevia::init_agent_authority(&signer::borrow(admin), agent);
        let authority = aevia::AgentAuthority { agent_address: option::some(agent) };
        assert!(authority == *move_from<aevia::AgentAuthority>(admin), 1);
    }

    #[test]
    public fun test_deposit() {
        let user = @0x1;
        let initial_balance = 1_000_000;
        let deposit_amount = 100;

        coin::mint(user, initial_balance);
        aevia::deposit<coin::AptosCoin>(&signer::borrow(user), deposit_amount);
        let balance = aevia::get_balance<coin::AptosCoin>(user);

        assert!(balance == deposit_amount, 2);
    }

    #[test]
    public fun test_transfer_from_vault() {
        let admin = @0x1;
        let user = @0x2;
        let agent = @0x3;
        let recipient = @0x4;
        let initial_balance = 1_000_000;
        let deposit_amount = 500;
        let transfer_amount = 200;

        coin::mint(user, initial_balance);

        aevia::init_agent_authority(&signer::borrow(admin), agent);
        aevia::deposit<coin::AptosCoin>(&signer::borrow(user), deposit_amount);
        aevia::transfer_from_vault<coin::AptosCoin>(
            &signer::borrow(agent),
            user,
            recipient,
            transfer_amount
        );

        let vault_balance = aevia::get_balance<coin::AptosCoin>(user);
        let recipient_balance = coin::balance<coin::AptosCoin>(recipient);

        assert!(vault_balance == deposit_amount - transfer_amount, 3);
        assert!(recipient_balance == transfer_amount, 4);
    }
}
