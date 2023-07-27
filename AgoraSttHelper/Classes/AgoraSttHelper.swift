///
///
///

import PromiseKit

enum AgoraSttHelperError: Error {
    case invalidConfig
    case acquireFailed
    case startFailed
    case taskAlreadyStarted
    case taskNotFound
    case stopFailed
    
    var errorMessage: String {
        var msg = "Unknown error."
        switch self {
        case .invalidConfig:
            msg = "Invalid config file."
            break
        case .acquireFailed:
            msg = "Failed to get RTT tokenName."
            break
        case .startFailed:
            msg = "Can not start RTT task."
            break
        case .taskAlreadyStarted:
            msg = "The channel already have RTT task."
            break
        case .taskNotFound:
            msg = "Can not find task."
            break
        case .stopFailed:
            msg = "Failed to stop RTT task."
            break
        }
        return msg
    }
}

public class AgoraSttHelper: NSObject {
    var config: AgoraConfig!
    public static let shared: AgoraSttHelper = { AgoraSttHelper() }()
    
    var currentTasks: [String: AgoraSttConfig] = [:]
    var tokenOfTask: [String: String] = [:]
    
    override init() {
        super.init()
        // load agora config
        //let _ = self.loadConfig()
    }
    
    public func start(withConfig sttConfig: AgoraSttConfig, completion: @escaping ((Bool, String?) -> Void)) {
        // acquire
        var tokenName: String!
        self.requestAcquire(channel: sttConfig.channelName).then { acquireRes -> Promise<SttApiResponseModel.Start> in
            guard let token = acquireRes.tokenName else {
                return Promise { seal in
                    seal.reject(AgoraSttHelperError.acquireFailed)
                }
            }
            tokenName = token
            let startPromise: Promise<SttApiResponseModel.Start> = self.requestStart(tokenName: token, sttConfig: sttConfig)
            return startPromise
        }.done { startRes in
            guard let taskId = startRes.taskId else {
                throw AgoraSttHelperError.startFailed
            }
            self.currentTasks[taskId] = sttConfig
            self.tokenOfTask[taskId] = tokenName
            completion(true, taskId)
            return
        }.catch { error in
            //
            completion(false, "")
        }.finally {
            //
        }
    }
    
    public func query(task taskId: String, completion: ((Bool, AgoraSttTask?) -> Void)) {
        
    }
    
    public func stop(task taskId: String, completion: @escaping ((Bool) -> Void)) {
        guard let tokenName = self.tokenOfTask[taskId] else {
            completion(false)
            return
        }
        self.requestStop(token: tokenName, taskId: taskId).done { res in
            completion(true)
        }.catch { error in
            completion(false)
        }.finally {
            //
        }
    }
}

extension AgoraSttHelper {
    private func requestAcquire(channel: String) -> Promise<SttApiResponseModel.Acquire> {
        let appId = self.config.agoraAppId
        var api = AgoraSttApi.Acquire(appId: appId)
        api.parameter = ["instanceId": channel]
        return api.request()
    }
    
    private func requestStart(tokenName: String, sttConfig: AgoraSttConfig) -> Promise<SttApiResponseModel.Start> {
        let appId = self.config.agoraAppId
        var api = AgoraSttApi.Start(appId: appId, token: tokenName)
        
        let requestBody = SttApiRequestModel.Strat(channelName: sttConfig.channelName,
                                                   audioUid: sttConfig.pullerUid,
                                                   dataStreamUid: sttConfig.pusherUid)
        requestBody.config.recognizeConfig.language = sttConfig.language.paramString()
        
        if let trans = sttConfig.translate {
            var translanguages: [SttApiRequestModel.AgoraSTTTranslateLanguage] = []
            for tran in trans {
                let tranLang = SttApiRequestModel.AgoraSTTTranslateLanguage(source: tran.source.rawValue,
                                                                            target: tran.target.map({ l in return l.rawValue}))
                translanguages.append(tranLang)
            }
            let transConfig = SttApiRequestModel.AgoraSTTTranslateConfig(languages: translanguages)
            requestBody.config.translateConfig = transConfig
        }
        
        api.parameter = requestBody.dictionary
        return api.request()
    }
    
    private func requestQuery(token: String, taskId: String) -> Promise<SttApiResponseModel.Query> {
        let appId = self.config.agoraAppId
        let api = AgoraSttApi.Query(appId: appId, token: token, taskId: taskId)
        return api.request()
    }
    
    private func requestStop(token: String, taskId: String) -> Promise<SttApiResponseModel.Stop> {
        let appId = self.config.agoraAppId
        let api = AgoraSttApi.Stop(appId: appId, token: token, taskId: taskId)
        return api.request()
    }
}

extension AgoraSttHelper {
    //
    public func loadConfig() -> Bool {
        let decoder = PropertyListDecoder()
        guard
            let url = Bundle.main.url(forResource: "AgoraConfig", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let _config = try? decoder.decode(AgoraConfig.self, from: data) else {
            return false
        }
        self.config = _config
        return true
    }
    
    // TextStreamDataParser
    public func parseDataToSubtitle(data: Data, completion: ((Bool, SttText?)->Void)? = nil) {
        guard let text = try? SttText.parse(from: data), text.uid != 0 else {
            completion?(false, nil)
            return
        }
        
        print("Type: \(text.dataType ?? "--"); transArray_Count: \(text.transArray_Count); wordsArray_Count: \(text.wordsArray_Count)")
        
        completion?(true, text)
    }
}
