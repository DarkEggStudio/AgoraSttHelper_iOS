//
//  AgoraSttConfig.swift
//  AgoraSttHelper
//
//  Created by Yuhua Hu on 2023/07/21.
//

///
public let maxLanguageCount: Int = 2

/// config.recognizeConfig.language
public enum AgoraSTTLanguage: String, Codable, CaseIterable {
    case English    = "en-US"   // English - US
    case EnglishIn  = "en-IN"   // English - India
    case Japanese   = "ja-JP"   // Japanese - Japan
    case Chinese    = "zh-CN"   // Chiness - China Mainland
    case ChineseTw  = "zh-TW"   // Chinese - Taiwanese Putonghua
    case Cantonese  = "zh-HK"   // Chinese - Cantonese, Traditional
    case Hindi      = "hi-IN"   // Hindi = India
    case Korean     = "ko-KR"   // Korean - South Korea
    case German     = "de-DE"   // German - Germany
    case Spanish    = "es_ES"   // Spanish - Spain
    case French     = "fr-FR"   // French = France
    case Italian    = "it-IT"   // Italian - Italy
    case Portuguese = "pt-PT"   // Portuguese - Portugal
    case Indonesian = "id-ID"   // Indonesian - Indonesia
    case Arabic_JO  = "ar-JO"   // Arabic - Jordan
    case Arabic_EG  = "ar-EG"   // Arabic - Egyptian
    case Arabic_SA  = "ar-SA"   // Arabic - Saudi Arabia
    case Arabic_AE  = "ar-AE"   // Arabic - United Arab Emirates
    
    var displayName: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

///
extension [AgoraSTTLanguage] {
    func paramString() -> String {
        var result = ""
        for (index, item) in self.enumerated() {
            result.append("\(item.rawValue)")
            if index < self.count - 1 {
                result.append(",")
            }
        }
        return result
    }
}

public class AgoraSttConfig {
    public var channelName: String
    public var language: [AgoraSTTLanguage]
    public var pullerUid: String
    public var pullerToken: String?
    public var pusherUid: String
    public var pusherToken: String?
    public var translate: [AgoraSttTanslate]?
    
    public init(channelName: String, languages: [AgoraSTTLanguage], pullerUid: String, pullerToken: String? = nil, pusherUid: String, pusherToken: String? = nil, translate: [AgoraSttTanslate]? = nil) {
        self.channelName = channelName
        self.language = languages
        self.pullerUid = pullerUid
        self.pullerToken = pullerToken
        self.pusherUid = pusherUid
        self.pusherToken = pusherToken
        self.translate = translate
    }
}

public class AgoraSttTanslate {
    public var source: AgoraSTTLanguage
    public var target: [AgoraSTTLanguage]
    
    public init(source: AgoraSTTLanguage, target: [AgoraSTTLanguage]) {
        self.source = source
        self.target = target
    }
}
