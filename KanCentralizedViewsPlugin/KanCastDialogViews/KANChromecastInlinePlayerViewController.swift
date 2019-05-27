//
//  KANChromecastInlinePlayerViewController.swift
//  ZappGeneralPluginChromecast
//
//  Created by Avi Levin on 17/04/2019.
//

import UIKit

class KANChromecastInlinePlayerViewController: ChromecastCustomPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeSeekSliderView()
        customizeMinimizeButton()
        customizeMessage()
    }
    
    //MARK: - Silder Confiurations
    func customizeSeekSliderView() {
        let bundle = Bundle(for: ChromecastCustomPlayerViewController.self)
        
        let thumbImage = UIImage.init(named: "navBarCircle.png",
                                      in:bundle,
                                      compatibleWith: nil)
        
        self.streamSlider?.setThumbImage(thumbImage,
                                         for: .normal)
        
        self.streamSlider?.setThumbImage(thumbImage,
                                         for: .highlighted)
        
        let minTrackTintColor = UIColor.init(red: 0.0,
                                             green: 143/256.0,
                                             blue: 159/256.0,
                                             alpha: 1.0)
        self.streamSlider?.minimumTrackTintColor = minTrackTintColor
        
        let maxTrackTintColor = UIColor.init(red: 177/256.0,
                                             green: 177/256.0,
                                             blue: 177/256.0,
                                             alpha: 1.0)
        self.streamSlider?.maximumTrackTintColor = maxTrackTintColor
        
    }
    
    //MARK: - Minimize Button Logic
    func customizeMinimizeButton() {
        let bundle = Bundle(for: ChromecastCustomPlayerViewController.self)
        let minimizeImage = UIImage.init(named: "minimize_icon.png",
                                         in:bundle,
                                         compatibleWith: nil)
        
        self.minimizeScreenButton?.setImage(minimizeImage,
                                            for: .normal)
    }
    
    //MARK: - Customise Text
    func customizeMessage() {
        let fontSize = CGFloat(22)
        let font = UIFont(name: "SimplerPro_V3-Regular", size: fontSize)
        self.streamTitle?.font = font
    }
    
}
