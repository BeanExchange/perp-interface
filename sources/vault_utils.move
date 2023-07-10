module bean::vault_utils {
    use bean::vault::XVault;
    use std::type_name::TypeName;
    friend bean::vault;

    //@todo later
     public fun getBuyUsdbFeeBasisPoints(token: TypeName, usdgAmount: u128 , vault: &mut XVault): u128{
        0u128
    }
}
