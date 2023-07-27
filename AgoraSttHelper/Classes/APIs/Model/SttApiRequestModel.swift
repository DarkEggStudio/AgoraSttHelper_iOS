//
//  SttApiRequestModel.swift
//  AgoraSttHelper
//
//  Created by Yuhua Hu on 2023/07/25.
//

/// STT API Request Model
class SttApiRequestModel {
    /// for audio.subscribeSource
    enum AgoraSTTSubscribeSource: String, Codable {
        case agoraRtc = "AGORARTC"
    }
    
    /// for audio.agoraRtcConfig.channelType
    enum AgoraSTTChannelType: String, Codable {
        case live = "LIVE_TYPE"
    }
    
    /// for audio.agoraRtcConfig.subscribeConfig.subscribeMode
    enum AgoraSTTSubscribeMode: String, Codable {
        case channel = "CHANNEL_MODE"
    }
    
    /// for config.features
    enum AgoraSTTFeatures: String, Codable {
        case recognize = "RECOGNIZE" // RECOGNIZE
        case translate = "TRANSLATE" // TRANSLATE
    }
    
    /// for config.recognizeConfig.model
    enum AgoraSTTModel: String, Codable {
        case model = "Model"
    }
    
    /// for config.recognizeConfig.output.destinations
    enum AgoraSTTDestinations: String, Codable {
        case rtcDataStream = "AgoraRTCDataStream"
        case storage = "Storage"
    }
    
    /// config.recognizeConfig.output.cloudStorage.format
    enum AgoraSTTCloudStorageFormat: String, Codable {
        case hls = "HLS"
    }
    
    /// Start request body
    public struct Strat: CommonRequestModel {
        var audio: AgoraSTTStartRequestAudio!
        var config: AgoraSTTStartRequestConfig!
        
        init(channelName: String,
             audioUid: String,
             audioToken: String? = nil,
             channelType: AgoraSTTChannelType = .live,
             subscribeConfig: AgoraSTTSubscribeMode = .channel,
             language: String = "en-US",
             model: AgoraSTTModel = .model,
             dataStreamUid: String,
             dataStreamToken: String? = nil) {
            
            // audio
            self.audio = AgoraSTTStartRequestAudio()
            self.audio.agoraRtcConfig.channelName = channelName
            self.audio.agoraRtcConfig.uid = audioUid
            self.audio.agoraRtcConfig.token = audioToken
            self.audio.agoraRtcConfig.channelType = channelType.rawValue
            
            // config
            self.config = AgoraSTTStartRequestConfig()
            self.config.recognizeConfig.language = language
            self.config.recognizeConfig.output.agoraRTCDataStream.channelName = channelName
            self.config.recognizeConfig.output.agoraRTCDataStream.uid = dataStreamUid
            self.config.recognizeConfig.output.agoraRTCDataStream.token = dataStreamToken
        }
    }
    
    // MARK: - audio
    /// request body > audio
    struct AgoraSTTStartRequestAudio: Codable {
        var subscribeSource: AgoraSTTSubscribeSource = .agoraRtc // "AGORARTC"
        var agoraRtcConfig: AgoraSTTAgoraRtcConfig! = AgoraSTTAgoraRtcConfig()
    }
    
    /// request body > audio > agoraRtcConfig
    class AgoraSTTAgoraRtcConfig: Codable {
        var channelName: String!
        var uid: String!
        var token: String?
        var channelType: String?
        var subscribeConfig: AgoraSTTSubscribeConfig! = AgoraSTTSubscribeConfig()
        var maxIdleTime: Int = 60
    }
    
    /// request body > audio > agoraRtcConfig > subscribeConfig
    struct AgoraSTTSubscribeConfig: Codable {
        var subscribeMode: AgoraSTTSubscribeMode = .channel // "CHANNEL_MODE"
    }
    
    // MARK: - congfig
    /// request body > config
    class AgoraSTTStartRequestConfig: Codable {
        var features: [AgoraSTTFeatures] = [.recognize]
        var recognizeConfig: AgoraSTTRecognizeConfig = AgoraSTTRecognizeConfig()
        var translateConfig: AgoraSTTTranslateConfig? = nil
    }
    
    /// request body > config > recognizeConfig
    struct AgoraSTTRecognizeConfig: Codable {
        var language: String = "en-US"
        var model: AgoraSTTModel = .model
        var profanityFilter: Bool = true
        var output: AgoraSTTOutput = AgoraSTTOutput()
    }
    
    /// request body > config > recognizeConfig > output
    struct AgoraSTTOutput: Codable {
        var destinations: [AgoraSTTDestinations] = [.rtcDataStream]
        var agoraRTCDataStream: AgoraSTTRtcDataStream = AgoraSTTRtcDataStream()
        var cloudStorage: AgoraSTTCloudStorage?
    }
    
    /// request body > config > recognizeConfig > output > agoraRTCDataStream
    struct AgoraSTTRtcDataStream: Codable {
        var channelName: String!
        var uid: String!
        var token: String!
    }
    
    /// request body > config > recognizeConfig > output > cloudStorage
    struct AgoraSTTCloudStorage: Codable {
        var format: AgoraSTTCloudStorageFormat?
        var storageConfig: AgoraSTTCloudStorageConfig?
    }
    
    /// request body > config > recognizeConfig > output > cloudStorage > storageConfig
    struct AgoraSTTCloudStorageConfig: Codable {
        var accessKey: String?
        var secretKey: String?
        var bucket: String?
        var vendor: String?
        var region: String?
        var fileNamePrefix: [String]?
    }
    
    // MARK: - translate config
    /// request body -> config -> translateConfig
    struct AgoraSTTTranslateConfig: Codable {
        var languages: [AgoraSTTTranslateLanguage]
    }
    
    struct AgoraSTTTranslateLanguage: Codable {
        var source: String
        var target: [String]
    }
}
