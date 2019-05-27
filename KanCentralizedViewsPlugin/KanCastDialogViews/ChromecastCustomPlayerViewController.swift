//
//  KANChromecastPlayerNavigation.swift
//  ZappGeneralPluginChromecast
//
//  Created by Avi Levin on 31/03/2019.
//

import UIKit
import GoogleCast
import ZappPlugins

extension NSNotification.Name {
    static let ChromecastSessionWillStart = Notification.Name("ChromecastSessionWillStart")
    static let ChromecastSessionDidStart = Notification.Name("ChromecastSessionDidStart")
    static let ChromecastCastSessionDidStart = Notification.Name("ChromecastCastSessionDidStart")
    static let ChromecastSessionDidEnd = Notification.Name("ChromecastSessionDidEnd")
    static let ChromecastSessionWillEnd = Notification.Name("ChromecastSessionWillEnd")
    static let ChromecastStartedPlaying = Notification.Name("ChromecastStartedPlaying")
    static let ChromecastPlayingError = Notification.Name("chromecastPlayingError")
    static let ChromecastPlayerWasMinimized = Notification.Name("chromecastPlayerWasMinimized")
}

@objc open class ChromecastCustomPlayerViewController: UIViewController, GCKRemoteMediaClientListener {
    
    @IBOutlet weak var castContainer: UIView?
    @IBOutlet weak var playButton: UIButton?
    @IBOutlet weak var pauseButton: UIButton?
    @IBOutlet weak var streamSlider: UISlider?
    @IBOutlet weak var deviceMessage: UILabel?
    @IBOutlet weak var spinner: UIActivityIndicatorView?
    @IBOutlet weak var minimizeScreenButton: UIButton?
    @IBOutlet weak var streamTitle: UILabel?
    
    var timer: Timer!
    var shouldShowMinimizeButton: Bool!
    
