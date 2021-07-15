import Karat from "../../contracts/Karat.cdc"

// This script returns the total amount of Karat currently in existence.

pub fun main(): UFix64 {

    let supply = Karat.totalSupply

    log(supply)

    return supply
}
