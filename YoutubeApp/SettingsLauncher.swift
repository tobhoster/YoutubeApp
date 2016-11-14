//
//  SettingsLauncher.swift
//  YoutubeApp
//
//  Created by Oluwatobi Adebiyi on 11/10/16.
//  Copyright © 2016 Oluwatobi Adebiyi. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName: String {
    case Cancel = "Cancel"
    case Settings = "Settings"
    case TermsAndPrivacy = "Terms and Privacy"
    case Feedback = "Send Feedback"
    case SwitchAccount = "Switch Accounts"
    case Help = "Help"
}

class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Identifier for Collection View
    let cellId = "cellId"
    
    // Cell Height
    let cellHeight: CGFloat = 50
    
    // Blur
    let blackView = UIView()
    
    // Setting List
    let settings: [Setting] = {
        let settingSettings = Setting(name: .Settings, imageName: "settings.png")
        let privacySettings = Setting(name: .TermsAndPrivacy, imageName: "privacy.png")
        let feedbackSettings = Setting(name: .Feedback, imageName: "feedback.png")
        let supportSettings = Setting(name: .Help, imageName: "support.png")
        let switchAccountSettings = Setting(name: .SwitchAccount, imageName: "switch_accounts.png")
        let cancelSettings = Setting(name: .Cancel, imageName: "cancel.png")
       return [settingSettings, privacySettings, feedbackSettings, supportSettings, switchAccountSettings, cancelSettings]
    }()
    
    // Collection Views to List Settings
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    var homeController: HomeController?
    
    func showSettings() {
        // Show Menu
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SettingsLauncher.handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            // Multiply the setting count to cell Height to get the setting height
            let height: CGFloat = CGFloat(settings.count) * cellHeight
            let y = window.frame.height - height
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    func handleDismiss(setting: Setting) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }, completion: { (completed: Bool) in
            if setting.name != .Cancel {
                self.homeController?.showControllerForSetting(setting: setting)
            }
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
        
        cell.setting = settings[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = self.settings[indexPath.item]
        handleDismiss(setting: setting)
    }
    
    override init() {
        super.init()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
}
