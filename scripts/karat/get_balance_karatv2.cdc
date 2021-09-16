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
 
import Karatv2 from "../../contracts/Karat.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"

// This script returns an account's Karat balance.

pub fun main(address: Address): UFix64 {
    let account = getAccount(address)
    
    let vaultRef = account.getCapability(Karatv2.BalancePublicPath)!.borrow<&Karatv2.Vault{FungibleToken.Balance}>()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}
