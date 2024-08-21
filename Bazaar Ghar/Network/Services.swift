//
//  Services.swift
//  RGB
//
//  Created by usamaghalzai on 15/11/2021.
//  Copyright © 2021 usamaghalzai. All rights reserved.
//

import Foundation
import Moya

enum Services {
    //MARK: - AUTHENTICATION
    case banner
    case categories(id:String)
    case cartWalletMethod(wallet:Bool)
    case productcategories(cat:String,cat2:String,cat3:String,cat4:String,cat5:String)
    case randomproduct
    case productcategoriesdetails(slug: String)
    case getAllProductsByCategories(limit:Int,page:Int,sortBy:String,category:String,active:Bool)
    case getAllProductsByCategoriesbyid(limit:Int,page:Int,sortBy:String,category:String,active:Bool)
    case loginwithgoogle(googleId:String,displayName:String)
    case loginwithOtp(googleId:String,displayName:String)
    case loginWithGoogleVerification(googleId:String,displayName:String)
    case getVideoToken(room:String,token:String)
    case searchproduct(name:String,limit:Int,page:Int,value:String)
    case searchstore(market:String,name:String,limit:Int,page:Int,value:String,city:String)
    case searchVideo(name:String,value:String,limit:Int,catId:[String])
    case getcartItems
    case addItemtoCart(product:String,quantity:Int)
    case deletePackage(productId:String,_package:String)
    case deleteCart
    case cities
    case getaddress
    case placeOrder(cartId:String)
    case myOrder(limit:Int,sortBy:String)
    case typeSenseApi(val:String,txt:String,facet_by:String)
    case getComments(scheduleId:String)
    case shopChinarandomproduct(origin:String)





    case addAddress(fullname:String,phone:String,province:String,city:String,city_code:String,address:String,addressType:String,localType:String,zipCode:String,addressLine_2:String,country:String,area:String)
    case adressdelete(addressId: String)
    case wishList
    case addwishList(product:String)
    case defaultAdrress(addressId:String,cartId:String)
    case updateAddress(addressId:String,fullname:String,phone:String,province:String,city:String,city_code:String,address:String,addressType:String,localType:String,zipCode:String,addressLine_2:String,country:String)
    case personaldetail(fullname:String,email:String,userid:String)
    case wishListRemove(product:String)
    case getStreamingVideos(limit: Int,page:Int,categories:[String],userId:String,city:String)
    case refreshToken(refreshToken:String)
    case getvidoebyproductIds(productIds:[String])
    case groupByDeals(limit:Int,page:Int)

    case collectionDataApi(limit:Int,page:Int,collectionId:String)
    case chinesebell(sellerId:String,brandName:String,description:String)
    case pushnotificationapi
    case deleteAccount(userId:String, status:String)
    case appleLogin(token:String)
    case report(comment:String,videoId:String)
    case savelike(token:String,scheduleId:String,userId:String)
    case deletelike(token:String,scheduleId:String,userId:String,likeId:String)
    case getLike(scheduleId:String,userId:String)
    case followStore(storeId:String,web:Bool)
    case followcheck(storeId:String)
    case unfollowstore(storeId:String)
    case getLiveStream
    case getAllCategories
    case getSellerDetail(id:String)
    case moreFrom(category:String,user:String)
    case cardpaymentApi(token:String,amount:Int,currency:String,cartId:String)
    case newishlist(product:String)
    case shopchinaStreamingVideo(origin:String)
    case getprovince(countryCode:String,language:String,checkCache:Bool)
    
    case shopchinaproductcategories(cat:String,cat2:String,cat3:String,cat4:String,cat5:String,origin:String)

    
}

extension Services: TargetType, AccessTokenAuthorizable {
    
    var baseURL: URL {
        switch self {
        case .searchproduct:
            return AppConstants.API.baseURLSearchProduct
        case .searchVideo, .getStreamingVideos , .getVideoToken,.shopchinaStreamingVideo:
            return AppConstants.API.baseURLVideoStreaming
        case .report, .getComments, .getLiveStream,.savelike, .deletelike, .getLike:
            return AppConstants.API.baseURLVideoStreamingV1
        case .chinesebell:
            return AppConstants.API.baseURLChatNotification
        case .typeSenseApi:
             return AppConstants.API.typeSenseUrl
      
        default:
            return AppConstants.API.baseURL
        }
        
    }
    
