module bean::order_book {
    use std::type_name::TypeName;
    use sui::object::UID;
    use sui::table::Table;
    use sui::tx_context::TxContext;
    use bean::vault::{AdminCap, OrderKeeperCap, XVault};
    use sui::coin::Coin;

    const PRICE_PRECISION: u128 = 10 ^ 30; //10 ** 30
    const USDB_PRECISION: u128 = 10 ^ 18; //10 ** 18

    struct ORDER_BOOK has drop {}

    struct IncreaseOrder has copy, drop {
        account: address,
        purchaseToken: TypeName,
        purchaseTokenAmount: u128,
        collateralToken: TypeName,
        indexToken: TypeName,
        sizeDelta: u128,
        isLong: bool,
        triggerPrice: u128,
        triggerAboveThreshold: bool,
        executionFee: u128
    }

    struct DecreaseOrder has copy, drop {
        account: address,
        collateralToken: TypeName,
        collateralDelta: u128,
        indexToken: TypeName,
        sizeDelta: u128,
        isLong: bool,
        triggerPrice: u128,
        triggerAboveThreshold: bool,
        executionFee: u128
    }

    struct SwapOrder has copy, drop {
        account: address,
        path: vector<TypeName>,
        amountIn: u128,
        minOut: u128,
        triggerRatio: u128,
        triggerAboveThreshold: bool,
        shouldUnwrap: bool,
        executionFee: u128
    }

    struct CreateIncreaseOrderEvent has copy, drop {
        account: address,
        orderIndex: u128,
        purchaseToken: TypeName,
        purchaseTokenAmount: u128,
        collateralToken: TypeName,
        indexToken: TypeName,
        sizeDelta: u128,
        isLong: bool,
        triggerPrice: u128,
        triggerAboveThreshold: bool,
        executionFee: u128
    }

    struct CancelIncreaseOrderEvent has copy, drop {
        account: address,
        orderIndex: u128,
        purchaseToken: TypeName,
        purchaseTokenAmount: u128,
        collateralToken: TypeName,
        indexToken: TypeName,
        sizeDelta: u128,
        isLong: bool,
        triggerPrice: u128,
        triggerAboveThreshold: bool,
        executionFee: u128
    }

    struct ExecuteIncreaseOrderEvent has copy, drop {
        account: address,
        orderIndex: u128,
        purchaseToken: TypeName,
        purchaseTokenAmount: u128,
        collateralToken: TypeName,
        indexToken: TypeName,
        sizeDelta: u128,
        isLong: bool,
        triggerPrice: u128,
        triggerAboveThreshold: bool,
        executionFee: u128
    }

    struct UpdateIncreaseOrderEvent has copy, drop {
        account: address,
        orderIndex: u128,
        collateralToken: TypeName,
        indexToken: TypeName,
        sizeDelta: u128,
        isLong: bool,
        triggerPrice: u128,
        triggerAboveThreshold: bool,
        executionFee: u128
    }

    struct CreateDecreaseOrderEvent has copy, drop {
        account: address,
        orderIndex: u128,
        collateralToken: TypeName,
        collateralDelta: u128,
        indexToken: TypeName,
        sizeDelta: u128,
        isLong: bool,
        triggerPrice: u128,
        triggerAboveThreshold: bool,
        executionFee: u128
    }


    struct CancelDecreaseOrderEvent has copy, drop {
        account: address,
        orderIndex: u128,
        collateralToken: TypeName,
        collateralDelta: u128,
        indexToken: TypeName,
        sizeDelta: u128,
        isLong: bool,
        triggerPrice: u128,
        triggerAboveThreshold: bool,
        executionFee: u128
    }

    struct ExecuteDecreaseOrderEvent has copy, drop {
        account: address,
        orderIndex: u128,
        collateralToken: TypeName,
        collateralDelta: u128,
        indexToken: TypeName,
        sizeDelta: u128,
        isLong: bool,
        triggerPrice: u128,
        triggerAboveThreshold: bool,
        executionFee: u128,
        executionPrice: u128,
    }


    struct UpdateDecreaseOrderEvent has copy, drop {
        account: address,
        orderIndex: u128,
        collateralToken: TypeName,
        collateralDelta: u128,
        indexToken: TypeName,
        sizeDelta: u128,
        isLong: bool,
        triggerPrice: u128,
        triggerAboveThreshold: bool,
    }

