import Foundation
import Keys

struct Auth {

    let redirectUri: String
    let scope: String
    let clientId: String
    let clientSecret: String

    init(clientId: String = AnotherFeedlyAppKeys().fEEDLY_CLIENT,
          clientSecret: String = AnotherFeedlyAppKeys().fEEDLY_SECRET,
          redirectUri: String = "https://localhost/",
          scope: String = "https://cloud.feedly.com/subscriptions"
        ) {

        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectUri = redirectUri
        self.scope = scope
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

