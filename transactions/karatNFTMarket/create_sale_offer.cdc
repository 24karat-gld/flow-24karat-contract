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

transaction(itemID: UInt64, price: UFix64) {
    let karatVault: Capability<&Karat.Vault{FungibleToken.Receiver}>
    let karatNFTCollection: Capability<&KaratNFT.Collection{NonFungibleToken.Provider, KaratNFT.KaratNFTCollectionPublic}>
    let marketCollection: &KaratNFTMarket.Collection

    prepare(signer: AuthAccount) {

        self.karatVault = signer.getCapability<&Karat.Vault{FungibleToken.Receiver}>(Karat.ReceiverPublicPath)!
        assert(self.karatVault.borrow() != nil, message: "Missing or mis-typed Karat receiver")

        if !signer.getCapability<&KaratNFT.Collection{NonFungibleToken.Provider, KaratNFT.KaratNFTCollectionPublic}>(KaratNFTMarket.CollectionPrivatePath)!.check() {
            signer.link<&KaratNFT.Collection{NonFungibleToken.Provider, KaratNFT.KaratNFTCollectionPublic}>(KaratNFTMarket.CollectionPrivatePath, target: KaratNFT.CollectionStoragePath)
        }

        self.karatNFTCollection = signer.getCapability<&KaratNFT.Collection{NonFungibleToken.Provider, KaratNFT.KaratNFTCollectionPublic}>(KaratNFTMarket.CollectionPrivatePath)!
        assert(self.karatNFTCollection.borrow() != nil, message: "Missing or mis-typed KaratNFTCollection provider")

        self.marketCollection = signer.borrow<&KaratNFTMarket.Collection>(from: KaratNFTMarket.CollectionStoragePath)
            ?? panic("Missing or mis-typed KaratNFTMarket Collection")
    }

    execute {
        let offer <- KaratNFTMarket.createSaleOffer (
            sellerItemProvider: self.karatNFTCollection,
            itemID: itemID,
            sellerPaymentReceiver: self.karatVault,
            price: price,
            receiverPublicPath: Karat.ReceiverPublicPath
        )
        self.marketCollection.insert(offer: <-offer)
    }
}
