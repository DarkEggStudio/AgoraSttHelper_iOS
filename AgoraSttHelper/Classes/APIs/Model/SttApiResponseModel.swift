//
//  SttApiRequestModel.swift
//  AgoraSttHelper
//
//  Created by Yuhua Hu on 2023/07/25.
//

class SttApiResponseModel {
    /// Acquire
    struct Acquire: CommonResponseModel {
        var tokenName: String?
        var createTs: Int?
    }
    
    /// Start
    struct Start: CommonResponseModel {
        var taskId: String?
        var status: String?
    }
    
    /// Query
    struct Query: CommonResponseModel {
        var taskId: String?
        var createTs: Int?
        var status: String?
    }
    
    /// Stop
    struct Stop: CommonResponseModel {
        
    }
}
