import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import KaratNFT from "../../contracts/KaratNFT.cdc"

// This transaction is what an account would run
// to set itself up to receive NFTs
transaction {

    prepare(acct: AuthAccount) {

        // Return early if the account already has a collection
        if acct.borrow<&KaratNFT.Collection>(from: KaratNFT.CollectionStoragePath) != nil {
            return
        }

        // Create a new empty collection
        let collection <- KaratNFT.createEmptyCollection()

        // save it to the account
        acct.save(<-collection, to: KaratNFT.CollectionStoragePath)

        // create a public capability for the collection
        acct.link<&KaratNFT.Collection{NonFungibleToken.CollectionPublic, KaratNFT.KaratNFTCollectionPublic}>(KaratNFT.CollectionPublicPath, target: KaratNFT.CollectionStoragePath)
    }
}
 