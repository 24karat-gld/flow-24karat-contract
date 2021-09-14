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
