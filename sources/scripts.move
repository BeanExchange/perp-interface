module bean::scripts {
    use bean::vault::{XVault, AdminCap};
    use sui::tx_context::TxContext;
    use sui::coin::Coin;
    use bean::blp_manager::BlpManagerReg;
    use sui::clock::Clock;
    use bean::blp::BLP;

    ///
    /// Config parts
    ///
    public entry fun initialize(_adminCap: &AdminCap,
                                liquidationFeeUsd: u128,
                                fundingInterval: u128,
                                fundingRateFactor: u128,
                                stableFundingRateFactor: u128,
                                vault: &mut XVault,
                                _ctx: &mut TxContext){

    }

    public entry fun setSwapEnabled(_adminCap: &AdminCap,
                                    isSwapEnabled: bool,
                                    vault: &mut XVault,
                                    _ctx: &mut TxContext){

    }

    public entry fun setLeverageEnabled(_adminCap: &AdminCap,
                                        isLeverageEnabled: bool,
                                        vault: &mut XVault,
                                        _ctx: &mut TxContext){

    }

    public entry fun setMaxLeverage(_adminCap: &AdminCap,
                                    maxLeverage: u128,
                                    vault: &mut XVault){

    }

    public fun setBufferAmount<TOKEN>(_adminCap: &AdminCap,
                                      amount: u128,
                                      vault: &mut XVault){

    }

    public fun setMaxGlobalShortSize<TOKEN>(_adminCap: &AdminCap,
                                            amount: u128,
                                            vault: &mut XVault,
                                            _ctx: &mut TxContext){

    }

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

    public fun setFundingRate<TOKEN>(_adminCap: &AdminCap,
                                     fundingInterval: u128,
                                     fundingRateFactor: u128,
                                     stableFundingRateFactor: u128,
                                     vault: &mut XVault,
                                     _ctx: &mut TxContext){

    }

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

    public fun clearTokenConfig<TOKEN>(_adminCap: &AdminCap,
                                       vault: &mut XVault,
                                       _ctx: &mut TxContext){

    }

    ///
    ///LP parts
    ///
    public entry fun addLiquidity<TOKEN>(token: Coin<TOKEN>,
                                         minUsdb: u128,
                                         minGlp: u128,
                                         blpRegistry: &mut BlpManagerReg,
                                         vault: &mut XVault,
                                         sclock: &Clock,
                                         ctx: &mut TxContext){

    }

    public entry fun removeLiquidity<TOKEN>(blpToken: Coin<BLP>,
                                            minTokenOut: u128,
                                            registry: &mut BlpManagerReg,
                                            xvault: &mut XVault,
                                            sclock: &Clock,
                                            ctx: &mut TxContext){

    }

    ///
    /// Trading part
    ///

    ///
    /// Not only tokens, also support buy/sell USDB
    ///
    public fun swap1<TOKEN1, TOKEN2>(tokenIn: Coin<TOKEN1>, minOut: u128, receiver: address, vault: &mut XVault, ctx: &mut TxContext){
    }

    ///
    /// Not only tokens, also support buy/sell USDB
    ///
    ///
    public fun swap2<TOKEN1, TOKEN2, TOKEN3>(tokenIn: Coin<TOKEN1>, minOut: u128, receiver: address, vault: &mut XVault, ctx: &mut TxContext){
    }

    ///
    ///Perp part
    ///
    public fun increasePosition1<COL_TOKEN, INDEX_TOKEN>(tokenIn: Coin<COL_TOKEN>, minOut: u128 , sizeDelta: u128, isLong: bool, limitPrice: u128, vault: &mut XVault, ctx: &mut TxContext){

    }

    public fun increasePosition2<COL_TOKEN, COL_TOKEN2, INDEX_TOKEN>(tokenIn: Coin<COL_TOKEN>, minOut: u128 , sizeDelta: u128, isLong: bool, limitPrice: u128, vault: &mut XVault, ctx: &mut TxContext){

    }

    public fun decreasePosition<COL_TOKEN, INDEX_TOKEN>(colDelta: u128, sizeDelta: u128 , isLong: bool, receiver: address, limitPrice: u128, vault: &mut XVault, ctx: &mut TxContext){

    }

    ///
    /// Vault part
    ///
    public fun withdrawFees<TOKEN>(_adminCap: &AdminCap,
                                   receiver: address,
                                   vault: &mut XVault,
                                   ctx: &mut TxContext){

    }

    fun  directPoolDeposit<TOKEN>(token: Coin<TOKEN>,
                                  vault: &mut XVault,
                                  ctx: &mut TxContext){

    }
}
