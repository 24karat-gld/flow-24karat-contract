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
import Karat from "../../contracts/Karat.cdc"

transaction(recipient: Address, amount: UFix64) {
    let tokenAdmin: &Karat.Administrator
    let tokenReceiver: &{FungibleToken.Receiver}

    prepare(signer: AuthAccount) {
        self.tokenAdmin = signer
        .borrow<&Karat.Administrator>(from: Karat.AdminStoragePath)
        ?? panic("Signer is not the token admin")

        self.tokenReceiver = getAccount(recipient)
        .getCapability(Karat.ReceiverPublicPath)!
        .borrow<&{FungibleToken.Receiver}>()
        ?? panic("Unable to borrow receiver reference")
    }

    execute {
        let minter <- self.tokenAdmin.createNewMinter(allowedAmount: amount)
        let mintedVault <- minter.mintTokens(amount: amount)

        self.tokenReceiver.deposit(from: <-mintedVault)

        destroy minter
    }
}
