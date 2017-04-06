//
//  MenuBar.swift
//  YoutubeApp
//
//  Created by Oluwatobi Adebiyi on 11/7/16.
//  Copyright © 2016 Oluwatobi Adebiyi. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let menuId = "menuId"
    
    let numberOfBar = 4
    
    let imageNames = ["home.png", "trending.png", "subscription.png", "profile.png"]
    
    var homeController: HomeController?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 205, green: 32, blue: 31, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: menuId)
        
        addSubview(collectionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        // Hack
        let selectedIndex = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndex as IndexPath, animated: false, scrollPosition: [])
        
        setupHorizontalBar()
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    // When Menu bar selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let x = CGFloat(indexPath.item) * frame.width / CGFloat(numberOfBar)
        
        horizontalBarLeftAnchorConstraint?.constant = x
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        
        homeController?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
    // Number of Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfBar
    }
    
    // Item Tab
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuId, for: indexPath) as! MenuCell
        
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.imageView.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13, alpha: 1)
        
        return cell
    }
    
    // Tab Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(numberOfBar), height: frame.height)
    }
    
    // Notes: minimumInteritemSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MenuCell: BaseCell {
    
    let imageView: UIImageView  = {
        let image = UIImageView()
        image.image = UIImage(named: "home.png")?.withRenderingMode(.alwaysTemplate)
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13, alpha: 1)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override var isHighlighted: Bool{
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13, alpha: 1)
        }
    }
    
    override var isSelected: Bool{
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13, alpha: 1)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        
        addConstraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
