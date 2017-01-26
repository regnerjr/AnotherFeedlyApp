import Foundation


struct Spotify {

    let auth: Auth

    let base = "https://sandbox.feedly.com"
    let signInPath = "/v3/auth/auth"
    let tokenPath = "/v3/auth/token"

    var signInRequest: URLRequest {
        return URLRequest(url: signInURL)
    }

    /// https://developer.feedly.com/v3/auth/#authenticating-a-user-and-obtaining-an-auth-code
    var signInURL: URL {
        let response_type = URLQueryItem(name: "response_type", value: "code")
        let client_id = URLQueryItem(name: "client_id", value: auth.clientId)
        let redirect_uri = URLQueryItem(name: "redirect_uri", value: auth.redirectUri)
        let scope = URLQueryItem(name: "scope", value: auth.scope)

        var url = URLComponents(string: self.base)!
        url.path = self.signInPath
        url.queryItems = [ response_type, client_id, redirect_uri, scope]
        return url.url!
    }

    /// https://developer.feedly.com/v3/auth/#exchanging-an-auth-code-for-a-refresh-token-and-an-access-token
    func tokenRequestJSON(code: String) -> Data {
        let dict = [
            "code": code,
            "client_ID": auth.clientId,
            "client_secret": auth.clientSecret,
            "redirect_uri": auth.redirectUri,
            "state": "",
            "grant_type": "authorization_code"
        ]
        return try! JSONSerialization // swiftlint:disable:this force_try
            .data(withJSONObject: dict, options: [])
    }

    func tokenRequest(code: String) -> URLRequest {
        var maybeURL = URLComponents(string: base)
        maybeURL?.path = tokenPath
        guard let url = maybeURL?.url else {
            fatalError("Can't build Token Request URL")
        }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.httpBody = tokenRequestJSON(code: code)
        return req
    }

    func requestToken(withCode code: String, completion:() -> Void) {

        completion()
    }
}
