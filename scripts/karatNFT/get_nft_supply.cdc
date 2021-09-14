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
 
import KaratNFT from "../../contracts/KaratNFT.cdc"

// This scripts returns the number of KaratNFT currently in existence.

pub fun main(): UInt64 {    
    return KaratNFT.totalSupply
}
