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

extension Auth: AuthData { }
