import KaratItemsMarket from "../../contracts/KaratItemsMarket.cdc"

// This script returns the size of an account's SaleOffer collection.

pub fun main(account: Address, marketCollectionAddress: Address): Int {
    let acct = getAccount(account)
    let marketCollectionRef = getAccount(marketCollectionAddress)
        .getCapability<&KaratItemsMarket.Collection{KaratItemsMarket.CollectionPublic}>(
             KaratItemsMarket.CollectionPublicPath
        )
        .borrow()
        ?? panic("Could not borrow market collection from market address")
    
    return marketCollectionRef.getSaleOfferIDs().length
}
