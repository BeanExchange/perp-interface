module bean::vault {
    use bean::i128::I128;
    use sui::object::UID;
    use std::type_name::TypeName;
    use sui::table::Table;
    use sui::coin::Coin;
    use sui::tx_context::TxContext;
    use bean::usdb::USDB;
    use sui::coin;
    use sui::bag::Bag;
    use sui::table;
    use std::type_name;
    use sui::math::min;
    use std::vector;
    use sui::bag;
    use sui::transfer::public_transfer;
    use sui::event;
    use bean::vault_utils;

    friend bean::vault_utils;

    const BASIS_POINTS_DIVISOR: u128 = 10000;
    const FUNDING_RATE_PRECISION: u128 =  1000000;
    const PRICE_PRECISION:  u128 = 10^30;
    const MIN_LEVERAGE: u128 = 10000; // 1x
    const USDG_DECIMALS: u128 = 18;
    const MAX_FEE_BASIS_POINTS: u128 = 500; // 5%
    const MAX_LIQUIDATION_FEE_USD: u128 = 100 * (10^30); // 100 USD
    const MIN_FUNDING_RATE_INTERVAL: u128 = 1*60*60; //seconds
    const MAX_FUNDING_RATE_FACTOR: u128 = 10000; // 1%

    struct LiquidatorCap has key, store{
        id: UID,
    }

    struct OrderKeeperCap has key, store{
        id: UID,
    }

    struct PriceKeeperCap has key, store{
        id: UID,
    }

    struct TreasuryCap has key, store{
        id: UID,
    }

    struct AdminCap has key, store{
        id: UID,
    }

    struct Position has copy, store{
        size: u128, //total pos size, in value
        collateral: u128, //total pos col, in value
        averagePrice: u128, //entry price if the index tokens. updated as average price when position is updated with current price
        entryFundingRate: u128,
        reserveAmount: u128, //diff of size - col in tokens
        realisedPnl: I128,
    }

    struct BuyUsdbEvent has copy, drop {
        account: address,
        token: TypeName,
        tokenAmount: u128,
        usdbAmount: u128,
        feeBasisPoints: u128,
    }

    struct SellUsdbEvent has copy, drop {
        account: address,
        token: TypeName,
        tokenAmount: u128,
        usdbAmount: u128,
        feeBasisPoints: u128,
    }

    struct SwapEvent has copy, drop {
        account: address,
        tokenIn: TypeName,
        tokenOut: TypeName,
        amountIn: u128,
        amountOut: u128,
        amountOutAfterFees: u128,
        feeBasisPoints: u128,
    }

    struct IncreasePositionEvent has copy, drop {
        key: address, //@todo review bytes32 key,
        account: address,
        collateralToken: TypeName,
        indexToken: TypeName,
        collateralDelta: u128,
        sizeDelta: u128,
        isLong: bool,
        price: u128,
        fee: u128
    }

    struct DecreasePositionEvent has copy, drop {
        key: address, //@todo review bytes32 key,
        account: address,
        collateralToken: TypeName,
        indexToken: TypeName,
        collateralDelta: u128,
        sizeDelta: u128,
        isLong: bool,
        price: u128,
        fee: u128
    }


    struct LiquidatePositionEvent has copy, drop {
        key: address, //@todo review bytes32 key,
        account: address,
        collateralToken: TypeName,
        indexToken: TypeName,
        isLong: bool,
        size: u128,
        collateral: u128,
        reserveAmount: u128,
        realisedPnl: u128,
        markPrice: u128
    }


    struct UpdatePositionEvent has copy, drop {
        key: address, //@todo review bytes32 key,
        size: u128,
        collateral: u128,
        averagePrice: u128,
        entryFundingRate: u128,
        reserveAmount: u128,
        realisedPnl: I128,
        markPrice: u128
    }

    struct ClosePositionEvent has copy, drop {
        key: address, //@todo review bytes32 key,
        size: u128,
        collateral: u128,
        averagePrice: u128,
        entryFundingRate: u128,
        reserveAmount: u128,
        realisedPnl: I128,
    }

    struct UpdateFundingRateEvent has copy, drop {
        token: TypeName, //@todo review address TypeName
        fundingRate: u128,
    }

    struct UpdatePnlEvent has copy, drop {
        key: address,
        hasProfit: bool,
        delta: u128,
    }

    struct CollectSwapFeesEvent has copy, drop {
        token: TypeName,
        feeUsd: u128,
        feeTokens: u128,
    }

    struct CollectMarginFeesEvent has copy, drop {
        token: TypeName,
        feeUsd: u128,
        feeTokens: u128,
    }

    struct DirectPoolDepositEvent has copy, drop {
        token: TypeName,
        amount: u128,
    }

    struct IncreasePoolAmountEvent has copy, drop {
        token: TypeName,
        amount: u128,
    }

    struct DecreasePoolAmount has copy, drop {
        token: TypeName,
        amount: u128,
    }

    struct IncreaseUsdgAmount has copy, drop {
        token: TypeName,
        amount: u128,
    }

    struct DecreaseUsdgAmount has copy, drop {
        token: TypeName, //@todo review address token, uint256 feeUsd, uint256 feeTokens
        amount: u128,
    }

    struct DecreaseGuaranteedUsd has copy, drop {
        token: TypeName,
        amount: u256,
    }

    struct IncreaseGuaranteedUsd has copy, drop {
        token: TypeName,
        amount: u256,
    }

    struct DecreaseReservedAmount has copy, drop {
        token: TypeName,
        amount: u256,
    }

    struct IncreaseReservedAmount has copy, drop {
        token: TypeName,
        amount: u256,
    }

    struct Config has copy, store{
        isInitialized: bool,
        isSwapEnabled: bool, //default enabled
        isLeverageEnabled: bool, //default enabled
        maxLeverage: u128,//default =  50 * 10000; // 50x
        liquidationFeeUsd: u128,
        taxBasisPoints: u128, //= 50; // 0.5%
        stableTaxBasisPoints: u128, //= 20; // 0.2%
        mintBurnFeeBasisPoints: u128, //= 30; // 0.3%
        swapFeeBasisPoints: u128, //= 30; // 0.3%
        stableSwapFeeBasisPoints: u128, //= 4; // 0.04%
        marginFeeBasisPoints: u128, // = 10; // 0.1%
        minProfitTime: u128,
        hasDynamicFees: bool, //false
        fundingInterval: u128, // 8 hours;
        fundingRateFactor: u128,
        stableFundingRateFactor: u128,
        totalTokenWeights: u128, //@fixme init
        includeAmmPrice: bool, //true
        useSwapPricing: bool, //false
        inManagerMode: bool, //false
        inPrivateLiquidationMode: bool, //false
        maxGasPrice: u128, //
        usdb: TypeName,
    }

    struct XVault has key, store {
        id: UID,
        isInitialized: bool,
        config: Config,

        allWhitelistedTokens: vector<TypeName>,
        whitelistedTokenCount: u128, //0
        whitelistedTokens: Table<TypeName, bool>,
        tokenDecimals: Table<TypeName, u128>,
        minProfitBasisPoints: Table<TypeName, u128>,
        stableTokens: Table<TypeName, bool>,
        shortableTokens: Table<TypeName, bool>,

        tokenBalances0: Bag, // track all transfer in tokens, maps of type ==> coin
        tokenBalances: Table<TypeName, u128>, // tokenBalances is used only to determine _transferIn values
        tokenWeights: Table<TypeName, u128>, // tokenWeights allows customisation of index composition
        usdbAmounts: Table<TypeName, u128>, // usdb Amounts tracks the amount of USDG debt for each whitelisted token
        maxUsdbAmounts: Table<TypeName, u128>, // maxUsdbAmounts allows setting a max amount of USDG debt for a token

        // poolAmounts tracks the number of received tokens that can be used for leverage
        // this is tracked separately from tokenBalances to exclude funds that are deposited as margin collateral
        poolAmounts: Table<TypeName, u128>,

        // reservedAmounts tracks the number of tokens reserved for open leverage positions
        reservedAmounts: Table<TypeName, u128>,

        // bufferAmounts allows specification of an amount to exclude from swaps
        // this can be used to ensure a certain amount of liquidity is available for leverage positions
        bufferAmounts: Table<TypeName, u128>,

        // guaranteedUsd tracks the amount of USD that is "guaranteed" by opened leverage positions
        // this value is used to calculate the redemption values for selling of USDG
        // this is an estimated amount, it is possible for the actual guaranteed value to be lower
        // in the case of sudden price decreases, the guaranteed value should be corrected
        // after liquidations are carried out
        guaranteedUsd: Table<TypeName, u128>,

        // cumulativeFundingRates tracks the funding rates based on utilization
        cumulativeFundingRates: Table<TypeName, u128>,
        // lastFundingTimes tracks the last time funding was updated for a token
        lastFundingTimes: Table<TypeName, u128>,
        // positions tracks all open positions
        positions: Table<address, Position>, //@todo review using address as bytes 32 mapping (bytes32 => Position) public positions;
        // feeReserves tracks the amount of fees per token
        feeReserves: Table<TypeName, u128>,
        globalShortSizes: Table<TypeName, u128>,
        globalShortAveragePrices: Table<TypeName, u128>,
        maxGlobalShortSizes: Table<TypeName, u128>,
        errors: Table<u128, vector<u8>>,
        usdb: Coin<USDB>,
    }

    public fun initialize(_adminCap: &AdminCap,
                          liquidationFeeUsd: u128,
                          fundingInterval: u128,
                          fundingRateFactor: u128,
                          stableFundingRateFactor: u128,
                          vault: &mut XVault,
                          _ctx: &mut TxContext){
    }

    ///
    /// Enable/disable swap
    ///
    public fun setIsSwapEnabled(_adminCap: &AdminCap,
                                isSwapEnabled: bool,
                                vault: &mut XVault,
                                _ctx: &mut TxContext){
        vault.config.isSwapEnabled = isSwapEnabled;
    }

    ///
    /// Enable/disable leverage
    ///
    public fun setIsLeverageEnabled(_adminCap: &AdminCap,
                                    isLeverageEnabled: bool,
                                    vault: &mut XVault,
                                    _ctx: &mut TxContext){
        vault.config.isLeverageEnabled = isLeverageEnabled;
    }

    ///
    /// Set max leverage
    ///
    public fun setMaxLeverage(_adminCap: &AdminCap,
                              maxLeverage: u128,
                              vault: &mut XVault){
        assert!(maxLeverage >= MIN_LEVERAGE);
        vault.config.maxLeverage = maxLeverage;
    }

    ///
    /// set max buffer amount
    ///
    public fun setBufferAmount<TOKEN>(_adminCap: &AdminCap,
                                      amount: u128,
                                      vault: &mut XVault){
    }

    ///
    /// Set max global sort size
    ///
    public fun setMaxGlobalShortSize<TOKEN>(_adminCap: &AdminCap,
                                            amount: u128,
                                            vault: &mut XVault,
                                            _ctx: &mut TxContext){
    }

    ///
    /// Set fees
    ///
    public fun setFees<TOKEN>(_adminCap: &AdminCap,
                              taxBasisPoints: u128,
                              stableTaxBasisPoints: u128,
                              mintBurnFeeBasisPoints: u128,
                              swapFeeBasisPoints: u128,
                              stableSwapFeeBasisPoints: u128,
                              liquidationFeeUsd: u128,
                              marginFeeBasisPoints: u128,
                              minProfitTime: u128,
                              hasDynamicFees: bool,
                              vault: &mut XVault,
                              _ctx: &mut TxContext){

    }

    ///
    /// Set funding rate separated from initialization
    ///
    ///
    /// Set fund rate config
    ///
    public fun setFundingRate<TOKEN>(_adminCap: &AdminCap,
                                     fundingInterval: u128,
                                     fundingRateFactor: u128,
                                     stableFundingRateFactor: u128,
                                     vault: &mut XVault,
                                     _ctx: &mut TxContext){
    }

    ///
    /// Set config of token
    ///
    public fun setTokenConfig<TOKEN>(_adminCap: &AdminCap,
                                     tokenDecimals: u128,
                                     tokenWeight: u128,
                                     minProfitBps: u128,
                                     maxUsdgAmount: u128,
                                     isStable: bool,
                                     isShortable: bool,
                                     vault: &mut XVault,
                                     _ctx: &mut TxContext){

    }

    ///
    /// clear config of tokens
    ///
    public fun clearTokenConfig<TOKEN>(_adminCap: &AdminCap,
                                       vault: &mut XVault,
                                       _ctx: &mut TxContext){
    }


    ///
    /// Withdraw fee
    ///
    public fun withdrawFees<TOKEN>(_adminCap: &AdminCap,
                                   receiver: address,
                                   vault: &mut XVault,
                                   ctx: &mut TxContext){
    }


    ///
    /// Set usdb amount of token
    ///
    public fun setUsdbAmount<TOKEN>(_adminCap: &AdminCap,
                                    amount: u128,
                                    vault: &mut XVault,
                                    _ctx: &mut TxContext){
    }


    ///
    /// Deposit into the pool without minting USDB tokens
    /// useful in allowing the pool to become over-collaterised
    /// - validate whitelisted
    /// - deposit to pool
    /// - dont mint debt usdb
    ///
    fun  directPoolDeposit<TOKEN>(token: Coin<TOKEN>,
                                  vault: &mut XVault,
                                  ctx: &mut TxContext){
    }

    ///
    ///Buy usdb using current token with price:
    /// - check token in whitelisted
    /// - transfer token to liquid pool
    /// - update cummulate funding rate
    /// - collect fee by token
    /// - mint more usdb debt with amount after fee
    ///
    public fun buyUsdb<TOKEN>(token: Coin<TOKEN>, vault: &mut XVault, _ctx: &mut TxContext): u256{
    };

    ///
    /// Sell usdb to retrieve back one token:
    /// - check token in whitelisted
    /// - update funding rate
    /// - compute redeemed token amount
    /// - decrease/burn usdb debt coin
    /// - decrease pool's token liquidity
    /// - collect fee by tokens
    /// - transfer out
    ///
    ///
    public fun sellUsdb<TOKEN>(usdbAmt: u64, vault: &mut XVault, _ctx: &mut TxContext): Coin<TOKEN>{
       coin::zero<TOKEN>(_ctx)
    }

    ///
    /// Swap token in to token out:
    /// - with token in for token out
    /// - check swap enabled, token in/out in whitelisted, not the same
    /// - update cummulative funding rate token in/out
    /// - transfer token in
    /// - load min/max price
    /// - collect fee
    /// - compute token out after fee
    /// - shift usdb debt from token in > token out: increase token in debg & decrease token out debt
    /// - update liquid pool reserves
    /// - return token out
    ///
    public fun swap<TOKEN_IN, TOKEN_OUT>(tokenIn: Coin<TOKEN_OUT>, vault: &mut XVault, _ctx: &mut TxContext): Coin<TOKEN_OUT>{
        coin::zero<TOKEN_OUT>(_ctx)
    }

    ///Increase one position or create new one:
    /// - deposit collateral token, index token, size in value(amount * price), long or short
    /// - create one position if not exist. Always netted
    /// - make sure leverage enabled
    /// - validate token pairs
    /// - update cummulate funding rate
    /// - load index price, load position
    /// - compute average entry index price with current vol/price
    /// - collect margin fee
    /// - transfer col token to liquid pool
    /// - update col amount ( = sigma(col_amt * price) after fee
    /// - set size
    /// - set entry funding rate
    /// - update reserve amount
    /// - if Long:
    ///     + update guaranteedUsd
    ///     + update pool reserve
    /// - if Short:
    ///     + update globalShortAveragePrices of index token
    ///     + increase globalShortSize of index token
    public fun increasePosition<COL_TOKEN, INDEX_TOKEN>(colToken: Coin<COL_TOKEN>, sizeDelta: u64, isLong: bool, vault: &mut XVault, ctx: &mut TxContext){

    }


    ///Decrease one position
    /// - update cummulate funding rate
    /// - check size, colDelta, sizeDelta
    /// - update reserve amount
    /// - reduce collateral:
    ///     + charge margin fee
    ///     + update pnl
    ///     + update pnl
    ///     + retrieve col + PNL
    ///     + update pool liquidity
    ///     + fire event Update pnl
    /// - update debt
    /// - transfer out
    public fun decreasePosition<COL_TOKEN, INDEX_TOKEN>(colToken: Coin<COL_TOKEN>, colSizeDelta: u64, sizeDelta: u64, isLong: bool, receiver: address, vault: &mut XVault, ctx: &mut TxContext){

    }


    ///
    /// Liquidate one postion:
    /// - trigger by liquidators
    /// - update cummulate funding rate
    /// - validate liquidation:
    ///     + compute pnl, position fee, funding fee
    /// - update reserve amount, pool amount
    /// - charge fee
    /// - transfer fee out
    ///
    public fun liquidatePosition<COL_TOKEN, INDEX_TOKEN>(_liquidatorCap: &LiquidatorCap, isLong: bool, feeReceiver: address,  vault: &mut XVault, ctx: &mut TxContext){

    }

    ///
    /// Utils functions
    ///
    public fun usdbBalance(vault: &XVault): u64{
        coin::value(&vault.usdb)
    }

    public fun mintUsdbDebt(vault: &mut XVault, more: Coin<USDB>){
        coin::join(&mut vault.usdb, more);
    }


    ///Internal functions
    fun validateManager(vault: &XVault, ctx: &mut TxContext) {

    }

    fun validateGasPrice(vault: &XVault, ctx: &mut TxContext) {
    }

    ///
    /// Collect swap fee:
    /// - cache reserve amount fee by tokens
    /// - return amount after fee
    ///
    fun collectSwapFees(token: TypeName, amount: u128, feeBasisPoints: u128, vault: &mut XVault): u128 {
    }

    ///
    /// Update current cummulate funding rate:
    /// - time to update ?
    /// - compute & add to cummulate fundate rate
    /// - update latest update time
    ///
    fun updateCumulativeFundingRate<COL_TOKEN, INDEX_TOKEN>(vault: &mut XVault){

    }

    ///
    /// validate position tokens:
    /// - if Long: index & col token must be same, whitelisted, not stable coin
    /// - if Short: col token must be stable coin, whitelisted. Index not a stable coin, in shortable list!
    ///
    fun validatePositionTokens<COL_TOKEN, INDEX_TOKEN>(isLong: bool ){

    }

    ///
    /// Retrieve max price
    ///
    fun getMaxPrice(type: TypeName,  vault: &XVault): u128{
        0u128
    }

    ///Retrieve min price
    fun getMinPrice(type: TypeName, vault: &XVault): u128{
        0u128
    }


    //@todo
    fun increaseUsdbAmount(token: TypeName, amount: u128, vault: &mut XVault, ctx: TxContext) {

    }

    //@todo
    fun decreaseUsdgAmount(token: TypeName, amount: u128, vault: &mut XVault, ctx: TxContext) {

    }

    fun initZeroTokenBalances0<TOKEN>(vault: &mut XVault, ctx: &mut TxContext){
    }

    fun increasePoolAmount<TOKEN>(token: Coin<TOKEN>, vault: &mut XVault, ctx: &mut TxContext){
    }

    fun decreasePoolAmount<TOKEN>(token: Coin<TOKEN>, vault: &mut XVault, ctx: &mut TxContext){
    }

    fun validateWhitelistedToken<TOKEN>(vault: &XVault){
    }

    fun transferIn<TOKEN>(token: Coin<TOKEN>, vault: &mut XVault){
    }

    fun adjustForDecimals(amount: u128 , tokenDiv: TypeName,  tokenMul: TypeName, vault: &XVault): u128 {
    }

    fun  tokenToUsdMin(token: TypeName, tokenAmount: u128, vault: &mut XVault): u128 {
    }
}
