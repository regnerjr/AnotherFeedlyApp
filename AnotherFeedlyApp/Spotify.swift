import Foundation
import Keys

struct Auth {
    let redirectUri = "https://localhost/"
    let scope = "https://cloud.feedly.com/subscriptions"
    var clientId: String {
        return AnotherFeedlyAppKeys().fEEDLY_CLIENT
    }

    var clientSecret: String {
        return AnotherFeedlyAppKeys().fEEDLY_SECRET
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
