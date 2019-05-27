//
//  KanDialogUtiles.swift
//  ZappGeneralPluginChromecast
//
//  Created by Avi Levin on 17/03/2019.
//

import UIKit

class KanDialogUtiles: NSObject {
    //Support iPhone X - Calc safe area buttom padding
    @objc static func getBottomIPhoneXPadding() -> CGFloat {
        var bottomSafeArea: CGFloat?
        let window = UIApplication.shared.keyWindow
        
        if #available(iOS 11.0, *) {
            bottomSafeArea = window?.rootViewController?.view.safeAreaInsets.bottom
        } else {
            bottomSafeArea = window?.rootViewController?.bottomLayoutGuide.length
        }
        
        guard let bottomSize = bottomSafeArea else {
            return 0
        }
        
        return bottomSize
    }
}
