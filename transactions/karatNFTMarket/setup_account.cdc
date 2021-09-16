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
 
import KaratNFTMarket from "../../contracts/KaratNFTMarket.cdc"

// This transaction configures an account to hold SaleOffer items.

transaction {
    prepare(signer: AuthAccount) {

        // if the account doesn't already have a collection
        if signer.borrow<&KaratNFTMarket.Collection>(from: KaratNFTMarket.CollectionStoragePath) == nil {

            // create a new empty collection
            let collection <- KaratNFTMarket.createEmptyCollection() as! @KaratNFTMarket.Collection
            
            // save it to the account
            signer.save(<-collection, to: KaratNFTMarket.CollectionStoragePath)

            // create a public capability for the collection
            signer.link<&KaratNFTMarket.Collection{KaratNFTMarket.CollectionPublic}>(KaratNFTMarket.CollectionPublicPath, target: KaratNFTMarket.CollectionStoragePath)
        }
    }
}
