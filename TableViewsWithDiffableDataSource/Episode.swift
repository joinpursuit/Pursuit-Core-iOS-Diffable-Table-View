import Foundation

struct Episode: Codable, Hashable {
    let name: String
    let runtime: Int
    let summary: String
    let season: Int
    let number: Int
}

