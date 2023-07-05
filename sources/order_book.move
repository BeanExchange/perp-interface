module bean::order_book {
    use std::type_name::TypeName;
    use sui::object::UID;
    use sui::table::Table;
    use sui::tx_context::TxContext;
    use sui::transfer::share_object;
    use sui::object;
    use bean::vault::AdminCap;

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

    public fun initialize(_adminCap: &AdminCap,
                          _minExecutionFee: u64,
                          _minPurchaseTokenAmountUsd: u64,
                          _orderBook: &mut OrderBook,
                          _ctx: &mut TxContext){

    }
}
