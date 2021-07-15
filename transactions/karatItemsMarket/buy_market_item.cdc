import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import Karat from "../../contracts/Karat.cdc"
import KaratItems from "../../contracts/KaratItems.cdc"
import KaratItemsMarket from "../../contracts/KaratItemsMarket.cdc"


transaction(itemID: UInt64, marketCollectionAddress: Address, feeReceiverAddress: Address) {
    let paymentVault: @FungibleToken.Vault
    let karatItemsCollection: &KaratItems.Collection{NonFungibleToken.Receiver}
    let marketCollection: &KaratItemsMarket.Collection{KaratItemsMarket.CollectionPublic}

    prepare(acct: AuthAccount) {
        self.marketCollection = getAccount(marketCollectionAddress)
            .getCapability<&KaratItemsMarket.Collection{KaratItemsMarket.CollectionPublic}>(KaratItemsMarket.CollectionPublicPath)
            .borrow() ?? panic("Could not borrow market collection from market address")

        let price = self.marketCollection.borrowSaleItem(itemID: itemID)!.price

        let mainKaratVault = acct.borrow<&Karat.Vault>(from: Karat.VaultStoragePath)
            ?? panic("Cannot borrow Karat vault from acct storage")
        self.paymentVault <- mainKaratVault.withdraw(amount: price)

        self.karatItemsCollection = acct.borrow<&KaratItems.Collection{NonFungibleToken.Receiver}>(
            from: KaratItems.CollectionStoragePath
        ) ?? panic("Cannot borrow KaratItems collection receiver from acct")
    }

    execute {
        self.marketCollection.purchase(
            itemID: itemID,
            buyerCollection: self.karatItemsCollection,
            buyerPayment: <- self.paymentVault,
            feeReceiver: getAccount(feeReceiverAddress).getCapability<&AnyResource{FungibleToken.Receiver}>(Karat.ReceiverPublicPath)!,
            feeRate: 0.05
        )
    }
}
