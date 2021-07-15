import KaratItemsMarket from "../../contracts/KaratItemsMarket.cdc"

transaction(itemID: UInt64) {
    let marketCollection: &KaratItemsMarket.Collection

    prepare(signer: AuthAccount) {
        self.marketCollection = signer.borrow<&KaratItemsMarket.Collection>(from: KaratItemsMarket.CollectionStoragePath)
            ?? panic("Missing or mis-typed KaratItemsMarket Collection")
    }

    execute {
        let offer <-self.marketCollection.remove(itemID: itemID)
        destroy offer
    }
}
