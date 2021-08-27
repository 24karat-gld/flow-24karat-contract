import KaratNFTMarket from "../../contracts/KaratNFTMarket.cdc"

// This transaction configures an account to hold SaleOffer items.

transaction {
    prepare(signer: AuthAccount) {

        // if the account doesn't already have a collection
        if signer.borrow<&KaratNFTMarket.Collection>(from: KaratNFTMarket.CollectionStoragePath) == nil {

            // create a new empty collection
            let collection <- KaratNFTMarket.createEmptyCollection() as! @KaratNFTMarket.Collection
            
            // save it to the account
            signer.save(<-collection, to: KaratNFTMarket.CollectionStoragePath)

            // create a public capability for the collection
            signer.link<&KaratNFTMarket.Collection{KaratNFTMarket.CollectionPublic}>(KaratNFTMarket.CollectionPublicPath, target: KaratNFTMarket.CollectionStoragePath)
        }
    }
}
