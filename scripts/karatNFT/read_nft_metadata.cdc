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

// This script reads metadata about an NFT in a user's collection
pub fun main(account: Address, itemID: UInt64): {String:String} {

    let owner = getAccount(account)

    let collection = owner.getCapability(KaratNFT.CollectionPublicPath)!
        .borrow<&{KaratNFT.KaratNFTCollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    // Borrow a reference to a specific NFT in the collection
    let nft = collection.borrowKaratNFT(id: itemID) ?? panic("No such itemID in that collection")

    return nft.getMetadata()
}