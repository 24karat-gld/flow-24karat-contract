import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import KaratItems from "../../contracts/KaratItems.cdc"

// This transaction configures an account to hold Karat Items.

transaction {
    prepare(signer: AuthAccount) {
        // if the account doesn't already have a collection
        if signer.borrow<&KaratItems.Collection>(from: KaratItems.CollectionStoragePath) == nil {

            // create a new empty collection
            let collection <- KaratItems.createEmptyCollection()
            
            // save it to the account
            signer.save(<-collection, to: KaratItems.CollectionStoragePath)

            // create a public capability for the collection
            signer.link<&KaratItems.Collection{NonFungibleToken.CollectionPublic, KaratItems.KaratItemsCollectionPublic}>(KaratItems.CollectionPublicPath, target: KaratItems.CollectionStoragePath)
        }
    }
}
