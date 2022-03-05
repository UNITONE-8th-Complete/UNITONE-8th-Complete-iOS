//
//  TabBarController.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/05.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    
    //MARK: - Custom Method
    /// makeTabVC - 탭별 아이템 생성하는 함수
    func makeTabVC(vcType: TypeOfViewController, tabBarTitle: String, tabBarImage: String, tabBarSelectedImage: String) -> UIViewController {
        
        let tab = ViewControllerFactory.viewController(for: vcType)
        tab.tabBarItem = UITabBarItem(title: tabBarTitle, image: UIImage(named: tabBarImage), selectedImage: UIImage(named: tabBarSelectedImage))
        return tab
    }
    
    /// setTabBar - 탭바 Setting
    func setTabBar() {
        
        let homeTab = makeTabVC(vcType: .home, tabBarTitle: "Home", tabBarImage: "Home_UnSelected", tabBarSelectedImage: "")
        let cameraTab = makeTabVC(vcType: .add, tabBarTitle: "", tabBarImage: "Add_Default_", tabBarSelectedImage: "")
        let myPageTab = makeTabVC(vcType: .myPage, tabBarTitle: "MyPage", tabBarImage: "My_UnSelected", tabBarSelectedImage: "")
        
        homeTab.tabBarItem.imageInsets = UIEdgeInsets(top: -0.5, left: -0.5, bottom: -0.5, right: -35)
        cameraTab.tabBarItem.imageInsets = UIEdgeInsets(top: -40, left: -0.5, bottom: -0.5, right: -0.5)
        myPageTab.tabBarItem.imageInsets = UIEdgeInsets(top: -0.5, left: -35, bottom: -0.5, right: -0.5)
        
        // 탭바 스타일 설정
        tabBar.frame.size.height = 78
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .black
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3

        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        
        // 탭 구성
        let tabs =  [homeTab, cameraTab, myPageTab]
        
        // VC에 루트로 설정
        self.setViewControllers(tabs, animated: false)
    }
}
