//
//  VideoCell.swift
//  YoutubeApp
//
//  Created by Oluwatobi Adebiyi on 11/7/16.
//  Copyright © 2016 Oluwatobi Adebiyi. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}

class VideoCell: BaseCell {
    
    var video: Video? {
        didSet {
            titleLabel.text = video?.title
            
            // Loading Thumbnail Image URL
            setupThumbnailImage()
            
            // Loading ProfileImage
            setupProfileImage()
            
            
            if let channelName = video?.channel?.name {
                // Create Number Format
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                if let numberOfViews = numberFormatter.string(from: (video?.number_of_views)!) {
                    let subTitleText = "\(channelName) • \(numberOfViews) views • 2 years ago"
                    subTitleLabel.text = subTitleText
                }
                
                
            }
            
            // measure title text
            if let title = video?.title {
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
                
                if estimatedRect.size.height > 20 {
                    titleLabelHeightConstraints?.constant = 44
                } else {
                    titleLabelHeightConstraints?.constant = 20
                }
            }
            
        }
    }
    
    func setupThumbnailImage() {
        if let thumbNailImageName =  video?.thumbnail_image_name {
            thumbNailImageView.loadImageUsingURLString(urlString: thumbNailImageName)
        }
    }
    
    func setupProfileImage() {
        if let profileImageNameUrl =  video?.channel?.profile_image_name {
            userProfileImageView.loadImageUsingURLString(urlString: profileImageNameUrl)
        }
    }
    
    let thumbNailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "taylor_swift_blank_space.jpg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "taylor_swift.jpg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Taylor Swift - Blank Space"
        label.numberOfLines = 2
        return label
    }()
    
    let subTitleLabel: UITextView = {
        let textView = UITextView()
        textView.text = "TaylorSwiftVEVO • 1,836,102,846 views • 2 years ago"
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = UIColor.lightGray
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var titleLabelHeightConstraints: NSLayoutConstraint?
    
    override func setupViews() {
        
        addSubview(thumbNailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumbNailImageView)
        
        // Vertical Constraints
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbNailImageView, userProfileImageView, separatorView)
        
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        
        // TITLE
        // Top Constraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbNailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        // Left Constraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        // Right Constraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbNailImageView, attribute: .right, multiplier: 1, constant: 0))
        
        // Height Constraints
        titleLabelHeightConstraints = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)
        addConstraint(titleLabelHeightConstraints!)
        
        // SUBTITLE
        // Top Constraints
        addConstraint(NSLayoutConstraint(item: subTitleLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        // Left Constraints
        addConstraint(NSLayoutConstraint(item: subTitleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        // Right Constraints
        addConstraint(NSLayoutConstraint(item: subTitleLabel, attribute: .right, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1, constant: 0))
        
        // Height Constraints
        addConstraint(NSLayoutConstraint(item: subTitleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
    }
}
