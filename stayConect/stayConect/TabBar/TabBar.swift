//
//  TabBar.swift
//  stayConect
//
//  Created by irakli kharshiladze on 28.11.24.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
        configureTabBarAppearance()
        self.delegate = self
    }
    
    private func configureTabs() {
        let vc1 = HomePageViewController()
        let vc2 = LeaderboardViewController()
        let vc3 = ProfileViewController()
        
        vc1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: TabBarIcons.home.rawValue)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: TabBarIcons.homeActive.rawValue)?.withRenderingMode(.alwaysOriginal))
        vc2.tabBarItem = UITabBarItem(title: "Leaderboard", image: UIImage(named: TabBarIcons.leaderboard.rawValue)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: TabBarIcons.leaderboardActive.rawValue)?.withRenderingMode(.alwaysOriginal))
        vc3.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: TabBarIcons.profile.rawValue)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: TabBarIcons.profileActive.rawValue)?.withRenderingMode(.alwaysOriginal))
        
        setViewControllers([vc1, vc2, vc3], animated: true)
        self.tabBar.isTranslucent = false
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: "#F3F2F1")
        
        let activeAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: "#4F46E5") ?? UIColor.systemBlue,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        
        let inactiveAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: "#5E6366") ?? UIColor.gray,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = inactiveAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = activeAttributes
        
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = true
    }
}
