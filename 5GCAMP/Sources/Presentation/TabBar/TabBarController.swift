//
//  TabBarController.swift
//  5GCAMP
//
//  Created by WONJI HA on 11/6/24.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // 이전 선택된 탭의 인덱스
    var previousSelectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = 1
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedIndex = tabBarController.selectedIndex
        
        // 이전에 선택된 탭의 인덱스를 저장하는 속성 추가
        if selectedIndex == self.previousSelectedIndex {
            // 같은 탭이 다시 선택되었을 때
            if let navigationController = viewController as? UINavigationController {
                // 네비게이션 컨트롤러인 경우
                if let topViewController = navigationController.topViewController as? TabBarProtocol {
                    topViewController.reloadView()
                }
            } else if let reloadableViewController = viewController as? TabBarProtocol {
                // 일반 뷰 컨트롤러인 경우
                reloadableViewController.reloadView()
            }
            print("현재 선택된 탭 번호: ", selectedIndex)
        }
        
        // 현재 선택된 인덱스를 이전 인덱스로 저장
        self.previousSelectedIndex = selectedIndex
        print("이전 선택된 인덱스 출력 : ",previousSelectedIndex)
    }
}
