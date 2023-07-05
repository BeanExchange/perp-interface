module bean::usdb {
    use std::ascii::string;
    use std::option;

    use bean::payment;

    use sui::balance;
    use sui::coin::{Self, TreasuryCap, Coin};
    use sui::transfer;
    use sui::tx_context::{TxContext, sender};
    use sui::url;
    use sui::transfer::{public_freeze_object};

    const SYMBOL: vector<u8> = b"USDB";
    const NAME: vector<u8> = b"USDB";
    const DESCRIPTION: vector<u8> = b"Bean USDB";
    const DECIMAL: u8 = 9;
    const ICON_URL: vector<u8> = b"https://beanex.s3.ap-southeast-1.amazonaws.com/uploads/mainnet/public/media/images/logo_1679906850804.png";

    struct USDB has drop {}

    fun init(witness: USDB, ctx: &mut TxContext) {
        let (treasury_cap, spt_metadata) = coin::create_currency<USDB>(
            witness,
            DECIMAL,
            SYMBOL,
            NAME,
            DESCRIPTION,
            option::some(url::new_unsafe(string(ICON_URL))),
            ctx);

        transfer::public_freeze_object(spt_metadata);
        transfer::public_transfer(treasury_cap, sender(ctx));
    }

    public entry fun minto(treasuryCap: &mut TreasuryCap<USDB>, to: address, amount: u64, ctx: &mut TxContext) {
        coin::mint_and_transfer(treasuryCap, amount, to, ctx);
    }

    public fun increaseSupply(treasuryCap: &mut TreasuryCap<USDB>, value: u64, ctx: &mut TxContext) {
        minto(treasuryCap, sender(ctx), value, ctx);
    }

    public fun decrease_supply(
        treasuryCap: &mut TreasuryCap<USDB>,
        coins: vector<Coin<USDB>>,
        value: u64,
        ctx: &mut TxContext
    ) {
        let take = payment::take_from(coins, value, ctx);
        let totalSupply = coin::supply_mut(treasuryCap);
        balance::decrease_supply(totalSupply, coin::into_balance(take));
    }

    public fun burn(treasuryCap: &mut TreasuryCap<USDB>,
                    coins: vector<Coin<USDB>>,
                    value: u64,
                    ctx: &mut TxContext) {
        let take = payment::take_from(coins, value, ctx);
        coin::burn(treasuryCap, take);
    }

    public entry fun burn_mint_cap(treasuryCap: TreasuryCap<USDB>, _ctx: &mut TxContext){
        public_freeze_object(treasuryCap);
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(USDB {}, ctx);
    }
}
