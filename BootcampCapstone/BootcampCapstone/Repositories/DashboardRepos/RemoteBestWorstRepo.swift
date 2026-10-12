import Foundation

class RemoteBestWorstProductsRepo: RemoteRepositoryBase<BestWorstProducts>, RepositoryProtocol<BestWorstProducts> {

    private let urlBase: String

    init(urlBase: String, authStatus: AuthStatus) {
        self.urlBase = urlBase
        super.init(authStatus: authStatus)
    }

    func getAll() async throws -> [BestWorstProducts] {
        let urlString = "\(urlBase)/Dashboard/best-worst"
        return try await fetchAll(urlString)
    }

    func getById(_ id: Int) async throws -> BestWorstProducts? {
        return nil
    }

    func insert(_ item: BestWorstProducts) async throws -> BestWorstProducts {
        throw URLError(.unsupportedURL)
    }

    func update(_ item: BestWorstProducts) async throws {
        throw URLError(.unsupportedURL)
    }

    func delete(_ item: BestWorstProducts) async throws {
        throw URLError(.unsupportedURL)
    }

}
