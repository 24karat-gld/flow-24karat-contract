import KaratItems from "../../contracts/KaratItems.cdc"

// This scripts returns the number of KaratItems currently in existence.

pub fun main(): UInt64 {    
    return KaratItems.totalSupply
}
