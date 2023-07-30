//
//  ViewController.swift
//  AgoraSttHelper
//
//  Created by darkzero on 07/20/2023.
//  Copyright (c) 2023 darkzero. All rights reserved.
//

import UIKit
import AgoraSttHelper
import DarkEggKit

class ViewController: UIViewController {
    @IBOutlet private weak var channelField: UITextField!
    @IBOutlet private weak var logLabel: UITextView!
    @IBOutlet private weak var joinButton: UIButton!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var queryButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    
    let sttHelper: AgoraSttHelper = .shared
    let rtcManager: AgoraRtcManager = .shared
    
    var currentChannelName: String?
    var currentSttTaskId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    @IBAction private func onJoinButtonClicked(_ sender: UIButton) {
        guard let channelName = self.channelField.text, !(channelName.isEmpty) else {
            return
        }
        self.rtcManager.join(channel: channelName, asHost: true) { success, uid in
            if success {
                let str = "Join channel \(channelName) success, uid is \(uid)"
                Logger.debug(str)
                self.logLabel.text.append("\n\(str)")
                self.currentChannelName = channelName
            }
            else {
                Logger.debug("Join channel \(channelName) fail")
            }
        }
    }
    
    @IBAction private func onStartButtonClicked(_ sender: UIButton) {
        guard let channelName = self.currentChannelName, !(channelName.isEmpty) else {
            return
        }
        
        guard self.sttHelper.loadConfig() else {
            Logger.debug("Can not load AgoraConfig.plist")
            return
        }
        
        let transCfgCnToJp = AgoraSttTanslate(source: .Chinese, target: [.Japanese])
        
        let sttConfig = AgoraSttConfig(channelName: channelName,
                                       languages: [.English, .Chinese],
                                       pullerUid: "1000",
                                       pullerToken: nil,
                                       pusherUid: "1001",
                                       pusherToken: nil)
        sttConfig.translate = [transCfgCnToJp]
        self.sttHelper.start(withConfig: sttConfig) { success, taskId in
            //
            if success {
                self.currentSttTaskId = taskId
                let str = "STT task started: \(taskId ?? "")"
                Logger.debug(str)
                self.logLabel.text.append("\n\(str)")
            }
            else {
                self.currentSttTaskId = nil
                let str = "STT task start failed"
                Logger.debug(str)
                self.logLabel.text.append("\n\(str)")
            }
        }
    }
    
    @IBAction private func onStopButtonClicked(_ sender: UIButton) {
        guard let taskId = self.currentSttTaskId else {
            return
        }
        self.sttHelper.stop(task: taskId) { success in
            if success {
                let str = "STT Task \(taskId) stopped"
                Logger.debug(str)
                self.logLabel.text.append("\n\(str)")
            }
            else {
                let str = "Stop STT Task \(taskId) failed"
                Logger.debug(str)
                self.logLabel.text.append("\n\(str)")
            }
        }
    }
    
    @IBAction private func onQueryButtonClicked(_ sender: UIButton) {
        guard let taskId = self.currentSttTaskId else {
            return
        }
        self.sttHelper.query(task: taskId) { success, status in
            let text = "Query task \(taskId) success \(success), status is \(status.rawValue)"
            Logger.debug(text)
            self.logLabel.text.append("\n\(text)")
        }
    }
}
