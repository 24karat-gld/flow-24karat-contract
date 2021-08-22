import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import KaratNFT from "../../contracts/KaratNFT.cdc"

// This script reads metadata about an NFT in a user's collection
pub fun main(account: Address, itemID: UInt64): {String:String} {

    let owner = getAccount(account)

    let collection = owner.getCapability(KaratNFT.CollectionPublicPath)!
        .borrow<&{KaratNFT.KaratNFTCollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    // Borrow a reference to a specific NFT in the collection
    let nft = collection.borrowKaratNFT(id: itemID) ?? panic("No such itemID in that collection")

    return nft.metadata
}