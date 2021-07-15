import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import KaratItems from "../../contracts/KaratItems.cdc"

// This script returns the metadata for an NFT in an account's collection.

pub fun main(address: Address, itemID: UInt64): UInt64 {

    // get the public account object for the token owner
    let owner = getAccount(address)

    let collectionBorrow = owner.getCapability(KaratItems.CollectionPublicPath)!
        .borrow<&{KaratItems.KaratItemsCollectionPublic}>()
        ?? panic("Could not borrow KaratItemsCollectionPublic")

    // borrow a reference to a specific NFT in the collection
    let karatItem = collectionBorrow.borrowKaratItem(id: itemID)
        ?? panic("No such itemID in that collection")

    return karatItem.typeID
}
