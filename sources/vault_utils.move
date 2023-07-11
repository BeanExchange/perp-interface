module bean::vault_utils {
    use bean::vault::XVault;
    use std::type_name::TypeName;
    use bean::i128::I128;
    friend bean::vault;

    struct Position has drop, copy {
        size: u128,
        collateral: u128,
        averagePrice: u128,
        entryFundingRate: u128,
        reserveAmount: u128,
        realisedPnl: I128,
        lastIncreasedTime: u128
    }

     public fun getBuyUsdbFeeBasisPoints(token: TypeName, usdgAmount: u128 , vault: &mut XVault): u128{
        0u128
     }

    public fun getSellUsdbFeeBasisPoints(token: TypeName, usdgAmount: u128 , vault: &mut XVault): u128{
        0u128
    }

    public fun validateLiquidation<COL_TOKEN, INDEX_TOKEN>(account: address, isLong: bool, raiseErr: bool , vault: &mut XVault): (u128, u128){

    }
}
