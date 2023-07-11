module bean::blp_manager {
    use sui::object::UID;
    use sui::table::Table;
    use std::type_name::TypeName;
    use sui::tx_context::{TxContext, sender};
    use sui::transfer::{share_object, transfer, public_transfer};
    use sui::object;
    use sui::table;
    use bean::vault::{XVault, AdminCap};
    use sui::coin::{Coin, TreasuryCap};
    use sui::coin;
    use bean::blp::BLP;
    use bean::usdb::USDB;
    use std::option::Option;
    use std::option;
    use bean::vault;
    use sui::clock::Clock;
    use sui::clock;
    use sui::event;
    use std::type_name;
    use sui::event::emit;

    const ErrInvalidAmt: u64 = 1001;
    const ErrInsufficientUsdbOutput: u64 = 1002;
    const ErrInsufficientGlpOutput: u64 = 1003;
    const ErrInsufficientOutput: u64 = 1004;
    const ErrCooldownNotPassed: u64 = 1005;

    const PRICE_PRECISION: u128 = 10 ^ 30; //10 ** 30
    const USDB_DECIMALS: u128 = 18; //10 ** 30
    const BLP_PRECISION: u128 = 10 ^ 18; //10 ** 30
    const MAX_COOLDOWN_DURATION: u128 = 48 * 3600;
    const BASIS_POINTS_DIVISOR: u128 = 10000; //10 ** 30

    struct BLPMANAGER has drop {}

    struct BlpManagerReg has key, store {
        id: UID,
        cooldownDuration: u128,
        lastAddedAt: Table<address, u128>,
        aumAddition: u128,
        aumDeduction: u128,
        inPrivateMode: bool,
        shortsTrackerAveragePriceWeight: u128,
        isHandler: Table<address, bool>,
        blpTreasuryCap: Option<TreasuryCap<BLP>>,
        usdbTreasuryCap: Option<TreasuryCap<USDB>>,
    }

    struct AddLiquidityEvent has copy, drop {
        account: address,
        token: TypeName,
        amount: u128,
        aumInUsdb: u128,
        blpSupply: u128,
        usdbAmount: u128,
        mintAmount: u128
    }

    struct RemoveLiquidityEvent has copy, drop {
        account: address,
        token: TypeName,
        blpAmount: u128,
        aumInUsdb: u128,
        blpSupply: u128,
        usdbAmount: u128,
        amountOut: u128
    }

    fun init(_witness: BLPMANAGER, ctx: &mut TxContext) {
        share_object(BlpManagerReg {
            id: object::new(ctx),
            cooldownDuration: 0,
            lastAddedAt: table::new(ctx),
            aumAddition: 0,
            aumDeduction: 0,
            inPrivateMode: true,
            shortsTrackerAveragePriceWeight: 0,
            isHandler: table::new(ctx),
            blpTreasuryCap: option::none(),
            usdbTreasuryCap: option::none(),
        })
    }

    //@todo validate
    public entry fun config(_adminCap: &AdminCap,
                            inPrivateMode: bool,
                            cooldownDuration: u128,
                            aumAddition: u128,
                            aumDeduction: u128,
                            blpTreasuryCap: TreasuryCap<BLP>,
                            usdxTreasuryCap: TreasuryCap<USDB>,
                            registry: &mut BlpManagerReg,
                            ctx: &mut TxContext){
        registry.inPrivateMode = inPrivateMode;
        registry.cooldownDuration = cooldownDuration;
        registry.aumAddition = aumAddition;
        registry.aumDeduction = aumDeduction;
        option::fill(&mut registry.usdbTreasuryCap, usdxTreasuryCap);
        option::fill(&mut registry.blpTreasuryCap, blpTreasuryCap);
    }

    ///
    /// Add liquidity:
    /// - using token as liquidity, expect min Usdb, Glp
    /// - check whitelisted token, check liquidity share
    /// - token added to liquid pool, usdb debt is minted
    /// - user get back Blp
    ///
    public entry fun addLiquidity<TOKEN>(token: Coin<TOKEN>,
                                         minUsdb: u128,
                                         minGlp: u128,
                                         registry: &mut BlpManagerReg,
                                         xvault: &mut XVault,
                                         sclock: &Clock,
                                         ctx: &mut TxContext){
    }

    ///
    /// Remove liquidity:
    ///     - with some Blp tokens, expect to withdraw some token type with min output amount
    ///     - liquidity removed from share pool, debt is updated
    ///     - user get back token & fee
    ///
    public entry fun removeLiquidity<TOKEN>(blpToken: Coin<BLP>,
                                            minTokenOut: u128,
                                            registry: &mut BlpManagerReg,
                                            xvault: &mut XVault,
                                            sclock: &Clock,
                                            ctx: &mut TxContext){
    }

    ///
    /// Compute current asset under managment as Usdb
    ///
    fun getAumInUsdb(maximise: bool): u128 {
        0
    }
}
