import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let decoder = JSONDecoder()
    private let apiUrl = "https://fakestoreapi.com/products"
    
    func getProducts() async throws -> [Product] {
        guard let url = URL(string: apiUrl) else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.serverError }
        do {
            return try decoder.decode([Product].self, from: data)
        } catch {
            throw NetworkError.invalidData
        }
    }
    
}

enum NetworkError: String, Error {
    case invalidURL = "Usage of invalid URL"
    case serverError = "Some error while getting response"
    case invalidData = "Usage of invalid data"
}
