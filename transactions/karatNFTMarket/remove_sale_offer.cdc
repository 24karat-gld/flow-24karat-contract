import KaratNFTMarket from "../../contracts/KaratNFTMarket.cdc"

transaction(itemID: UInt64) {
    let marketCollection: &KaratNFTMarket.Collection

    prepare(signer: AuthAccount) {
        self.marketCollection = signer.borrow<&KaratNFTMarket.Collection>(from: KaratNFTMarket.CollectionStoragePath)
            ?? panic("Missing or mis-typed KaratNFTMarket Collection")
    }

    execute {
        let offer <-self.marketCollection.remove(itemID: itemID)
        destroy offer
    }
}
