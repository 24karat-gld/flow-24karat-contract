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
 