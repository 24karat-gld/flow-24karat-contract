import KaratItemsMarket from "../../contracts/KaratItemsMarket.cdc"

// This transaction configures an account to hold SaleOffer items.

transaction {
    prepare(signer: AuthAccount) {

        // if the account doesn't already have a collection
        if signer.borrow<&KaratItemsMarket.Collection>(from: KaratItemsMarket.CollectionStoragePath) == nil {

            // create a new empty collection
            let collection <- KaratItemsMarket.createEmptyCollection() as! @KaratItemsMarket.Collection
            
            // save it to the account
            signer.save(<-collection, to: KaratItemsMarket.CollectionStoragePath)

            // create a public capability for the collection
            signer.link<&KaratItemsMarket.Collection{KaratItemsMarket.CollectionPublic}>(KaratItemsMarket.CollectionPublicPath, target: KaratItemsMarket.CollectionStoragePath)
        }
    }
}
