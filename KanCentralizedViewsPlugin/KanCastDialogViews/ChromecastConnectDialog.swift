//
//  ChromecastCustomDialog.swift
//  ZappGeneralPluginChromecast
//
//  Created by Avi Levin on 17/03/2019.
//

import UIKit
import GoogleCast
import ZappGeneralPluginsSDK

public class ChromecastConnectDialog: KanCustomDialog, ZPChromecastCustomDialog {
    
    public override init() {
        super.init()
    }
    
    func collectionViewXibSetup(cellSize: CGFloat) -> UIView? {
        let bundle = Bundle(for: ChromecastDeviceListView.self)
        let nib = UINib(nibName: "ChromecastDeviceListView", bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? ChromecastDeviceListView else {
            return nil
        }
        
        return view
    }
    
    func disconnectViewXibSetup() -> UIView? {
        let bundle = Bundle(for: ChromecastDeviceDisconnectView.self)
        let nib = UINib(nibName: "ChromecastDeviceDisconnectView", bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: nil, options: nil)[0] as? ChromecastDeviceDisconnectView else {
            return nil
        }
        
        return view
    }
    
    //MARK: - ZPChromecastCustomDialog
    public func showDialog() {
        
        var view: UIView?
        
        guard let dialogView = getDialogView() else {
            return
        }
        
        if GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession() {
            //In close chromecast dialog view don't show a title
            dialogView.titleLabel?.isHidden = true
            view = disconnectViewXibSetup()
            
        } else {
            //In connect chromecast dialog view show a title
            dialogView.titleLabel?.isHidden = false
            view = collectionViewXibSetup(cellSize: dialogView.containerView.bounds.height)
        }
        
        guard let castView = view else {
            return
        }
        
        dialogView.containerView.addSubview(castView)
        castView.matchParent()
        
        self.showDialogView(dialogView: dialogView)
    }
    
    public func dismissDialog() {
        self.dismissDialogViewIfNeeded()
    }
    
    public func getPlayerNavigation(shouldShowMinimizeButton: Bool) -> UIViewController {
        let bundle = Bundle(for: ChromecastCustomPlayerViewController.self)
        return KANChromecastInlinePlayerViewController.init(nibName: "KANChromecastPlayerNavigation",
                                                            bundle: bundle,
                                                            shouldShowMinimizeButton: shouldShowMinimizeButton)
    }

    public func getMiniPlayerNavigation() -> UIViewController {
        let bundle = Bundle(for: ChromecastConnectDialog.self)
        
        return KANChromecastMiniPlayerViewController.init(nibName: "KANChromecastMiniPlayerNavigation",
                                                          bundle: bundle,
                                                          shouldShowMinimizeButton: false)
    }
}
