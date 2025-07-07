import UIKit

final class ProductsViewModel {
    
    private var products = [Product]()
    private var stateScreen = StateScreen.Default
    var onProductsUpdated: (([Product]) -> Void)?
    var onStateScreenUpdated: ((StateScreen) -> Void)?
    
    init() {
        fetchProducts()
    }
    
    private func fetchProducts() {
        Task {
            do {
                self.updateStateScreen(stateScreen: .Loading)
                let products = try await NetworkManager.shared.getProducts()
                DispatchQueue.main.async {
                    self.products = products
                    self.onProductsUpdated?(products)
                    self.updateStateScreen(stateScreen: .Default)
                }
            } catch {
                if let error = error as? NetworkError {
                    self.updateStateScreen(stateScreen: .Error)
                }
            }
        }
    }
    
    private func updateStateScreen(stateScreen: StateScreen) {
        DispatchQueue.main.async {
            self.stateScreen = stateScreen
            self.onStateScreenUpdated?(stateScreen)
        }
    }
    
}

enum StateScreen {
    case Default
    case Loading
    case Error
}
