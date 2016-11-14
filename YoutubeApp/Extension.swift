//
//  Extension.swift
//  YoutubeApp
//
//  Created by Oluwatobi Adebiyi on 11/6/16.
//  Copyright © 2016 Oluwatobi Adebiyi. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: AnyObject]()
        for (index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIImageView {
    
    func loadImageUsingURLString(urlString: String) {
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, responses, error) in
            if error != nil {
                print(error!)
                return
            }
            
            // This will wait to finish
            DispatchQueue.main.sync(execute: {
                // Update the UI on the main thread.
                self.image = UIImage(data: data!)
            })
            
            
        }).resume()
    }
}
