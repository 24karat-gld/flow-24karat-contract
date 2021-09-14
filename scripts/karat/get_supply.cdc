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
 
import Karat from "../../contracts/Karat.cdc"

// This script returns the total amount of Karat currently in existence.

pub fun main(): UFix64 {

    let supply = Karat.totalSupply

    log(supply)

    return supply
}
