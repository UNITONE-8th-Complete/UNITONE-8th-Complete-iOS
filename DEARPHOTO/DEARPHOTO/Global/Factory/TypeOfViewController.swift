//
//  TypeOfViewController.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/05.
//

import Foundation

enum TypeOfViewController {
    case tabBar
    case home
    case camera
    case myPage
}

extension TypeOfViewController {
    func storyboardRepresentation() -> StoryboardRepresentation {
        switch self {
        case .tabBar:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.tabBarSB, storyboardId: Identifiers.tabBarController)
        case .home:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.homeSB, storyboardId: Identifiers.homeVC)
        case .camera:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.cameraSB, storyboardId: Identifiers.cameraVC)
        case .myPage:
            return StoryboardRepresentation(bundle: nil, storyboardName: Identifiers.myPageSB, storyboardId: Identifiers.myPageVC)
        }
    }
}

