import Foundation

struct BundleFetchingService<T: Codable> {
    func getArray(from resource: String, ofType type: String) -> [T] {
        guard let pathToData = Bundle.main.path(forResource: resource, ofType: type) else {
            fatalError("\(resource).\(type) file not found")
        }
        let internalUrl = URL(fileURLWithPath: pathToData)
        do {
            let data = try Data(contentsOf: internalUrl)
            return try JSONDecoder().decode([T].self, from: data)
        }
        catch {
            fatalError("An error occurred: \(error)")
        }
    }
}
