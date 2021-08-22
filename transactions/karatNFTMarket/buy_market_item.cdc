import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import Karat from "../../contracts/Karat.cdc"
import KaratNFT from "../../contracts/KaratNFT.cdc"
import KaratNFTMarket from "../../contracts/KaratNFTMarket.cdc"


transaction(itemID: UInt64, marketCollectionAddress: Address, feeAddress: Address, feeRate: UFix64) {
    let paymentVault: @FungibleToken.Vault
    let karatNFTCollection: &KaratNFT.Collection{NonFungibleToken.Receiver}
    let marketCollection: &KaratNFTMarket.Collection{KaratNFTMarket.CollectionPublic}
    let feeReceiver:Capability<&AnyResource{FungibleToken.Receiver}>
    prepare(signer: AuthAccount) {
        self.marketCollection = getAccount(marketCollectionAddress)
            .getCapability<&KaratNFTMarket.Collection{KaratNFTMarket.CollectionPublic}>(
                KaratNFTMarket.CollectionPublicPath
            )!
            .borrow()
            ?? panic("Could not borrow market collection from market address")

        let saleItem = self.marketCollection.borrowSaleItem(itemID: itemID)
                    ?? panic("No item with that ID")
        let price = saleItem.price

        self.feeReceiver = getAccount(feeAddress).getCapability<&AnyResource{FungibleToken.Receiver}>(Karat.ReceiverPublicPath)!

        let mainVault = signer.borrow<&Karat.Vault>(from: Karat.VaultStoragePath)
            ?? panic("Cannot borrow Token vault from acct storage")
        self.paymentVault <- mainVault.withdraw(amount: price)

        self.karatNFTCollection = signer.borrow<&KaratNFT.Collection{NonFungibleToken.Receiver}>(
            from: KaratNFT.CollectionStoragePath
        ) ?? panic("Cannot borrow KaratNFT collection receiver from acct")
    }

    execute {
        self.marketCollection.purchase(
            itemID: itemID,
            buyerCollection: self.karatNFTCollection,
            buyerPayment: <- self.paymentVault,
            feeReceiver: self.feeReceiver,
            feeRate: feeRate
        )
    }
}