import Foundation

let kClientKey = "FEEDLY_CLIENT"
let kFeedlySecretKey = "FEEDLY_SECRET"

struct Auth {
    let redirectUri = "https://localhost/"
    let scope = "https://cloud.feedly.com/subscriptions"
    var clientId: String {
        guard let client = ProcessInfo.processInfo.environment[kClientKey] else {
            fatalError("🐛 ERROR: No Environment variable \(kClientKey)")
        }
        return client
    }

    var clientSecret: String {
        guard let client = ProcessInfo.processInfo.environment[kFeedlySecretKey] else {
            fatalError("🐛 ERROR: No Environment variable \(kFeedlySecretKey)")
        }
        return client
    }
}

struct Spotify {

    let auth: Auth

    let base = "https://sandbox.feedly.com"
    let path = "/v3/auth/auth"

    var signInRequest: URLRequest {
        return URLRequest(url: signInURL)
    }

    var signInURL: URL {
        let response_type = URLQueryItem(name: "response_type", value: "code")
        let client_id = URLQueryItem(name: "client_id", value: auth.clientId)
        let redirect_uri = URLQueryItem(name: "redirect_uri", value: auth.redirectUri)
        let scope = URLQueryItem(name: "scope", value: auth.scope)

        var url = URLComponents(string: self.base)!
        url.path = self.path
        url.queryItems = [ response_type, client_id, redirect_uri, scope]
        return url.url!
    }
}
