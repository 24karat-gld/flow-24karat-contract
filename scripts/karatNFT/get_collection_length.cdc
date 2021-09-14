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

// This transaction gets the length of an account's nft collection
pub fun main(account: Address): Int {
    let collectionRef = getAccount(account)
        .getCapability(KaratNFT.CollectionPublicPath)
        .borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    return collectionRef.getIDs().length
}