//
//  ApiErrorModel.swift
//  AgoraSttHelper
//
//  Created by Yuhua Hu on 2023/07/27.
//

// MARK: -
enum AuthError: Error {
    case noError
    case noSavedToken
    case settingError
    case idServerError
    case conflictError
    case unknown
}

class ApiErrorModel: Codable {
    var errorCode: Int?
    var message: String?
}

class VoidModel: ApiErrorModel {
    // Coding keys
    enum CodingKeys: String, CodingKey {
        case errorCode      = "errorCode"
        case message        = "message"
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        if let values = try? decoder.container(keyedBy: CodingKeys.self) {
            errorCode       = try? values.decode(Int.self, forKey: .errorCode)
            message         = try? values.decode(String.self, forKey: .message)
        }
        else {
            errorCode = 0
            message = nil
        }
    }
}
