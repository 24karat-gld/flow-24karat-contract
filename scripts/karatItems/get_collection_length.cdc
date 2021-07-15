import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import KaratItems from "../../contracts/KaratItems.cdc"

// This script returns the size of an account's KaratItems collection.

pub fun main(address: Address): Int {
    let account = getAccount(address)

    let collectionRef = account.getCapability(KaratItems.CollectionPublicPath)!
        .borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")
    
    return collectionRef.getIDs().length
}