    var path: String {
        switch self {
        case  .getVideoToken:
                    return "videoCall/token" 
        case  .cartWalletMethod:
                    return "cart/payment-method"
    
        case let .cardpaymentApi(_,_,_,_):
                  return "payment/order-detail"
        case  .getComments:
                    return "getbyscheduleId"
        case let .followcheck(storeId):
                    return "follow/\(storeId)"
        case .banner:
            return "banner-set/all/banner"
        case let .categories(id):
            if id == "" {
                return "categories"
            }else {
                return "categories/\(id)"
            }
        case .getAllCategories:
            return "categories/getAllCategories"
        case .productcategories(_,_,_,_,_) :
            return "products/categories"
        case .shopchinaproductcategories(_,_,_,_,_,_):
            return "products/categories"
        case .randomproduct:
            return "products/getRandomProducts"
        case .shopChinarandomproduct:
            return "products/getRandomProducts"
        case let .productcategoriesdetails(slug):
            return "products/getProductBySlug/variants/\(slug)"
        case  .getAllProductsByCategories:
            return "products/categorySlug/all"
        case  .getAllProductsByCategoriesbyid:
            return "products/getAllProducts"
        case .loginwithgoogle:
            return "auth/google-login"
        case  .searchproduct:
            return "products"
        case .searchstore:
            return "sellerDetail"
        case .searchVideo:
            return "getrecordedvideo"
        case .getcartItems:
            return "cart"
        case .addItemtoCart:
            return "cart"
        case .deleteCart:
            return "cart" 
        case .cities:
            return "address/cities"
        case .deletePackage:
            return "cart"
        case .getaddress:
            return "address"
        case .myOrder:
            return "order/customerOrders"
        case .placeOrder:
            return "orderDetail"
        case .addAddress:
            return "address"
        case let .adressdelete(addressId):
            return "address/\(addressId)"
            
        case .addwishList:
            return "wishList/new"
        case .wishListRemove:
            return "wishList/remove"
        case .wishList:
            return "wishList"
        case .loginwithOtp:
            return "auth/phone-code"
        case .followStore:
            return "follow"
        case .loginWithGoogleVerification:
            return "auth/phone-verify"

        case .defaultAdrress:
            return "auth/default-address"
        case let .updateAddress(addressId, fullname, phone, province, city, city_code, _, addressType, localType, zipCode, addressLine_2,country):
            return "address/\(addressId)"
        case let .personaldetail(_, _, userid):
            return "users/\(userid)"
        case .getStreamingVideos:
            return "getrecordedvideo"
        case .refreshToken:
            return "auth/refresh-tokens"
        case .getvidoebyproductIds:
            return "products/getbyproductIds"
        case .groupByDeals:
            return "group-buy/deals"
        case let .collectionDataApi( _ , _, collectionId):
            return "collection/\(collectionId)"
        case .chinesebell:
            return "notification/chinese-bell"
        case .pushnotificationapi:
            return "push-notification"
        case let .deleteAccount(userId,status):
            return "users/status/\(userId)"
        case  .appleLogin:
            return "auth/apple-login"
        case .report:
            return "report"
        case .savelike:
            return "savelike"
        case .deletelike:
            return "deletelike"
        case .getLike:
            return "userlike" 
        case let .unfollowstore(storeId):
            return "follow/unfollow/\(storeId)"
        case .getLiveStream:
            return "getslotinuse"
        case let .getSellerDetail(id):
            return "sellerDetail/seller/\(id)"
        case .moreFrom:
            return "products/getAllProducts"
        case .newishlist:
              return "wishList/new"
        case .shopchinaStreamingVideo:
            return "getrecordedvideo"
        case .getprovince:
            return "shop-china/address"
            //        case let .auctionById(auctionid):
            //            return "main/v1/auctions/\(auctionid)"
        default:
            return ""
            
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .banner , .categories, .getcartItems, .productcategories, .randomproduct, .productcategoriesdetails, .getAllProductsByCategories, .searchproduct, .searchstore, .searchVideo,.getAllProductsByCategoriesbyid, .getStreamingVideos, .wishList , .myOrder , .cities, .getaddress,.collectionDataApi, .groupByDeals , .followcheck, .getLiveStream, .getAllCategories,.getSellerDetail,.moreFrom,.shopchinaStreamingVideo,.shopChinarandomproduct,.getprovince,.shopchinaproductcategories:
            return .get
     
        case .adressdelete , .deleteCart:
            return .delete
    
        case .updateAddress, .personaldetail ,  .deletePackage,.deleteAccount:
            return .patch
            
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .banner, .categories, .getcartItems, .randomproduct, .getaddress,.getAllCategories:
            return .requestPlain
        case let .shopChinarandomproduct(origin):
            return .requestParameters(parameters: ["origin": origin], encoding: URLEncoding.default)

        case let .productcategories(cat, cat2, cat3, cat4, cat5):
            if cat == "" {
                return .requestPlain

            }else {
                if cat != "" && cat2 == "" {
                    return .requestParameters(parameters: ["categories[]": cat], encoding: URLEncoding.default)
                }else if cat != "" && cat2 != "" && cat3 != "" && cat4 == "" {
                    return .requestParameters(parameters: ["categories[]": cat,"categories[1]": cat2,"categories[2]": cat3], encoding: URLEncoding.default)
                }else {
                    return .requestParameters(parameters: ["categories[]": cat,"categories[1]": cat2,"categories[2]": cat3,"categories[3]": cat4], encoding: URLEncoding.default)
                }
            }
            
        case let .shopchinaproductcategories(cat, cat2, cat3, cat4, cat5,origin):
            return .requestParameters(parameters: ["categories[]": cat,"categories[1]": cat2,"categories[2]": cat3,"origin":origin], encoding: URLEncoding.default)
            
        case let .getAllProductsByCategories(limit,page,sortBy,category, _):
            return .requestParameters(parameters: ["limit": limit,"page": page,"sortBy": sortBy,"categorySlug": category], encoding: URLEncoding.default) 
        case let .typeSenseApi(val,str,facet_by):
              let parameters: [String: Any] = [
                "searches": [
                  [
                    "query_by": "productName",
                    "highlight_full_fields": "productName",
        //            "collection": "db_live_products",
                    "collection": "bg_stage_products",
                    "q": str,
        //            "facet_by": "lvl0,color,brandName,averageRating,price,size,style",
                    "facet_by": facet_by,
                  "filter_by": val,
                    "max_facet_values": 250,
                    "page": 1,
                    "per_page": 20
                  ]
                ]
              ]
              return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .cardpaymentApi(token,amount,currency,cardid):
               let parameters: [String: Any] = [
                 "source": [
                  "type": "token",
                  "token": token
                 ],
                 "amount": amount,
                 "currency": currency,
                 "customer": [
                  "email": AppDefault.currentUser?.email
                 ]
                ]
              return .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: JSONEncoding.default, urlParameters: ["cartId": cardid])
        case let .myOrder(limit,sortBy):
            return .requestParameters(parameters: ["limit": limit,"sortBy":sortBy], encoding: URLEncoding.default)
    
        case let .getAllProductsByCategoriesbyid(limit,page,sortBy,category, _):
            return .requestParameters(parameters: ["limit": limit,"page": page,"sortBy": sortBy,"user": category], encoding: URLEncoding.default)
        case let .loginwithgoogle(googleId,displayName):
            return .requestParameters(parameters: ["googleId": googleId,"displayName": displayName], encoding: JSONEncoding.default)
        case let .cartWalletMethod(wallet):
            return .requestParameters(parameters: ["wallet": wallet], encoding: JSONEncoding.default)
        case let .loginwithOtp(googleId, _):
            return .requestParameters(parameters: ["phoneNumber": googleId], encoding: JSONEncoding.default)  
        case let .getComments(scheduleId):
            return .requestParameters(parameters: ["scheduleId": scheduleId], encoding: JSONEncoding.default)
            
        case let .loginWithGoogleVerification(googleId, id):
            return .requestParameters(parameters: ["phoneToken": googleId,"hash": id], encoding: JSONEncoding.default)
        case let .defaultAdrress(addressId, cartId):
            return .requestParameters(parameters: ["addressId": addressId,"cartId": cartId], encoding: JSONEncoding.default)
        case let  .getVideoToken(room , token):
                    return .requestParameters(parameters: ["room": room,"token": token], encoding: JSONEncoding.default) 
        case let  .followStore(storeId , web):
                    return .requestParameters(parameters: ["followed": storeId,"web": web], encoding: JSONEncoding.default)
        case let .searchproduct(name,limit,page,value):
            
            if(value == ""){
                return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.default)
            }else{
                return .requestParameters(parameters: ["name": name,"limit": limit,"page": page,"value":value], encoding: URLEncoding.default)
            }
    
