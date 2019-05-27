//
//  ChromecastDeviceDisconnectView.swift
//  ZappGeneralPluginChromecast
//
//  Created by Avi Levin on 20/03/2019.
//

import UIKit
import GoogleCast

class ChromecastDeviceDisconnectView: UIView {

    @IBOutlet weak var connectInformation: UILabel!
    @IBOutlet weak var disconnectButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customiseView()
        customizeText()
    }
    
    @IBAction func disconnectChromecast(_ sender: Any) {
        GCKCastContext.sharedInstance().sessionManager.endSessionAndStopCasting(true)
    }
    
    func customiseView() {
        guard let disconnectButtonText = self.disconnectButton.titleLabel?.text else {
            return
        }
        
        let textRange = NSMakeRange(0, disconnectButtonText.count)
        let attributedText = NSMutableAttributedString(string: disconnectButtonText)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        
        self.disconnectButton.titleLabel?.attributedText = attributedText
    }
    
    //MARK: - Customise Text
    func customizeText() {
        //ConnectInformation
        let connectInformationFontSize = CGFloat(16)
        let connectInformationFont = UIFont(name: "SimplerPro_V3-Regular", size: connectInformationFontSize)
        self.connectInformation?.font = connectInformationFont
        
        //DisconnectButton
        let disconnectButtonFontSize = CGFloat(16)
        let disconnectButtonFontFont = UIFont(name: "SimplerPro_V3-Regular", size: disconnectButtonFontSize)
        self.disconnectButton.titleLabel?.font = disconnectButtonFontFont
    }
}
