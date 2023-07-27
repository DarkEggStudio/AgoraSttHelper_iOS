//
//  AgoraConfig.swift
//  AgoraSttHelper
//
//  Created by Yuhua Hu on 2023/07/25.
//

public class AgoraApiAuthConfig: Codable {
    var authKey: String?
    var authSecret: String?
}

public class AgoraConfig: Codable {
    var agoraAppId: String = ""
    var agoraApiBaseUrl: String = ""
    var agoraApiAuth: AgoraApiAuthConfig?
    
    public func basicAuthToken() -> String? {
        guard let a = self.agoraApiAuth, let authKey = a.authKey, let authSecret = a.authSecret else {
            return nil
        }
        let token = "\(authKey):\(authSecret)".data(using: .utf8)?.base64EncodedString(options: [])
        return token
    }
}

public class AgoraConfigLoader {
    
}
