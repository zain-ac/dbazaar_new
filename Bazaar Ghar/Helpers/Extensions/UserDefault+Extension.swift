//
//  UserDefault+Extension.swift
//  BLELight
//
//  Created by Usama on 01/11/2021.
//  Copyright © 2021 Aquatic AV. All rights reserved.
//

import Foundation
import UIKit

extension UserDefaults {
    func decode<T : Codable>(for type: T.Type, using key : String) -> T? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        return try? PropertyListDecoder().decode(type, from: data)
    }
    
    func encode<T : Codable>(for type: T?, using key : String) {
        let encodedData = try? PropertyListEncoder().encode(type)
        UserDefaults.standard.set(encodedData, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
class AppDefault {
    
    static let shared = UserDefaults.standard
    
    //MARK:- Reset UserDefault
    public static func resetUserDefault(){
        let dictionary = shared.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            
            //FIXME: I omit deleting of following keys.
            if (key == "fcmToken" ||
                key == "deviceToken" ||
                key == "email" ||
                key == "password"
                ) {
                //Don't Remove These keys
            }else {
                shared.removeObject(forKey: key)
            }
        }
        print("UserDefault: \(shared.dictionaryRepresentation())")
    }
    
        public static var accessToken: String {
            get {
                return shared.string(forKey: "token") ?? ""
            }
            set {
                shared.set(newValue, forKey: "token")
            }
        }
    public static var socketId: String {
            get {
                return shared.string(forKey: "socketId") ?? ""
            }
            set {
                shared.set(newValue, forKey: "socketId")
            }
        }
    public static var miscid: String {
            get {
                return shared.string(forKey: "miscid") ?? ""
            }
            set {
                shared.set(newValue, forKey: "miscid")
            }
        }
    public static var facetFilters: [TypeSenseResult]? {
        get{
          return shared.decode(for: [TypeSenseResult].self, using: "facetFilters")
        }
        set{
          shared.encode(for: newValue, using: "facetFilters")
        }
      }
    public static var brandname: String {
        get {
            return shared.string(forKey: "brandname") ?? ""
        }
        set {
            shared.set(newValue, forKey: "brandname")
        }
    }
    public static var wishlistproduct: [Product]? {
        get{
          return shared.decode(for: [Product].self, using: "wishlistproduct")
        }
        set{
          shared.encode(for: newValue, using: "wishlistproduct")
        }
      }
    public static var facetFilterArray: [TypeSenseCount]? {
            get{
                return shared.decode(for:  [TypeSenseCount].self, using: "facetFilterArray")
            }
            set{
                shared.encode(for: newValue, using: "facetFilterArray")
            }
        }
        
    
    public static var refreshToken: String {
        get {
            return shared.string(forKey: "refreshToken") ?? ""
        }
        set {
            shared.set(newValue, forKey: "refreshToken")
        }
    }
    public static var variantSlug: String {
        get {
            return shared.string(forKey: "variantSlug") ?? ""
        }
        set {
            shared.set(newValue, forKey: "variantSlug")
        }
    }
    public static var userId: String? {
        get {
            return shared.string(forKey: "user_id")
        }
        set {
            shared.set(newValue, forKey: "user_id")
        }
    }
    public static var attribute1: String? {
        get {
            return shared.string(forKey: "attribute1")
        }
        set {
            shared.set(newValue, forKey: "attribute1")
        }
    }
    public static var attribute2: String? {
        get {
            return shared.string(forKey: "attribute2")
        }
        set {
            shared.set(newValue, forKey: "attribute2")
        }
    }
    public static var attribute3: String? {
        get {
            return shared.string(forKey: "attribute3")
        }
        set {
            shared.set(newValue, forKey: "attribute3")
        }
    }
    public static var cartId: String? {
        get {
            return shared.string(forKey: "cartId")
        }
        set {
            shared.set(newValue, forKey: "cartId")
        }
    }

    public static var email: String {
        get {
            return shared.string(forKey: "email") ?? ""
        }
        set {
            shared.set(newValue, forKey: "email")
        }
    }
    public static var islogin: Bool {
        get {
            return shared.bool(forKey: "islogin")
        }
        set {
            shared.set(newValue, forKey: "islogin")
        }
    }
    public static var iscomefaqs: Bool {
        get {
            return shared.bool(forKey: "iscomefaqs")
        }
        set {
            shared.set(newValue, forKey: "iscomefaqs")
        }
    }
    public static var languages: String {
        get {
            return shared.string(forKey: "languages") ?? "en"
        }
        set {
            shared.set(newValue, forKey: "languages")
        }
    }
    public static var FcmToken: String? {
        get {
            return shared.string(forKey: "FcmToken")
        }
        set {
            shared.set(newValue, forKey: "FcmToken")
        }
    }
//    public static var storeFlag: Bool {
//        get {
//            return shared.bool(forKey: "storeFlag")
//        }
//        set {
//            shared.set(newValue, forKey: "storeFlag")
//        }
//    }
    public static var Bannerdata: [BannerResponse]? {
        get{
            return shared.decode(for: [BannerResponse].self, using: "Bannerdata")
        }
        set{
            shared.encode(for: newValue, using: "Bannerdata")
        }
    }
    public static var getrandomproductapiModel: [Product]? {
        get{
            return shared.decode(for: [Product].self, using: "Product")
        }
        set{
            shared.encode(for: newValue, using: "Product")
        }
    }
    public static var CategoriesResponsedata: [CategoriesResponse]? {
        get{
            return shared.decode(for: [CategoriesResponse].self, using: "CategoriesResponsedata")
        }
        set{
            shared.encode(for: newValue, using: "CategoriesResponsedata")
        }
    }
    public static var getAllCategoriesResponsedata: [getAllCategoryResponse]? {
        get{
            return shared.decode(for: [getAllCategoryResponse].self, using: "getAllCategoriesResponsedata")
        }
        set{
            shared.encode(for: newValue, using: "getAllCategoriesResponsedata")
        }
    }
    public static var productcategoriesApi: [PChat]? {
        get{
            return shared.decode(for: [PChat].self, using: "PChat")
        }
        set{
            shared.encode(for: newValue, using: "PChat")
        }
    }
    public static var randonproduct: [PChat]? {
        get{
            return shared.decode(for: [PChat].self, using: "RandomnProductResponse")
        }
        set{
            shared.encode(for: newValue, using: "RandomnProductResponse")
        }
    }
    public static var groupbydealdata: [GroupByResult]? {
        get{
            return shared.decode(for: [GroupByResult].self, using: "GroupByDealsResponse")
        }
        set{
            shared.encode(for: newValue, using: "GroupByDealsResponse")
        }
    }
    public static var uid: String? {
        get {
            return shared.string(forKey: "uid")
        }
        set {
            shared.set(newValue, forKey: "uid")
        }
    }
    public static var currentUser: CurrentUser? {
        get{
            return shared.decode(for: CurrentUser.self, using: "CurrentUser")
        }
        set{
            shared.encode(for: newValue, using: "CurrentUser")
        }
    }
    public static var displayName: String {
        get {
            return shared.string(forKey: "displayname") ?? ""
        }
        set {
            shared.set(newValue, forKey: "displayname")
        }
    }
 
  
 
//    //MARK:- Show Call Permission Alert
//    public static var isCallAllowed: Bool {
//        get {
//            return shared.bool(forKey: "isCallAllowed")
//        }
//        set {
//            shared.set(newValue, forKey: "isCallAllowed")
//        }
//    }
//    //MARK:- Job ID
//    public static var jobID: Int {
//        get {
//            return shared.integer(forKey: "job_id")
//        }
//        set {
//            shared.set(newValue, forKey: "job_id")
//        }
//    }
//    //MARK:- Independent Contracter Agreement
//    public static var isAgreedICA: Bool {
//        get {
//            return shared.bool(forKey: "ICA")
//        }
//        set {
//            shared.set(newValue, forKey: "ICA")
//        }
//    }
//    //MARK:- DeviceToken
//    public static var deviceToken: String {
//        get{
//            if let token = shared.string(forKey: "deviceToken") {
//                return token
//            }else{
//                return ""
//            }
//        }
//        set{
//            shared.set(newValue, forKey: "deviceToken")
//        }
//    }
//    //MARK:- fcmToken
//    public static var fcmToken: String {
//        get{
//            if let token = shared.string(forKey: "fcmToken") {
//                return token
//            }else{
//                return ""
//            }
//        }
//        set{
//            shared.set(newValue, forKey: "fcmToken")
//        }
//    }
//    //MARK:- email
//    public static var email: String {
//        get{
//            if let token = shared.string(forKey: "email") {
//                return token
//            }else{
//                return ""
//            }
//        }
//        set{
//            shared.set(newValue, forKey: "email")
//        }
//    }
//    //MARK:- password
//    public static var password: String {
//        get{
//            if let token = shared.string(forKey: "password") {
//                return token
//            }else{
//                return ""
//            }
//        }
//        set{
//            shared.set(newValue, forKey: "password")
//        }
//    }
//
//    public static var userType: Int {
//        get{
//            return shared.integer(forKey: "UserType")
//        }
//        set{
//            shared.set(newValue, forKey: "UserType")
//        }
//    }
//    public static var allLanguages: [Language] {
//        get{
//            return shared.decode(for: [Language].self, using: "allLanguages")!
//        }
//        set{
//            shared.encode(for: newValue, using: "allLanguages")
//        }
//    }
//    public static var isRemember: Bool?{
//        get{
//            if let isRemember = shared.bool(forKey: "isRemember") as Bool?{
//                return isRemember
//            }else{
//                return nil
//            }
//        }
//        set{
//            shared.set(newValue, forKey: "isRemember")
//        }
//    }
//    public static var recentJobId: Int? {
//        get {
//            if let id = shared.integer(forKey: "recentJobId") as Int? {
//                return id
//            }else{
//                return nil
//            }
//        }
//        set{
//            shared.setValue(newValue, forKey: "recentJobId")
//        }
//    }
//
}
