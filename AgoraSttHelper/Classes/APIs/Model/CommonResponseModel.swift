//
//  CommonResponseModel.swift
//  AgoraSpeech2TextDemo
//
//  Created by Yuhua Hu on 2022/05/10.
//

protocol CommonResponseModel: Codable {
    var errorCode: Int? { get set }
    var message: String? { get set }
}

extension CommonResponseModel {
    var errorCode: Int? {
        get { return 0 }
        set {}
    }
    
    var message: String? {
        get { return "" }
        set {}
    }
}