        case let .placeOrder(cartId):
            return .requestParameters(parameters: ["cart": cartId], encoding: JSONEncoding.default)
   
            
        case let .searchstore(market,name,limit,page,value,city):
            return .requestParameters(parameters: ["market":market,"name": name,"limit": limit,"page": page,"value":value,"city": city], encoding: URLEncoding.default)
        case let .searchVideo(name,value,limit,catId):
            if(value == ""){
                return .requestParameters(parameters: ["name": name,"limit": limit,"page": 1,"categories":catId], encoding: URLEncoding.default)
            }else{
                return .requestParameters(parameters: ["name": name,"value":value,"limit": limit,"page": 1,"categories":catId], encoding: URLEncoding.default)
            }
        case let .getStreamingVideos(limit,page,categories,userId,city):
            if(categories == [] && userId == "" && city == ""){
                return .requestParameters(parameters: ["limit":limit,"page":page], encoding: URLEncoding.default)
            }else if categories == [] && userId == "" && city != ""{
                return .requestParameters(parameters: ["limit":limit,"page":page,"city":city], encoding: URLEncoding.default)
            }else if(userId != ""){
                return .requestParameters(parameters: ["limit":limit,"page":page,"userId":userId], encoding: URLEncoding.default)
            }else{
                return .requestParameters(parameters: ["limit":limit,"page":page,"categories":categories], encoding: URLEncoding.default)
            }
        case let .addItemtoCart(product: product, quantity: quantity):
            return .requestParameters(parameters: ["product": product,"quantity":quantity], encoding: JSONEncoding.default)
        case let .deletePackage(productId: productId, _package: _package):
            return .requestParameters(parameters: ["product": productId,"_package":_package], encoding: JSONEncoding.default)
            
