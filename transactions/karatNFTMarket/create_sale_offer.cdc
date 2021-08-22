import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import Karat from "../../contracts/Karat.cdc"
import KaratNFT from "../../contracts/KaratNFT.cdc"
import KaratNFTMarket from "../../contracts/KaratNFTMarket.cdc"

transaction(itemID: UInt64, price: UFix64) {
    let karatVault: Capability<&Karat.Vault{FungibleToken.Receiver}>
    let karatNFTCollection: Capability<&KaratNFT.Collection{NonFungibleToken.Provider, KaratNFT.KaratNFTCollectionPublic}>
    let marketCollection: &KaratNFTMarket.Collection

    prepare(signer: AuthAccount) {
        // we need a provider capability, but one is not provided by default so we create one.
        let KaratNFTCollectionProviderPrivatePath = /private/karatNFTCollectionProvider

        self.karatVault = signer.getCapability<&Karat.Vault{FungibleToken.Receiver}>(Karat.ReceiverPublicPath)!
        assert(self.karatVault.borrow() != nil, message: "Missing or mis-typed Karat receiver")

        if !signer.getCapability<&KaratNFT.Collection{NonFungibleToken.Provider, KaratNFT.KaratNFTCollectionPublic}>(KaratNFTCollectionProviderPrivatePath)!.check() {
            signer.link<&KaratNFT.Collection{NonFungibleToken.Provider, KaratNFT.KaratNFTCollectionPublic}>(KaratNFTCollectionProviderPrivatePath, target: KaratNFT.CollectionStoragePath)
        }

        self.karatNFTCollection = signer.getCapability<&KaratNFT.Collection{NonFungibleToken.Provider, KaratNFT.KaratNFTCollectionPublic}>(KaratNFTCollectionProviderPrivatePath)!
        assert(self.karatNFTCollection.borrow() != nil, message: "Missing or mis-typed KaratNFTCollection provider")

        self.marketCollection = signer.borrow<&KaratNFTMarket.Collection>(from: KaratNFTMarket.CollectionStoragePath)
            ?? panic("Missing or mis-typed KaratNFTMarket Collection")
    }

    execute {
        let offer <- KaratNFTMarket.createSaleOffer (
            sellerItemProvider: self.karatNFTCollection,
            itemID: itemID,
            sellerPaymentReceiver: self.karatVault,
            price: price
        )
        self.marketCollection.insert(offer: <-offer)
    }
}
