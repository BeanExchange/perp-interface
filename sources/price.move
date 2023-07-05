module bean::price {
    use sui::tx_context::TxContext;
    use bean::vault::AdminCap;

    struct PRICE has drop {}

    struct PriceRegistry has key, store {

    }

    fun init(_witness: PRICE, ctx: &mut TxContext) {

    }

    public fun setTokenConfig<TOKEN>(_adminCap: &AdminCap,
                                     _priceDecimals: u128,
                                     _isStrictStable: bool,
                                     _priceReg: &mut PriceRegistry,
                                     _ctx: &mut TxContext) {

    }

    public fun getLatestPrimaryPrice<TOKEN>(_priceReg: &mut PriceRegistry,
                                            _ctx: &mut TxContext): u128 {
        0
    }

    public fun getPrimaryPrice<TOKEN>(_priceReg: &mut PriceRegistry,
                                      _maximise: bool,
                                      _ctx: &mut TxContext): u128 {
        0
    }

    public fun getPrice<TOKEN>(_maximise: bool,
                               _includeAmmPrice: bool,
                               _useSwapPricing: bool,
                               _priceReg: &mut PriceRegistry,
                               _ctx: &mut TxContext): u128 {
        0
    }
}
