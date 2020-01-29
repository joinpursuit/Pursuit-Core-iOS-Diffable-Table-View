import Foundation

struct Episode: Codable {
    let name: String
    let runtime: Int
    let summary: String
    
    static func getEpisodes(from data: Data) -> [Episode] {
        guard let episodes = try? JSONDecoder().decode([Episode].self, from: data) else {
            print("Error serializing data")
            return []
        }
        return episodes
    }
}

