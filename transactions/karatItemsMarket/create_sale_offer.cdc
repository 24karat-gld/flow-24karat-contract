import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import Karat from "../../contracts/Karat.cdc"
import KaratItems from "../../contracts/KaratItems.cdc"
import KaratItemsMarket from "../../contracts/KaratItemsMarket.cdc"

transaction(itemID: UInt64, price: UFix64) {
    let karatVault: Capability<&Karat.Vault{FungibleToken.Receiver}>
    let karatItemsCollection: Capability<&KaratItems.Collection{NonFungibleToken.Provider, KaratItems.KaratItemsCollectionPublic}>
    let marketCollection: &KaratItemsMarket.Collection

    prepare(signer: AuthAccount) {
        // we need a provider capability, but one is not provided by default so we create one.
        let KaratItemsCollectionProviderPrivatePath = /private/karatItemsCollectionProvider

        self.karatVault = signer.getCapability<&Karat.Vault{FungibleToken.Receiver}>(Karat.ReceiverPublicPath)!
        assert(self.karatVault.borrow() != nil, message: "Missing or mis-typed Karat receiver")

        if !signer.getCapability<&KaratItems.Collection{NonFungibleToken.Provider, KaratItems.KaratItemsCollectionPublic}>(KaratItemsCollectionProviderPrivatePath)!.check() {
            signer.link<&KaratItems.Collection{NonFungibleToken.Provider, KaratItems.KaratItemsCollectionPublic}>(KaratItemsCollectionProviderPrivatePath, target: KaratItems.CollectionStoragePath)
        }

        self.karatItemsCollection = signer.getCapability<&KaratItems.Collection{NonFungibleToken.Provider, KaratItems.KaratItemsCollectionPublic}>(KaratItemsCollectionProviderPrivatePath)!
        assert(self.karatItemsCollection.borrow() != nil, message: "Missing or mis-typed KaratItemsCollection provider")

        self.marketCollection = signer.borrow<&KaratItemsMarket.Collection>(from: KaratItemsMarket.CollectionStoragePath)
            ?? panic("Missing or mis-typed KaratItemsMarket Collection")
    }

    execute {
        let offer <- KaratItemsMarket.createSaleOffer (
            sellerItemProvider: self.karatItemsCollection,
            itemID: itemID,
            typeID: self.karatItemsCollection.borrow()!.borrowKaratItem(id: itemID)!.typeID,
            sellerPaymentReceiver: self.karatVault,
            price: price
        )
        self.marketCollection.insert(offer: <-offer)
    }
}
