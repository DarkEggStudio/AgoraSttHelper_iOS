//
//  AgoraSttApi.swift
//  AgoraSttHelper
//
//  Created by Yuhua Hu on 2023/07/25.
//

import Alamofire

class AgoraSttApi {
    /// Acquire
    struct Acquire: CommonApiProtocol {
        typealias ResponseObject = SttApiResponseModel.Acquire
        
        let method: HTTPMethod = .post
        var parameter: [String : Any]?
        var cancelToken: String?
        
        init() {
            fatalError("must set AppId.")
        }
        
        let appId: String
        init(appId: String) {
            self.appId = appId
        }
        var endpoint: String {
            "v1/projects/\(appId)/rtsc/speech-to-text/builderTokens"
        }
    }
    
    /// Start
    struct Start: CommonApiProtocol {
        typealias ResponseObject = SttApiResponseModel.Start
        
        let method: HTTPMethod = .post
        var parameter: [String : Any]?
        var cancelToken: String?
        
        init() {
            fatalError("must set AppId.")
        }
        
        let appId: String
        let token: String
        init(appId: String, token: String) {
            self.appId = appId
            self.token = token
        }
        var endpoint: String {
            "v1/projects/\(appId)/rtsc/speech-to-text/tasks?builderToken=\(token)"
        }
        
    }
    
    /// Query
    struct Query: CommonApiProtocol {
        typealias ResponseObject = SttApiResponseModel.Query
        
        let method: HTTPMethod = .get
        var parameter: [String : Any]?
        var cancelToken: String?
        
        init() {
            fatalError("must set appId, token, taskId")
        }
        
        let appId: String
        let token: String
        let taskId: String
        init(appId: String, token: String, taskId: String) {
            self.appId = appId
            self.token = token
            self.taskId = taskId
        }
        var endpoint: String {
            "v1/projects/\(appId)/rtsc/speech-to-text/tasks/\(taskId)?builderToken=\(token)"
        }
    }
    
    /// Stop
    struct Stop: CommonApiProtocol {
        typealias ResponseObject = SttApiResponseModel.Stop
        
        let method: HTTPMethod = .delete
        var parameter: [String : Any]?
        var cancelToken: String?
        
        init() {
            fatalError("must set appId, token, taskId")
        }
        
        let appId: String
        let token: String
        let taskId: String
        init(appId: String, token: String, taskId: String) {
            self.appId = appId
            self.token = token
            self.taskId = taskId
        }
        var endpoint: String {
            "v1/projects/\(appId)/rtsc/speech-to-text/tasks/\(taskId)?builderToken=\(token)"
        }
    }
}
