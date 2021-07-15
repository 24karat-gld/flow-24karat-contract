import Karat from "../../contracts/Karat.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"

// This script returns an account's Karat balance.

pub fun main(address: Address): UFix64 {
    let account = getAccount(address)
    
    let vaultRef = account.getCapability(Karat.BalancePublicPath)!.borrow<&Karat.Vault{FungibleToken.Balance}>()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}