        case let .addAddress(fullname,phone,province,city,city_code,address,addressType,localType,zipCode,addressLine_2,country,area):
            return .requestParameters(parameters: ["fullname": fullname,"phone":phone,"province": province,"city": city,"city_code": city_code,"address": address,"addressType": addressType,"localType": localType,"zipCode": zipCode,"addressLine_2": addressLine_2,"country":country,"area":area], encoding: JSONEncoding.default)
        case let .updateAddress(addressId, fullname, phone, province, city, city_code, address, addressType, localType, zipCode, addressLine_2,country):
            return .requestParameters(parameters: ["fullname": fullname,"phone":phone,"province": province,"city": city,"city_code": city_code,"address": address,"addressType": addressType,"localType": localType,"zipCode": zipCode,"addressLine_2": addressLine_2,"country":country], encoding: JSONEncoding.default)
        case let .addwishList(product):
            return .requestParameters(parameters: ["product": product], encoding: JSONEncoding.default)
        case let .wishListRemove(product):
            return .requestParameters(parameters: ["productId": product], encoding: JSONEncoding.default)
        case let .personaldetail(fullname, email, id):
            if email == ""  || email == AppDefault.currentUser?.email {
                return .requestParameters(parameters: ["fullname": fullname], encoding: JSONEncoding.default)
            }else {
                return .requestParameters(parameters: ["fullname": fullname,"email":email], encoding: JSONEncoding.default)
            }
        case let .refreshToken(refreshToken):
            return .requestParameters(parameters: ["refreshToken": refreshToken], encoding: JSONEncoding.default)
        case let .getvidoebyproductIds(productIds):
            return .requestParameters(parameters: ["productIds": productIds], encoding: JSONEncoding.default)
        case let .groupByDeals(limit,page):
            return .requestParameters(parameters: ["limit": limit,"page":page], encoding: URLEncoding.default)
        case let .collectionDataApi(limit: limit, page: page, collectionId: _):
            return .requestParameters(parameters: ["limit": limit,"page":page], encoding: URLEncoding.default)
        case let .chinesebell(sellerId, brandName, description):
            return .requestParameters(parameters: ["sellerId": sellerId,"brandName": brandName,"description": description], encoding: JSONEncoding.default)
        case  .pushnotificationapi:
            return .requestParameters(parameters: ["token": AppDefault.FcmToken ?? "","userId": AppDefault.currentUser?.id ?? "","app": "customer"], encoding: JSONEncoding.default)
        case let .deleteAccount(userId, status):
            return .requestParameters(parameters: ["status": status], encoding: JSONEncoding.default)
        case let .appleLogin(token):
            return .requestParameters(parameters: ["token": token], encoding: JSONEncoding.default)
        case let .report(comment,videoId):
            return .requestParameters(parameters: ["comment": comment,"videoId":videoId], encoding: JSONEncoding.default)
        case let .savelike(token, scheduleId, userId):
            return .requestParameters(parameters: ["token": token,"scheduleId":scheduleId,"userId":userId], encoding: JSONEncoding.default)
        case let .deletelike(token, scheduleId, userId, likeId):
            return .requestParameters(parameters: ["token": token,"scheduleId":scheduleId,"userId":userId,"likeId":likeId], encoding: JSONEncoding.default)
       
