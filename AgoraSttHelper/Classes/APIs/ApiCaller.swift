//
//  APICaller.swift
//  AgoraSpeech2TextDemo
//
//  Created by Yuhua Hu on 2022/05/10.
//

import UIKit
import PromiseKit
import Alamofire
import DarkEggKit

// MARK: - keys and default values
private let kContentTypeKey     = "Content-Type"
private let kContentType        = "application/json"
private let kAuthorizationKey   = "Authorization"
private let kAuthorization      = "Bearer"
private let kBasicAuthWord      = "Basic"

struct HttpResponseStatusCode {
    static let success: Int     = 200
    static let notFound: Int    = 404
    static let needsUpate: Int  = 426
}

class ApiCaller: NSObject {
    // MARK: - Singleton
    static let shared: ApiCaller = {ApiCaller()}();
    internal var authToken: String?
    var requestQueue: [String: DataRequest] = [:]
}

extension ApiCaller {
    internal func callApi<API: CommonApiProtocol, T: Codable>(api: API, baseUrl: String) -> Promise<T> {
        var header = [kContentTypeKey: kContentType]
        
        // token auth
        if let token = self.authToken {
            header[kAuthorizationKey] = "\(kAuthorization) \(token)"
        }
        
        // basic auth for agora RESTful API
        if let basicAuthStr = AgoraSttHelper.shared.config.basicAuthToken(), !basicAuthStr.isEmpty {
            header[kAuthorizationKey] = "\(kBasicAuthWord) \(basicAuthStr)"
        }
        let requestQueue = DispatchQueue(label: "AgoraSttApiRequest")
        var param = api.parameter
        var encoding: ParameterEncoding = JSONEncoding.default
        if api.method == .get {
            encoding = URLEncoding(boolEncoding: .literal)
        }
        if api.method == .delete {
            param = nil
        }
        let url = "\(baseUrl)/\(api.endpoint)"
        let headers = HTTPHeaders(header)
        let request = AF.request(url, method: api.method, parameters: param, encoding: encoding, headers: headers)
        if let cancelToken = api.cancelToken {
            self.requestQueue[cancelToken] = request
        }
        //Logger.debug("request url: \(url)")
        //let s = String(data: request.request?.httpBody ?? Data(), encoding: .utf8)
        //Logger.debug("request body: \(s ?? "")")
        return Promise { seal in
            request.validate().response(queue: requestQueue) { (response) in
                // request end, remove from cancel queue
                if let cancelToken = api.cancelToken {
                    self.requestQueue[cancelToken] = nil
                    self.requestQueue.removeValue(forKey: cancelToken)
                }
                
                guard let statusCode = response.response?.statusCode else {
                    seal.reject(APIError.unknown)
                    return
                }
                
                //Logger.error("response.response?.statusCode: \(statusCode)")
                //Logger.error("response.response?.: \(response.response)")
                
                // 404
                if statusCode == HttpStatusCodes.notFound.rawValue {
                    seal.reject(APIError.noData)
                    return
                }
                
                let decoder = JSONDecoder()
                
                guard statusCode == HttpStatusCodes.success.rawValue else {
                    if let a = response.data {
                        if let err = try? decoder.decode(ApiErrorModel.self, from: a) {
                            seal.reject(APIError.serverError(statusCode, err))
                            return
                        }
                        if let t = try? decoder.decode(T.self, from: a) {
//                            if let err = t as? ApiErrorModel {
                                seal.reject(APIError.serverError(statusCode, t))
//                            }
                            return
                        }
                    }
                    seal.reject(APIError.unknown)
                    return
                }
                
                // Special for VoidObject
                if T.self == VoidModel.self {
                    let tempData = "{}".data(using: .utf8)!
                    if let voidObj = try? decoder.decode(T.self, from: tempData) {
                        seal.fulfill(voidObj)
                    }
                    else {
                        seal.reject(APIError.noData)
                    }
                    return
                }
                
                // Normal response
                if let data = response.data {
                    if let t = try? decoder.decode(T.self, from: data) {
                        seal.fulfill(t)
                    }
                    else {
                        seal.reject(APIError.noData)
                    }
                }
            }
        }
    }
    
    internal func cancelApi(token cancelToken: String?) {
        guard let key = cancelToken else {
            return
        }
        if let request = self.requestQueue[key] {
            request.cancel()
            self.requestQueue[key] = nil
            self.requestQueue.removeValue(forKey: key)
        }
    }
}
