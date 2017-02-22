import Foundation

extension URLRequest {
    func extractAuthCodeFromRedirect() -> String? {
        guard let url = url else { return nil }
        let components = NSURLComponents(string: url.absoluteString)
        guard let items = components?.queryItems else {
            return nil
        }
        let code = items.filter { (item) -> Bool in
            return item.name == "code"
        }
        return code.first?.value
    }
}