    struct CreateSwapOrderEvent has copy, drop {
        account: address,
        orderIndex: u128,
        path: vector<TypeName>,
        amountIn: u128,
        minOut: u128,
        triggerRatio: u128,
        triggerAboveThreshold: bool,
        shouldUnwrap: bool,
        executionFee: u128,
    }

    struct CancelSwapOrderEvent has copy, drop {
        account: address,
        orderIndex: u128,
        path: vector<TypeName>,
        amountIn: u128,
        minOut: u128,
        triggerRatio: u128,
        triggerAboveThreshold: bool,
        shouldUnwrap: bool,
        executionFee: u128,
    }

    struct UpdateSwapOrderEvent has copy, drop {
        account: address,
        orderIndex: u128,
        path: vector<TypeName>,
        amountIn: u128,
        minOut: u128,
        triggerRatio: u128,
        triggerAboveThreshold: bool,
        shouldUnwrap: bool,
        executionFee: u128,
    }

    struct ExecuteSwapOrderEvent has copy, drop {
        account: address,
        orderIndex: u128,
        path: vector<TypeName>,
        amountIn: u128,
        amountOut: u128,
        triggerRatio: u128,
        triggerAboveThreshold: bool,
        shouldUnwrap: bool,
        executionFee: u128,
    }


    struct OrderBook has key, store {
        id: UID,
        increaseOrders: Table<address, Table<u128, IncreaseOrder>>,
        decreaseOrders: Table<address, Table<u128, DecreaseOrder>>,
        swapOrders: Table<address, Table<u128, SwapOrder>>,
        increaseOrdersIndex: Table<address, u128>,
        decreaseOrdersIndex: Table<address, u128>,
        swapOrdersIndex: Table<address, u128>,
        isInitialized: bool,
        minPurchaseTokenAmountUsd: u128,
        minExecutionFee: u128
    }

    fun init(_witness: ORDER_BOOK, ctx: &mut TxContext) {
    }

    ///
    /// Initialze config, can be executed multiple times
    ///
    public fun initialize(_adminCap: &AdminCap,
                    _minExecutionFee: u64,
                    _minPurchaseTokenAmountUsd: u64,
                    _orderBook: &mut OrderBook,
                    _ctx: &mut TxContext){

    }

    ///
    /// Config
    ///
    public fun setMinExecutionFee(_adminCap: &AdminCap,
                                  _minExecutionFee: u64,
                                  _orderBook: &mut OrderBook,
                                  _ctx: &mut TxContext){

    }

    ///
    /// Config
    ///
    public fun setMinPurchaseTokenAmountUsd(_adminCap: &AdminCap,
                                            _minPurchaseTokenAmountUsd: u64,
                                            _orderBook: &mut OrderBook,
                                            _ctx: &mut TxContext){

    }

    ///
    /// User create their own limit order
    ///
    public fun createSwapOrder1<TOKEN_IN, TOKEN_OUT>(_amountIn: Coin<TOKEN_IN>,
                                                    _minOut: u64,
                                                    _triggerRatio: u64,
                                                    _triggerAboveThreshold: bool,
                                                    _executionFee: u64,
                                                    _orderBook: &mut OrderBook,
                                                    _ctx: &mut TxContext){

    }

    ///
    /// User create their own limit orders
    ///
    public fun createSwapOrder2<TOKEN1, TOKEN12, TOKEN3>(_amountIn: Coin<TOKEN1>,
                                                     _minOut: u64,
                                                     _triggerRatio: u64,
                                                     _triggerAboveThreshold: bool,
                                                     _executionFee: u64,
                                                     _orderBook: &mut OrderBook,
                                                     _ctx: &mut TxContext){

    }

    ///
    /// User create their own limit order
    ///
    public fun cancelSwapOrder(_orderIndex: u128,
                               _orderBook: &mut OrderBook,
                               _ctx: &mut TxContext){

    }

    ///
    /// User create their own limit orders
    ///
    public fun cancelMultiple(_swapOrderIndexes: vector<u128>,
                              _increaseOrderIndexes: vector<u128>,
                              _decreaseOrderIndexes: vector<u128>,
                              _orderBook: &mut OrderBook,
                              _ctx: &mut TxContext){

    }

