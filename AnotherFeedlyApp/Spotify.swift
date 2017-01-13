import Foundation

enum Auth {
    static let clientId = "sandbox"
    static let clientSecret = "R26NGS2Q9NAPSEJHCXM3"
    static let redirect_uri = "http://localhost/"
    static let scope = "https://cloud.feedly.com/subscriptions"
}

struct Spotify {

    let base = "https://sandbox.feedly.com"
    let path = "/v3/auth/auth"

    var signInRequest: URLRequest {
        return URLRequest(url: signInURL)
    }

    var signInURL: URL {
        let response_type = URLQueryItem(name: "response_type", value: "code")
        let client_id = URLQueryItem(name: "client_id", value: Auth.clientId)
        let redirect_uri = URLQueryItem(name: "redirect_uri", value: Auth.redirect_uri)
        let scope = URLQueryItem(name: "scope", value: Auth.scope)

        var url = URLComponents(string: self.base)!//.appendingPathComponent(path)
        url.path = self.path
        url.queryItems = [ response_type, client_id, redirect_uri, scope]
        return url.url!
    }
}
