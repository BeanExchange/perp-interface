module bean::position_manager {
    use sui::tx_context::TxContext;
    use sui::object::UID;
    use sui::table::Table;
    use std::type_name::TypeName;
    use bean::vault::{AdminCap, OrderKeeperCap, XVault, PartnerCap};
    use sui::coin;
    use sui::coin::Coin;

    const BASIS_POINTS_DIVISOR: u128 = 1000;

    struct POSITION_MANAGER has drop {}


    struct PositionRegistry has key, store {
        id: UID,
        suiTransferGasLimit: u128, // = 500 * 1000;
        depositFee: u128,
        increasePositionBufferBps: u128, // =100
        referralStorage: address,
        feeReserves: Table<TypeName, u128>,
        maxGlobalLongSizes: Table<TypeName, u128>,
        maxGlobalShortSizes: Table<TypeName, u128>,
    }

    fun init(_witness: POSITION_MANAGER, ctx: &mut TxContext) {

    }


    public fun initialize(_adminCap: &AdminCap,
                          _depositFee: u128,
                          _positionReg: &mut PositionRegistry,
                          _ctx: &mut TxContext){

    }

    public fun setSuiTransferGasLimit(_adminCap: &AdminCap,
                                      _suiTransferGasLimit: u128,
                                      _positionReg: &mut PositionRegistry,
                                      _ctx: &mut TxContext){

    }

    public fun setDepositFee(_adminCap: &AdminCap,
                             _depositFee: u128,
                             _positionReg: &mut PositionRegistry,
                             _ctx: &mut TxContext){

    }

    public fun setIncreasePositionBufferBps(_adminCap: &AdminCap,
                                            _increasePositionBufferBps: u128,
                                            _positionReg: &mut PositionRegistry,
                                            _ctx: &mut TxContext){

    }

    public fun setReferralStorage(_adminCap: &AdminCap,
                                  _referralStorage: address,
                                  _positionReg: &mut PositionRegistry,
                                  _ctx: &mut TxContext){

    }


    public fun setMaxGlobalSizes<TOKEN>(_adminCap: &AdminCap,
                                        _longSize: u128,
                                        _shortSize: u128,
                                        _positionReg: &mut PositionRegistry,
                                        _vault: &mut XVault,
                                        _ctx: &mut TxContext){

    }

    public entry fun withdrawFees<TOKEN>(_adminCap: &AdminCap,
                                   _receiver: address,
                                   _positionReg: &mut PositionRegistry,
                                   _ctx: &mut TxContext){

    }

    ///
    /// Create market Position
    ///
    public entry fun increasePosition1<COL_TOKEN, INDEX_TOKEN>(_partnerCap: &PartnerCap,
                                                         _amountIn: Coin<COL_TOKEN>,
                                                        _sizeDelta: u128,
                                                        _isLong: bool,
                                                        _price: u128,
                                                        _positionReg: &mut PositionRegistry,
                                                        _vault: &mut XVault,
                                                        _ctx: &mut TxContext){

    }

    ///
    /// Create market Position
    ///
    public entry fun increasePosition2<TOKEN_IN, COL_TOKEN, INDEX_TOKEN>(_partnerCap: &PartnerCap,
                                                                   _amountIn: Coin<TOKEN_IN>,
                                                                   _minOut: u128,
                                                                   _sizeDelta: u128,
                                                                    _isLong: bool,
                                                                    _price: u128,
                                                                    _positionReg: &mut PositionRegistry,
                                                                    _vault: &mut XVault,
                                                                    _ctx: &mut TxContext){

    }
    ///
    /// Create market Position
    ///
    public entry fun decreasePosition<COL_TOKEN, INDEX_TOKEN>(_partnerCap: &PartnerCap,
                                                        _colateralIn: Coin<COL_TOKEN>,
                                                        _collateralDelta: u128,
                                                        _sizeDelta: u128,
                                                        _isLong: bool,
                                                        _receiver: address,
                                                        _price: u128,
                                                        _positionReg: &mut PositionRegistry,
                                                        _vault: &mut XVault,
                                                        _ctx: &mut TxContext){

    }
}
