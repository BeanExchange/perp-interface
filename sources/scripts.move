module bean::scripts {
    use bean::vault::{AdminCap, XVault, OrderKeeperCap};
    use sui::tx_context::TxContext;
    use sui::coin::Coin;
    use bean::blp_manager::BlpManagerReg;
    use sui::clock::Clock;
    use bean::blp::BLP;

    ///
    /// Not only tokens, also support buy/sell USDB
    ///
    public entry fun swap1<TOKEN1, TOKEN2>(tokenIn: Coin<TOKEN1>, minOut: u128, receiver: address, vault: &mut XVault, ctx: &mut TxContext){
    }

    ///
    /// Not only tokens, also support buy/sell USDB
    ///
    ///
    public entry fun swap2<TOKEN1, TOKEN2, TOKEN3>(tokenIn: Coin<TOKEN1>, minOut: u128, receiver: address, vault: &mut XVault, ctx: &mut TxContext){
    }

    ///
    ///Perp part
    ///
    public entry fun increasePosition1<COL_TOKEN, INDEX_TOKEN>(tokenIn: Coin<COL_TOKEN>, minOut: u128 , sizeDelta: u128, isLong: bool, limitPrice: u128, vault: &mut XVault, ctx: &mut TxContext){

    }

    public entry fun increasePosition2<COL_TOKEN, COL_TOKEN2, INDEX_TOKEN>(tokenIn: Coin<COL_TOKEN>, minOut: u128 , sizeDelta: u128, isLong: bool, limitPrice: u128, vault: &mut XVault, ctx: &mut TxContext){

    }

    public entry fun decreasePosition<COL_TOKEN, INDEX_TOKEN>(colDelta: u128, sizeDelta: u128 , isLong: bool, receiver: address, limitPrice: u128, vault: &mut XVault, ctx: &mut TxContext){

    }

    public entry fun decreasePositionAndSwap<COL_TOKEN, OUT_TOKEN, INDEX_TOKEN>(colDelta: u128, sizeDelta: u128 , isLong: bool, receiver: address, limitPrice: u128, minOut: u128, vault: &mut XVault, ctx: &mut TxContext){

    }

    ///
    /// Order keeper try to liquidate one position
    /// @todo meaning of feeReceiver ?
    /// - based on liquidationFeeUsd
    /// - payout with token amount, so should divided by price to get token amount
    ///
    public entry fun liquidatePosition<COL_TOKEN, INDEX_TOKEN>(_keeperCap: &OrderKeeperCap, account: u128 , isLong: bool, feeReceiver: address, vault: &mut XVault, ctx: &mut TxContext){

    }
}
