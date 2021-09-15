/*
 * Copyright (c) 2021 24Karat. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 *
 * This file is part of Project: 24karat flow contract (https://github.com/24karat-gld/flow-24karat-contract)
 *
 * This source code is licensed under the MIT License found in the
 * LICENSE file in the root directory of this source tree or at
 * https://opensource.org/licenses/MIT.
 */
 
import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import Karat from "../../contracts/Karat.cdc"
import KaratNFT from "../../contracts/KaratNFT.cdc"
import KaratNFTMarket from "../../contracts/KaratNFTMarket.cdc"


transaction(itemID: UInt64, marketCollectionAddress: Address) {
    let paymentVault: @FungibleToken.Vault
    let karatNFTCollection: &KaratNFT.Collection{NonFungibleToken.Receiver}
    let marketCollection: &KaratNFTMarket.Collection{KaratNFTMarket.CollectionPublic}
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
            buyerPayment: <- self.paymentVault
        )
    }
}