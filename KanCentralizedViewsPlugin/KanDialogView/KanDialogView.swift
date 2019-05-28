//
//  SleepModeView.swift
//  Pods
//
//  Created by Miri on 23/12/2018.
//

import Foundation
import ZappPlugins

public class KanDialogView: UIView {

    let KanDialogCollectionCellIdentifier = "KanDialogCollectionCell"
    
    @IBOutlet weak var touchEventView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var closeButton: UIButton?
    @IBOutlet weak var dividerView: UIView?
    @IBOutlet weak var containerView: UIView!
    
    var intervalArray: [String]?
    override public func awakeFromNib() {
        super.awakeFromNib()
        //Font setup
        customizeText()
        
        //Touch event
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector (touchEventViewTuched (_:)))
        self.touchEventView.addGestureRecognizer(gesture)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func set(configuration:NSDictionary?, pluginStyles: [String : Any]?) {

        self.setBackgroundColor(key: "sleep_mode_bg_color", from: pluginStyles)
        if let dividerView = dividerView {
            dividerView.setBackgroundColor(key: "sleep_mode_bottom_divider_color",
                                           from: pluginStyles)
        }
        
        if let configuration = configuration {
            if let title = configuration["sleep_mode_title"] as? String,
                let titleLabel = titleLabel{
                titleLabel.text = title
                titleLabel.setFont(fontNameKey: "action_text_sleep_mode_font_name",
                                   fontSizeKey: "action_text_sleep_mode_font_size",
                                   from: pluginStyles)

                titleLabel.setColor(key: "action_text_sleep_mode_color",
                                    from: pluginStyles)
            }
            if let closeButtonTitle = configuration["sleep_mode_close_title"] as? String,
                let closeButton = closeButton {
                closeButton.setTitle(closeButtonTitle, for: .normal)
                closeButton.setFont(fontNameKey: "close_text_sleep_mode_font_name",
                                    fontSizeKey: "close_text_sleep_mode_font_size",
                                    from: pluginStyles)
                closeButton.setColor(key: "close_text_sleep_mode_color",
                                     from: pluginStyles)

            }
        }
    }
    
    func close() {
        UIView.animate(withDuration: 0.3, animations: {
            self.mainView.center.y += self.frame.height //+ KanDialogUtiles.getBottomIPhoneXPadding()
        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func closeButtonClick(sender: UIButton) {
        self.close()
    }
    
    //MARK: - Customise Text
    func customizeText() {
        //Title setup
        let titleLabelFontSize = CGFloat(16)
        let titleLabelfont = UIFont(name: "SimplerPro_V3-Regular", size: titleLabelFontSize)
        self.titleLabel?.font = titleLabelfont
        
        //Close setup
        let closeLabelFontSize = CGFloat(16)
        let closeLabelfont = UIFont(name: "SimplerPro_V3-Regular", size: closeLabelFontSize)
        self.closeButton?.titleLabel?.font = closeLabelfont
    }
    
    //MARK: - Main view touch event
    @objc func touchEventViewTuched(_ sender:UITapGestureRecognizer){
        self.close()
    }
}
