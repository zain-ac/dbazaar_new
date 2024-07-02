//
//  Storyboards.swift
//  RGB
//
//  Created by Usama on 19/11/2021.
//

import Foundation
import UIKit

enum Boards: String {
    case main = "Main"
 
    var stortBoard: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }
}

struct StoryboardScene {
    enum LaunchScreen: StoryboardSceneType {
        static let storyboardName = "LaunchScreen"
    }
    
    enum Main: String, StoryboardSceneType {
        case none

        static let storyboardName = Boards.main.rawValue
        
//        static func instantiateDrawerMenuViewController() -> DrawerMenuViewController {
//            return DrawerMenuViewController.getVC(.main)
//        }
    }
    
}