        case let .getLike(scheduleId, userId):
            return .requestParameters(parameters: ["scheduleId":scheduleId,"userId":userId], encoding: JSONEncoding.default)
        case let .moreFrom(category, user):
            return .requestParameters(parameters: ["category":category,"user":user], encoding: URLEncoding.default)
        case let .newishlist(product):
              return .requestParameters(parameters: ["product": product], encoding: JSONEncoding.default)
        case let .shopchinaStreamingVideo(origin):
            return .requestParameters(parameters: ["origin": origin], encoding: URLEncoding.default)
        case let .getprovince(countryCode, language, checkCache):
            return .requestParameters(parameters: ["countryCode": countryCode,"language": language], encoding: URLEncoding.default)
            
            //        case let .login(email,password):
            //            return .requestParameters(parameters: ["email": email,"password": password], encoding: JSONEncoding.default)
            //        case let .dashboard(schedule):
            //            return .requestParameters(parameters: ["auctionStatus": schedule], encoding: URLEncoding.default)
            //        case let .auctionById(auctionid):
            //            return .requestParameters(parameters: ["auctionid": auctionid], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    
    var headers: [String: String]? {
        switch self{
            //        case .sendPasswordResetLink,.getDevicesByProductId:
            //            return ["accept":"*/*"]
            //        case .GetDownloadPDF:
            //        return [
            //            "Content-type": "application/octet-stream",
            //            "Content-Disposition":"attachment; filename=ERSheet.pdf; filename*=UTF-8''ERSheet.pdf",
            //               "accept":"*/*",
            //            "Retry-After": "3600"
            //        ]
        default:  return [
            "Content-type": "application/json",
            "accept":"*/*",
            "Retry-After": "3600"
        ]
            
        }
    }
    
    var authorizationType: AuthorizationType {
        switch self{
        case .banner , .categories, .productcategories, .randomproduct, .productcategoriesdetails,.getAllProductsByCategories, .loginwithgoogle, .searchstore,.searchVideo, .getStreamingVideos, .refreshToken, .getvidoebyproductIds , .loginwithOtp ,.collectionDataApi, .loginWithGoogleVerification, .groupByDeals,.appleLogin, .getLiveStream, .getAllCategories,.getSellerDetail,.moreFrom,.shopchinaStreamingVideo,.shopChinarandomproduct,.getprovince,.shopchinaproductcategories:
            return .none
    
        default:
            return .bearer
        }
    }
    
    var validationType: ValidationType{
        switch self {
        case .searchVideo:
            return .successCodes
            //        case let .auctionById(auctionid):
            //            return "main/v1/auctions/\(auctionid)"
        default:
            return .successCodes
            
            
        }
    }
}
