//
//  File.swift
//  AgoraSttHelper
//
//  Created by Yuhua Hu on 2023/07/21.
//

public enum AgoraSttState: String, CaseIterable {
    case stopped
    case starting
    case started
    case stopping
}

public class TranslateConfig {
    var source: String
    var target: [String]
    
    init(source: String, target: [String]) {
        self.source = source
        self.target = target
    }
}

class AgoraSttTaskConfig {
    var channelName: String
    var pullerUid: String
    var pullerToken: String
    var pusherUid: String
    var pusherToken: String
    var languages: [AgoraSTTLanguage] = [.English]
    var translate: [TranslateConfig]?
    
    init(channelName: String, pullerUid: String, pullerToken: String, pusherUid: String, pusherToken: String, languages: [AgoraSTTLanguage], translate: [TranslateConfig]? = nil) {
        self.channelName = channelName
        self.pullerUid = pullerUid
        self.pullerToken = pullerToken
        self.pusherUid = pusherUid
        self.pusherToken = pusherToken
        self.languages = languages
        self.translate = translate
    }
}

public class AgoraSttTask: NSObject {
    private(set) public var state: AgoraSttState = .stopped 
    
    public func start() {
        self.state = .starting
        return
    }
    
    public func stop() {
        self.state = .stopping
        self.state = .stopped
        return
    }
}
