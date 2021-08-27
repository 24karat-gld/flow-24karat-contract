import KaratNFT from "../../contracts/KaratNFT.cdc"

// This scripts returns the number of KaratNFT currently in existence.

pub fun main(): UInt64 {    
    return KaratNFT.totalSupply
}
