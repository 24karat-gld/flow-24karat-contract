import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import KaratNFT from "../../contracts/KaratNFT.cdc"

// This transaction gets the length of an account's nft collection
pub fun main(account: Address): Int {
    let collectionRef = getAccount(account)
        .getCapability(KaratNFT.CollectionPublicPath)
        .borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    return collectionRef.getIDs().length
}