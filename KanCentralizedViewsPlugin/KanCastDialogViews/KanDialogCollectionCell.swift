//
//  CastCustomCell.swift
//  ZappGeneralPluginChromecast
//
//  Created by Avi Levin on 14/03/2019.
//

import UIKit

class KanDialogCollectionCell: UICollectionViewCell {
    
   
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.layer.cornerRadius = 35.0
        // customizeText
        customizeText()
    }
    
    override var isSelected: Bool {
        willSet(newValue) {
            //Briefly fade the cell on selection
            UIView.animate(withDuration: 0.1,
                           animations: {
                            //Fade-in
                            self.alpha = 0.2
            }) { (completed) in
                UIView.animate(withDuration: 0.1,
                               animations: {
                                //Fade-out
                                self.alpha = 1
                })
            }
        }
    }
    
    //MARK: - Customise Text
    func customizeText() {
        //Title setup
        let labelFontSize = CGFloat(14)
        let labelfont = UIFont(name: "SimplerPro_V3-Regular", size: labelFontSize)
        self.label?.font = labelfont
    }
}