    //MARK: - ViewContrller Lifecycle
    init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?,
                  shouldShowMinimizeButton: Bool) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.shouldShowMinimizeButton = shouldShowMinimizeButton
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        //The Slider will always start from 0 and later will be update to the real location
        updateSilderTime(position: 0,
                         animated: false)

        setupMinimizeButton()
        playPauseState()
        
        //setup Chromecast button
        addChromecastButton()
        
        registerForNotifications()
        playerSetup()
        setTitleStream()
    }
    deinit {
        unRegisterForNotifications()
        disableAndRemoveTimerForSliderUpdate()
    }
    
    //MARK: - Player State Setup
    func playerSetup() {
        //Hide or display view componenets according to cast seesion state
        setViewObjectsState()
        //setup silder values
        setupSlider()
        //set deivce label
        setDeviceMessageLabel()
    }
    
    //MARK: - Minimize Button Logic
    func setupMinimizeButton() {
        self.minimizeScreenButton?.isHidden = !shouldShowMinimizeButton
    }
    
    @IBAction func minimizeAction(_ sender: Any) {
        NotificationCenter.default.post(name: .ChromecastPlayerWasMinimized, object: nil)
    }
    
    //MARK: - Buttons Action
    @IBAction func playAction(_ sender: Any) {
        
        guard let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient else {
            return
        }
        
        remoteMediaClient.play()
        
        playButton?.isHidden = true
        pauseButton?.isHidden = false
    }
    
    @IBAction func pauseAction(_ sender: Any) {
        
        guard let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient else {
            return
        }
        
        remoteMediaClient.pause()
        
        pauseButton?.isHidden = true
        playButton?.isHidden = false
    }
    
    //MARK: - Silder Confiurations
    
    func registerRemoteMediaClientDelegate() {
        guard let currentCastSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession else {
            return
        }
        
        guard let remoteMediaClient = currentCastSession.remoteMediaClient else {
            return
        }
        
        remoteMediaClient.add(self)
    }
    
    func setupSlider() {
        
        guard let currentCastSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession else {
            return
        }
        
        guard let remoteMediaClient = currentCastSession.remoteMediaClient else {
            return
        }
        
        remoteMediaClient.add(self)
        
        guard let mediaStatus = remoteMediaClient.mediaStatus  else {
            return
        }
        
        guard let mediaInformation = mediaStatus.mediaInformation else {
            return
        }
        
        //min value
        streamSlider?.minimumValue = 0.0
        
        //max value
        streamSlider?.maximumValue = Float(mediaInformation.streamDuration)
        
        
        //Set actual position
        updateSilderTime(position: Float(mediaStatus.streamPosition),
                         animated: false)
        
        addSliderEvents()
        createTimerForSliderUpdate()
    }
    
    func addSliderEvents() {
        self.streamSlider?.addTarget(self,
                                    action: #selector(sliderValueChanged(_:)),
                                    for: .valueChanged)
        
        self.streamSlider?.addTarget(self,
                                    action: #selector(sliderChangeStarted(_:)),
                                    for: .touchDown)
        
        self.streamSlider?.addTarget(self,
                                    action: #selector(sliderChangeEnded(_:)),
                                    for: .touchUpInside)
        
        self.streamSlider?.addTarget(self,
                                    action: #selector(sliderToucheCancelled(_:)),
                                    for: .touchCancel)
        
        self.streamSlider?.addTarget(self,
                                    action: #selector(sliderToucheCancelled(_:)),
                                    for: .touchUpOutside)
    }
    
    //Create a timer to update slider
    func createTimerForSliderUpdate() {
        if timer == nil {
            timer = Timer.gck_scheduledTimer(withTimeInterval: 1.0,
                                             weakTarget: self,
                                             selector: #selector(self.updateSliderFromCastStreamPositionFromMainTheard),
                                             userInfo: nil,
                                             repeats: true)
        }
    }
    
    //Remove timer
    func disableAndRemoveTimerForSliderUpdate() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    //Update slider according to cast stream
    @objc func updateSliderFromCastStreamPositionFromMainTheard() {
        if Thread.isMainThread {
            updateSliderFromCastStreamPosition()
        } else {
            DispatchQueue.main.async {
                [weak self] in
                self?.updateSliderFromCastStreamPosition()
            }
        }
    }
    
    @objc func updateSliderFromCastStreamPosition() {
        
        guard let currentCastSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession else {
            return
        }
        
        guard let remoteMediaClient = currentCastSession.remoteMediaClient else {
            return
        }
        
        guard let mediaStatus = remoteMediaClient.mediaStatus  else {
            return
        }
        
        updateSilderTime(position: Float(mediaStatus.streamPosition),
                         animated: true)
    }
    
    //Update slider time
    func updateSilderTime(position: Float, animated:Bool) {
        streamSlider?.setValue(position, animated: animated)
    }
    
    func seekCastAccordingToSliderPosistion() {
        guard let currentCastSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession else {
            return
        }
        
        guard let remoteMediaClient = currentCastSession.remoteMediaClient else {
            return
        }
        
        guard let seekValue = self.streamSlider?.value else {
            return
        }
        //Create a GCK seek options
        let seekOptions = GCKMediaSeekOptions()
        seekOptions.interval = TimeInterval(seekValue)
        
        //Send it to the chromecast device
        remoteMediaClient.seek(with: seekOptions)
    }
    
    
    //Events
    @objc func sliderValueChanged(_ sender: Any) {
        disableAndRemoveTimerForSliderUpdate()
    }
    
    @objc func sliderChangeStarted(_ sender: Any) {
        print("avitest - controlsSliderValueChanged")
    }
    
    @objc func sliderChangeEnded(_ sender: Any) {
        seekCastAccordingToSliderPosistion()
        createTimerForSliderUpdate()
    }
    
    @objc func sliderToucheCancelled(_ sender: Any) {
        updateSliderFromCastStreamPosition()
        createTimerForSliderUpdate()
    }
    
    //MARK: - Device Label Info
    func setDeviceMessageLabel() {
        guard let currentSession = GCKCastContext.sharedInstance().sessionManager.currentSession else {
            return
        }
        let castDeviceName = currentSession.device.friendlyName ?? ""
        var deviceMessage: String
        
        switch currentSession.connectionState {
        case .connecting:
            deviceMessage = "מתחבר ל- \(castDeviceName)"
        case .connected:
            deviceMessage = "משדר ל- \(castDeviceName)"
        case .disconnecting:
            deviceMessage = "מתנתק מ- \(castDeviceName)"
        case .disconnected:
            deviceMessage = "מנותק"
        default:
            deviceMessage = "מצב לא יודע"
        }
        
        self.deviceMessage?.text = deviceMessage
        self.deviceMessage?.setNeedsLayout()
    }
    
    //MARK: - Chromecast Button
    func addChromecastButton() {
        ZAAppConnector.sharedInstance().chromecastDelegate.addButton(self.castContainer,
                                                                     topOffset: 0,
                                                                     width: castContainer?.bounds.width ?? 0,
                                                                     buttonKey: "KANChromecastMiniPlayer",
                                                                     color: UIColor.white,
                                                                     useConstrains: false)
    }
    
    //MARK: - NSNotificationCenter
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionDidStart),
                                               name: .ChromecastCastSessionDidStart,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionWillEnd),
                                               name: .ChromecastSessionWillEnd,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionPlayingError),
                                               name: .ChromecastPlayingError,
                                               object: nil)
    }
    
    func unRegisterForNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .ChromecastCastSessionDidStart,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .ChromecastSessionWillEnd,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .ChromecastPlayingError,
                                                  object: nil)
    }
    
    @objc func sessionDidStart() {
        playerSetup()
    }
    
    @objc func sessionWillEnd() {
        playerSetup()
    }
    
    @objc func sessionPlayingError() {
        playerSetup()
    }
    
    //MARK: - Buttons State
    func setViewObjectsState() {
        guard let currentSession = GCKCastContext.sharedInstance().sessionManager.currentSession else {
            return
        }

        switch currentSession.connectionState {
        case .connecting:
            spinner?.startAnimating()
            self.playButton?.isHidden = true
            self.pauseButton?.isHidden = true
            self.streamSlider?.isHidden = true
            self.spinner?.isHidden = false
        case .connected:
            spinner?.stopAnimating()
            self.playButton?.isHidden = true
            self.pauseButton?.isHidden = false
            self.streamSlider?.isHidden = false
            self.spinner?.isHidden = true
        case .disconnecting, .disconnected:
            self.playButton?.isHidden = true
            self.pauseButton?.isHidden = true
            self.streamSlider?.isHidden = true
        default:
            self.playButton?.isHidden = true
            self.pauseButton?.isHidden = true
            self.streamSlider?.isHidden = true
            self.spinner?.isHidden = false
        }
    }
    
    func playPauseState() {
        guard let currentSession = GCKCastContext.sharedInstance().sessionManager.currentSession else {
            return
        }
        
        guard let remoteMediaClient = currentSession.remoteMediaClient else {
            return
        }
        
        guard let mediaStatus = remoteMediaClient.mediaStatus else {
            return
        }
        
        switch mediaStatus.playerState {
        case .playing:
            self.playButton?.isHidden = true
            self.pauseButton?.isHidden = false
        case .paused:
            self.playButton?.isHidden = false
            self.pauseButton?.isHidden = true
        default:
            self.playButton?.isHidden = false
            self.pauseButton?.isHidden = true
        }

    }
    //MARK: - GCKRemoteMediaClientListener Implementation
    func remoteMediaClient(_ client: GCKRemoteMediaClient, didStartMediaSessionWithID sessionID: Int) {
        playerSetup()
    }
    
    //MARK: - Stream Details
    func getStreamTitle() -> String{
        guard let currentCastSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession else {
            return ""
        }
        
        guard let remoteMediaClient = currentCastSession.remoteMediaClient else {
            return ""
        }
        
        guard let mediaStatus = remoteMediaClient.mediaStatus  else {
            return ""
        }
        
        guard let mediaInformation = mediaStatus.mediaInformation else {
            return ""
        }
        
        guard let metaData = mediaInformation.metadata else {
            return ""
        }

        guard let title = metaData.object(forKey: kGCKMetadataKeyTitle) as? String else {
            return ""
        }
        
        return title
    }
    
    func setTitleStream() {
        let title = getStreamTitle()
        self.streamTitle?.text = title
    }
}
