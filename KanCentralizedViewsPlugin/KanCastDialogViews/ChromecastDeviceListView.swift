//
//  ChromecastDeviceListView.swift
//  ZappGeneralPluginChromecast
//
//  Created by Avi Levin on 18/03/2019.
//

import UIKit
import GoogleCast

class ChromecastDeviceListView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let minimumInteritemSpacing = 10
    let KanDialogCollectionCellIdentifier = "KanDialogCollectionCell"
    var discoveryManager:GCKDiscoveryManager!
    var devices:Array<GCKDevice>!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        discoveryManager = GCKCastContext.sharedInstance().discoveryManager
        //collectionInit
        collectionInit()
        
        //Hide scrool indicatior
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(discoveryManager.deviceCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KanDialogCollectionCell", for: indexPath) as? KanDialogCollectionCell else {
            return UICollectionViewCell()
        }
        
        let device = discoveryManager.device(at: UInt(indexPath.item))
        cell.label.text = device.friendlyName ?? ""
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //do someting
        
        let device = discoveryManager.device(at: UInt(indexPath.item))
        GCKCastContext.sharedInstance().sessionManager.startSession(with: device)
    }
    
    // MARK: - Collection Init
    func collectionInit() {
        let bundle = Bundle(for: KanDialogView.self)
        let kanCollectionCellNib = UINib(nibName: "KanDialogCollectionCell", bundle: bundle)
        
        collectionView.register(kanCollectionCellNib,
                                forCellWithReuseIdentifier: KanDialogCollectionCellIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let cellWidth = getCellHeight(collectionView)
        let cellCount = CGFloat(collectionView.numberOfItems(inSection: 0))
        let cellSpacing = CGFloat(minimumInteritemSpacing)
        
        let totalCellWidth = cellWidth * cellCount
        let totalSpacingWidth = cellSpacing * (cellCount - 1)
        
        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        if leftInset <= 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minimumInteritemSpacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = getCellHeight(collectionView)
        
        return CGSize(width: height, height: height)
    }
    
    private func getCellHeight(_ collectionView: UICollectionView) -> CGFloat {
        return collectionView.bounds.height
    }
}
