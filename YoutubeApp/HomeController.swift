//
//  ViewController.swift
//  YoutubeApp
//
//  Created by Oluwatobi Adebiyi on 11/5/16.
//  Copyright © 2016 Oluwatobi Adebiyi. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    private let trendingId = "trendingId"
    private let subscriptionId = "subscriptionId"
    
    // Lists of title
    let titles = ["Home", "Trending", "Subscriptions", "Account"]

    // View Loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        setupCollectionViews()
        
        setupMenuBar()
        setupNavBarButtons()
    }
    
    func setupCollectionViews() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingId)
        collectionView?.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionId)
                
        // Pushing the Collection View 50px down, to align it to the Menu Bar
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        collectionView?.isPagingEnabled = true
    }
    
    // Setup Navigation Bar Buttons
    func setupNavBarButtons() {
        let searchImage = UIImage(named: "search.png")
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(HomeController.handleSearch))
        
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "more.png"), style: .plain, target: self, action: #selector(HomeController.handleMore))
        
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    func handleSearch() {
        // Handles Search
        scrollToMenuIndex(menuIndex: 2)
    }
    
    func setTitleForIndex(index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = titles[index]
        }
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        
        setTitleForIndex(index: menuIndex)
    }
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        launcher.homeController = self
        return launcher
    }()
    
    // Handles More - Views Settings
    func handleMore() {
        // Show more
        settingsLauncher.showSettings()
    }
    
    // Show a Dummy (View Controller) for Setting
    func showControllerForSetting(setting: Setting) {
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.white
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    // Init Menu and Create a Menu bar
    lazy var menuBar: MenuBar = {
       let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    // SetUp Views for Menu Bar
    private func setupMenuBar() {
        
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 205, green: 32, blue: 31, alpha: 1)
        view.addSubview(redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
         menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // These function sets the menuBar horizontalBarLeftAnchor - the little white bar
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / CGFloat(menuBar.numberOfBar)
    }
    
    // Using scrollView to set the selectedItem in the MenuBar - setTitle`
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
        
        setTitleForIndex(index: Int(index))
    }
    
    // Set the Number of Items in the Collection View
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuBar.numberOfBar
    }
    
    // View Holder for the Collection View
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier: String
        
        if indexPath.item == 1 {
            identifier = trendingId
        } else if indexPath.item == 2 {
            identifier = subscriptionId
        } else {
            identifier = cellId
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        return cell
    }
    
    // Set the Collection View Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
}




