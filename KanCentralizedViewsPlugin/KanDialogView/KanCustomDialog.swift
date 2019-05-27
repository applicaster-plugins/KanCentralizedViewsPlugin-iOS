//
//  CustomDialogConnectView.swift
//  ZappGeneralPluginChromecast
//
//  Created by Avi Levin on 14/03/2019.
//

import UIKit
import ZappPlugins

class KanCustomDialog: NSObject {
    
    open var dialogView: KanDialogView?
    
    let KanDialogCollectionCellIdentifier = "KanDialogCollectionCell"
    
    override init() {
        super.init()
    }
    
    func getDialogView() -> KanDialogView? {
        let bundle = Bundle(for: KanDialogView.self)
        let nib = UINib(nibName: "KanDialogView", bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: nil, options: nil)[0] as? KanDialogView else {
            return nil
        }
        
        return view
    }
    
    // MARK: - Dialog present managment
    func isDialogViewPresent() -> Bool {
        var retVal = false

        if self.dialogView?.superview != nil {
            retVal = true
        }
        
        return retVal
    }
    
    @objc func showDialogView(dialogView: KanDialogView) {
        guard let modalViewController = ZAAppConnector.sharedInstance().navigationDelegate.topmostModal() else {
            return
        }
        
        if self.isDialogViewPresent() == false {
            modalViewController.view.addSubview(dialogView)
            dialogView.matchParent()
            UIView.animate(withDuration: 0.3) {
                dialogView.mainView.center.y -= dialogView.mainView.bounds.height
            }
            
            self.dialogView = dialogView
        }
    }
    
    public func dismissDialogViewIfNeeded() {
        self.dialogView?.close()
    }
}

