//
//  AgoraRtcManager.swift
//  AgoraSttHelper_Example
//
//  Created by Yuhua Hu on 2023/07/25.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import AgoraRtcKit
import AgoraSttHelper
import DarkEggKit

// MARK: - AgoraRtcManagerDelegate
@objc protocol AgoraRtcManagerDelegate: AnyObject {
    func agoraRtcManager(_ mgr: AgoraRtcManager, userJoined uid: UInt)
    func agoraRtcManager(_ mgr: AgoraRtcManager, userLeaved uid: UInt)
    // Media player
    //@objc optional func agoraManager(_ mgr: AgoraManager, mediaPlayer: AgoraRtcMediaPlayerProtocol, loadCompleted: Bool)
    // subtitle
    @objc optional func agoraRtcManager(_ mgr: AgoraRtcManager, receiveText text: String, textUid: Int64, uid: UInt)          // in progress, update last one
    @objc optional func agoraRtcManager(_ mgr: AgoraRtcManager, receiveFinalText text: String, textUid: Int64, uid: UInt)     // final text, update last one, then add new line
    @objc optional func agoraRtcManager(_ mgr: AgoraRtcManager, receiveSubtitle subtitle: SttText)
}

// MARK: -
class AgoraRtcManager: NSObject {
    var agoraKit: AgoraRtcEngineKit!
    var selfUid: UInt = 0
    private var currentAgoraAppId: String!
    weak var delegate: AgoraRtcManagerDelegate?
    
    static let shared: AgoraRtcManager = { AgoraRtcManager()}()
    
    override init() {
        super.init()
        self.currentAgoraAppId = <#Agora App Id#>
        self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: self.currentAgoraAppId, delegate: self)
        agoraKit.setChannelProfile(.liveBroadcasting)
        agoraKit.setAudioProfile(.musicHighQualityStereo)
        agoraKit.setAudioScenario(.gameStreaming)
        agoraKit.enableAudio()
        agoraKit.enableVideo()
        agoraKit.enableLocalVideo(false)
        agoraKit.enableLocalAudio(true)
        agoraKit.muteLocalAudioStream(false)
        agoraKit.delegate = self
        agoraKit.adjustRecordingSignalVolume(100)
        agoraKit.adjustAudioMixingPublishVolume(0)
    }
}

extension AgoraRtcManager {
    
    func join(channel: String, asHost: Bool, completion: ((Bool, UInt) -> Void)?) {
        self.agoraKit.setClientRole(asHost ? .broadcaster : .audience)
        let uid = UInt.random(in: 100000..<200000)
        Logger.debug("uid: \(uid)")
        
        //self.agoraKit.enableAudioVolumeIndication(200, smooth: 3, reportVad: true)
        
        // join success block
        let joinChannelSuccessBlock: ((String, UInt, Int) -> Void) = { [weak self] channel, uid, elapsed in
            Logger.debug("Join \(channel) with uid \(uid) elapsed \(elapsed)ms")
            self?.selfUid = uid
            completion?(true, uid)
        }
        let ret = self.agoraKit.joinChannel(byToken: nil, channelId: channel, info: nil, uid: UInt(uid), joinSuccess: joinChannelSuccessBlock)
        Logger.debug("join channel return: \(ret)")
    }
}

extension AgoraRtcManager: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didMicrophoneEnabled enabled: Bool) {
        Logger.debug("didMicrophoneEnabled: \(enabled)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        Logger.debug("Remote user \(uid) join")
        self.delegate?.agoraRtcManager(self, userJoined: uid)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        Logger.debug("user \(uid) leave")
        self.delegate?.agoraRtcManager(self, userLeaved: uid)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        Logger.debug("Join \(channel) with uid \(uid) elapsed \(elapsed)ms")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        Logger.debug("errorCode \(errorCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        Logger.debug("warningCode \(warningCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, receiveStreamMessageFromUid uid: UInt, streamId: Int, data: Data) {
        Logger.debug("uid: \(uid), streamId: \(streamId), data: \(data)")
        AgoraSttHelper.shared.parseDataToSubtitle(data: data) { [weak self] success, sttText in
            guard success, let st = sttText, let mgr = self else {
                return
            }
            mgr.delegate?.agoraRtcManager?(mgr, receiveSubtitle: st)
        }
        return
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didClientRoleChanged oldRole: AgoraClientRole, newRole: AgoraClientRole, newRoleOptions: AgoraClientRoleOptions?) {
        Logger.debug("Role changed: \(oldRole) to \(newRole)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
        Logger.debug("speakers \(speakers.count)")
        speakers.forEach { info in
            Logger.debug("uid : \(info.uid)")
        }
    }
}