    ///
    /// User create their own limit orders
    ///
    public fun updateSwapOrder(_orderIndex: u128,
                               _minOut: u128,
                               _triggerRatio: u128,
                               _triggerAboveThreshold: bool,
                               _orderBook: &mut OrderBook,
                               _ctx: &mut TxContext){

    }


    ///
    /// Keeper trigger limit order
    ///
    public fun executeSwapOrder(_orderKeeperCap: &OrderKeeperCap,
                                _account: address,
                                _orderIndex: u128,
                                _feeReceiver: address,
                                _orderBook: &mut OrderBook,
                                _vault: &mut XVault,
                                _ctx: &mut TxContext){

    }

    ///
    /// User increase position:
    /// - create new/increase one position with COL_TOKEN
    ///
    public fun createIncreasePosition1<COL_TOKEN, INDEX_TOKEN>(_inputToken: Coin<COL_TOKEN>,
                                                         _sizeDelta: u128,
                                                         _isLong: u128,
                                                         _triggerPrice: u128,
                                                         _triggerAboveThreshold: bool,
                                                         _executionFee: u128,
                                                         _orderBook: &mut OrderBook,
                                                         _ctx: &mut TxContext){

    }

    ///
    /// User increase position:
    /// - create new /increase one position with INPUT_TOKEN
    /// - when position is anchored, INPUT_TOKEN will be swap to COL_TOKEN
    ///
    public fun createIncreasePosition2<INPUT_TOKEN, COL_TOKEN, INDEX_TOKEN>(_inputToken: Coin<INPUT_TOKEN>,
                                                                            _minOut: u128,
                                                                             _sizeDelta: u128,
                                                                             _isLong: u128,
                                                                             _triggerPrice: u128,
                                                                             _triggerAboveThreshold: bool,
                                                                             _executionFee: u128,
                                                                             _orderBook: &mut OrderBook,
                                                                             _ctx: &mut TxContext){

    }

    ///
    /// User update their order
    ///
    public fun updateIncreasePosition(_orderIndex: u128,
                                      _sizeDelta: u128,
                                      _triggerPrice: u128,
                                      _triggerAboveThreshold: bool,
                                      _orderBook: &mut OrderBook,
                                      _ctx: &mut TxContext){

    }


    ///
    /// User cancel their position
    ///
    public fun cancelIncreasePosition(_orderIndex: u128,
                                      _orderBook: &mut OrderBook,
                                      _ctx: &mut TxContext){

    }

    ///
    ///Keeper exec order for user
    ///
    public fun executeIncreasePosition(_keeperCap: &OrderKeeperCap,
                                       _forAccount: address,
                                       _orderIndex: u128,
                                       _feeReceiver: address,
                                       _orderBook: &mut OrderBook,
                                        _vault: &mut XVault,
                                       _ctx: &mut TxContext){

    }


    ///
    /// User create decrease position:
    /// - create/increase one position with INPUT_TOKEN
    /// - when position is anchored, INPUT_TOKEN will be swap to COL_TOKEN
    ///
    public fun createDecreasePosition1<COL_TOKEN, INDEX_TOKEN>(_sizeDelta: u128,
                                                               _collateralDelta: u128,
                                                               _isLong: u128,
                                                               _triggerPrice: u128,
                                                               _triggerAboveThreshold: bool,
                                                               _orderBook: &mut OrderBook,
                                                               _ctx: &mut TxContext){

    }

    ///
    /// Keeper execute order for account
    ///
    public fun executeDecreasePosition<COL_TOKEN, INDEX_TOKEN>(_keeperCap: &OrderKeeperCap,
                                                               _forAccount: address,
                                                               _orderIndex: u128,
                                                               _feeReceiver: address,
                                                               _orderBook: &mut OrderBook,
                                                                _vault: &XVault,
                                                               _ctx: &mut TxContext){

    }

    ///
    /// User cancel their decrease order
    ///
    public fun cancelDecreaseOrder(_orderIndex: u128,
                                   _orderBook: &mut OrderBook,
                                   _ctx: &mut TxContext){

    }

    ///
    /// User update their decrease order
    ///
    public fun updateDecreaseOrder(_orderIndex: u128,
                                   _collateralDelta: u128,
                                   _sizeDelta: u128,
                                   _triggerPrice: u128,
                                   _triggerAboveThreshold: bool,
                                   _orderBook: &mut OrderBook,
                                   _ctx: &mut TxContext){

    }
}
