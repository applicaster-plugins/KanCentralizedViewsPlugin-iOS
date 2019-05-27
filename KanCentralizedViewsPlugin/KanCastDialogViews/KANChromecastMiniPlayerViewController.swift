//
//  KANChromecastMiniPlayerViewController.swift
//  ZappGeneralPluginChromecast
//
//  Created by Avi Levin on 17/04/2019.
//

import UIKit

class KANChromecastMiniPlayerViewController: ChromecastCustomPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeSeekSliderView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    
    //MARK: - Customise Text
    func customizeMessage() {
        //Title setup
        let titleFontSize = CGFloat(15)
        let titlefont = UIFont(name: "SimplerPro_V3-Light", size: titleFontSize)
        self.streamTitle?.font = titlefont
        
        //device message setup
        let deviceFontSize = CGFloat(15)
        let devicefont = UIFont(name: "SimplerPro_V3-Bold", size: deviceFontSize)
        self.deviceMessage?.font = devicefont
    }
}
