//
//  BannerModel.swift
//  Bazaar Ghar
//
//  Created by Developer on 22/08/2023.
//



import Foundation
import SwiftyJSON

// MARK: - Bannermodel
struct BannerResponse: Codable {
    let id: ID?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
    }
    public static var shared: [BannerResponse]!
}

// MARK: - ID
struct ID: Codable {
    let id, bannerName, location, createdAt: String?
    let updatedAt: String?
    let active: Bool?
    let slug, type: String?
    let banners: [Banner]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case bannerName, location, createdAt, updatedAt, active, slug, type, banners
    }
}

// MARK: - Banner
struct Banner: Codable {
    let id: String?
    let status: Bool?
    let name: String?
    let linkId: String?
    let type: String?

    let url: String?
    let bannerSetID: String?
    let image: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status, name, url,linkId,type
        case bannerSetID = "bannerSetId"
        case image, createdAt, updatedAt
    }

}


// MARK: - CategoriesModel


struct CategoriesMainModel: Codable {
    let Categoriesdata: [CategoriesResponse]?
    let page, limit, totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case Categoriesdata = "results"
        case  page, limit, totalPages, totalResults
        
    }
}

struct languagesType: Codable {
    
    let name: String?
    let description: String?
    let productName: String?
    let brandName: String?
    let address: String?
    let city: String?
    let wideBannerImage : String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
      case  productName
        case brandName
        case address
        case city
        case wideBannerImage
        
    }
}

struct languagesModel: Codable {
    
    var ar: languagesType?
    var en: languagesType?
    
    
    enum CodingKeys: String, CodingKey {
        case ar
        case en
    }
}

struct CategoriesResponse: Codable {
    let gallery: [String]?
    let type: String?
   
    let attributeRequired: Bool?
    let deleted: Bool?
    var name, createdAt, updatedAt: String?
    let mainImage: String?
    var description: String?
    let lang:languagesModel?
    let slug: String?
    let commission: Int?
    let bannerImage: String?
    let products: Int?
    let categorySpecs: CategorySpecs?
    let subCategories: [ResultSubCategory]?
    let id: String?
    let bannerPhone: String?
    


    enum CodingKeys: String, CodingKey {
        case gallery, type, attributeRequired, deleted, name, createdAt, updatedAt, mainImage, description, slug, commission
        case bannerImage, products, categorySpecs, subCategories, id, bannerPhone,lang
    }
    public static var shared: [CategoriesResponse]!
}

// MARK: - CategorySpecs
struct CategorySpecs: Codable {
    let productsCount: Int?
    let active: Bool?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case productsCount, active
        case id = "_id"
    }
}

// MARK: - ResultSubCategory
struct ResultSubCategory: Codable {
    let gallery: [String]?
    let type: String?

    let attributeRequired: Bool?
    let deleted: Bool?
    let name: String?
    let mainCategory: String?
    let createdAt, updatedAt: String?
    let description: String?
    let commission: Int?
    let mainImage: String?
    let lang:languagesModel?
    let v: Int?
    let slug: String?
    let products: Int?
    let categorySpecs: CategorySpecs?
    let subCategories: [PurpleSubCategory]?
    let id: String?
    let bannerImage: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type, attributeRequired, deleted, name, mainCategory, createdAt, updatedAt, description, commission, mainImage,lang
        case v = "__v"
        case slug, products, categorySpecs, subCategories, id, bannerImage
    }
}

// MARK: - PurpleSubCategory
struct PurpleSubCategory: Codable {
    let gallery: [String]?
    let type: String?
   
    let attributeRequired: Bool?
    let deleted: Bool?
    let name, mainCategory, createdAt, updatedAt: String?
    let description: String?
    let commission: Int?
    let mainImage: String?
    let lang:languagesModel?
    let slug: String?
    let products: Int?
    let categorySpecs: CategorySpecs?
    let subCategories: [FluffySubCategory]?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type,  attributeRequired, deleted, name, mainCategory, createdAt, updatedAt, description, commission, mainImage, lang
        case slug, products, categorySpecs, subCategories, id
    }
}

// MARK: - FluffySubCategory
struct FluffySubCategory: Codable {
    let gallery: [String]?
    let type: String?
   
    let attributeRequired: Bool?
    let name: String?
    let createdAt, updatedAt, slug: String?

    let id: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type,  attributeRequired, name
        case createdAt, updatedAt, slug, id
    }
}




// MARK: - cateodoryproduct


struct PChat: Codable {
    let name, id: String?
    let bannerImage,wideBannerImage: String?
    let slug: String?
    let lang: languagesModel?
    let product: [Product]?
    
    enum CodingKeys: String, CodingKey {
        case name, id, bannerImage, slug, lang, wideBannerImage
        case product = "products"
    }
    public static var shared : [PChat]!
}
struct Product: Codable{
    let featured, onSale, isVariable: Bool?
    let productName, slug: String?
    let mainImage: String?
    let regularPrice: Double?
    let quantity: Int?
    let price: Double?
    let lang: languagesModel?
    let id: String?
    let salePrice: Double?
    let variants: [Variants]?
    let description: String?

}
struct Variants: Codable {
    let id: String?
    let featured, onSale: Bool?
    let productName: String?
    let regularPrice, salePrice: Double?
    let  quantity: Int?

    let mainImage: String?
    let slug: String?
//    let price: Double?


}

// MARK: - Randommodel

struct RandomnProductResponse: Codable {
    var featured, onSale: Bool?
    var productName: String?
    var regularPrice, salePrice: Double?
       var quantity: Int?
    var mainImage: String?
    var slug: String?
    var price: Double?

    public static var shared : [RandomnProductResponse]!
}


// MARK: - ProductCategoriesDetailsModel

struct ProductCategoriesDetailsResponse: Codable {
    
    let id: String?
    let onSale: Bool?
    var attributes: [Attributeobj]?
    let  gallery: [String]?
    let selectedAttributes : [SelectedAttribute]?
    let productName, description: String?
    let quantity: Int?
    let mainImage: String?
    let sellerDetail: SellerDetail?
    let slug, welcomeID: String?
    let price, regularPrice, salePrice: Double?
    let mainAttributes: [Attributeobj]?
    let categorySlug, category: String?
    //var categoryTiers: CategoryTiers?
    let ratings: Ratings?
    let variants: [Variant]?
    let lang: languagesModel?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case onSale, attributes, selectedAttributes, gallery, productName, description, quantity, mainImage, sellerDetail, slug
        case welcomeID = "id"
        //case categoryTiers
        case price, regularPrice, salePrice, categorySlug, category, ratings, variants , mainAttributes , lang
    }

}


// MARK: - Attribute
struct Attributeobj: Codable {
    let name: String?
    let values: [String]?
    let thumbnails: [Thumbnail]?
  
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let value: String?
    let thumbnail: String?
  

}

// MARK: - CategoryTiers
struct CategoryTiers: Codable {
    let lvl0, lvl1, lvl2: String?
  
}

// MARK: - Ratings
struct Ratings: Codable {
    let total, avg: Int?
  
}

// MARK: - SellerDetail
struct SellerDetail: Codable {
    let brandName, seller, slug, id: String?
    
   
}

// MARK: - Variant
struct Variant: Codable {
    let id: String?
    let onSale: Bool?
    let selectedAttributes: [SelectedAttribute]?
    let gallery: [String]?
    let productName, description: String?
    let quantity: Int?
    let mainImage: String?
    let slug, mainProduct, variantID: String?
    let price, regularPrice, salePrice: Double?
    let attribute: String?
    
  
    
    
    

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case onSale, selectedAttributes, gallery, productName, description, quantity, mainImage, slug, mainProduct
        case variantID = "id"
        case price, regularPrice, salePrice, attribute
    }
}

// MARK: - SelectedAttribute
struct SelectedAttribute: Codable {
    let name, value: String?
   
}


// MARK: - getAllProductsByCategoriesModel




// MARK: - Result

struct getAllProductCategoriesMainModel: Codable {
    let Categoriesdata: [Product]?
    let page, limit, totalPages, totalResults: Int?
    enum CodingKeys: String, CodingKey {
        case Categoriesdata = "results"
        case  page, limit, totalPages, totalResults
        
    }
}

struct getAllProductsByCategoriesResponse: Codable {
    let featured, onSale: Bool?
    let productName, slug: String?
    let user: User?
    let mainImage: String?
    let price, regularPrice, salePrice: Double?
    let quantity: Int?
//    let variants, groupBuy, reviews: [JSONAny]?
    let id: String?
}

// MARK: - User
struct User: Codable {
    let wallet: Wallet?
    let isEmailVarified, isPhoneVarified: Bool?
    let userType, role, email, fullname: String?
    let phone, createdAt, updatedAt, refCode: String?
    let sellerDetail: CategorySellerDetail?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case wallet, isEmailVarified, isPhoneVarified, userType, role, email, fullname, phone, createdAt, updatedAt, refCode
        case sellerDetail, id
    }
}

// MARK: - SellerDetail
struct CategorySellerDetail: Codable {
    let images: [String]?
    let country: String?
    let costCode, approved: Bool?
    let brandName, description: String?
    let market: CategoryMarket?
    let address, cityCode, city, seller: String?
    let createdAt, updatedAt, rrp, alias: String?
    let slug, costCenterCode, id: String?

    enum CodingKeys: String, CodingKey {
        case images, country, costCode, approved, brandName, description, market, address, cityCode, city, seller, createdAt, updatedAt, rrp, alias
        case slug, costCenterCode, id
    }
}

// MARK: - Market
struct CategoryMarket: Codable {
    let type, name, description, createdAt: String?
    let updatedAt, slug: String?
    let subMarkets: [CategorySubMarket]?
    let id: String?
}

// MARK: - SubMarket
struct CategorySubMarket: Codable {
    let type: String?
    let name, description: String?
    let mainMarket: String?
    let createdAt, updatedAt: String?
    let image: String?
//    let subMarkets: [JSONAny]?
    let id: String?
    let slug: String?

    enum CodingKeys: String, CodingKey {
        case type, name, description, mainMarket, createdAt, updatedAt, image, id
        case slug
    }
}


// MARK: - Wallet
struct Wallet: Codable {
    let balance: Int?
}



// MARK: - searchProductAPIModule

// MARK: - Result
struct SearchProductResult: Codable {
    let featured, onSale: Bool?
    let attributes: [Attributes]?
    let selectedAttributes: [SelectObjItems]?
    let isVariable: Bool?
    let productName, sku, slug: String?
    let user: Users?
    let id: String?
    let mainImage: String?
    let category, description: String?
    let price: Double?
    let quantity: Int?
    let active: Bool?
    let regularPrice, salePrice: Double?
    let weight: Double?
}

// MARK: - Attribute
struct Attributes: Codable {
    let name: String?
    let values: [String]?
}

// MARK: - User
struct Users: Codable {
    let sellerDetail: SellerDetails?
    let id, fullname: String?
}

// MARK: - SellerDetail
struct SellerDetails: Codable {
    let id, brandName: String?
}








// MARK: - searchStoreAPIModule
struct searchStoreDataClass: Codable {
    let results: [searchStoreResult]?
    let page, limit, totalPages, totalResults: Int?
}
// MARK: - Result
struct searchStoreResult: Codable {
    let images: [String]?
    let country: String?
    let costCode, approved: Bool?
    let brandName, description: String?
    let market: Market?
    let lang:languagesModel?
    let address, cityCode, city, seller: String?
    let createdAt, updatedAt: String?
    let rrp, alias, costCenterCode, slug: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case images, country, costCode, approved, brandName, description, market, address, cityCode, city, seller, createdAt, updatedAt
        case rrp, alias, costCenterCode, slug, id,lang
    }
}
struct getSellerDetailDataModel: Codable {
    let id: String?
    let images: [String]?
    let country: String?
    let categories: [String]?
    let categoryUpdated, costCode, approved: Bool?
    let brandName, description, market, address: String?
    let cityCode, city, seller, createdAt: String?
    let updatedAt, rrp, slug, costCenterCode: String?
    let alias: String?
    let v: Int?
//    let products, followers: Followers?
//    let videos: Videos?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case images, country, categories, categoryUpdated, costCode, approved, brandName, description, market, address, cityCode, city, seller, createdAt, updatedAt, rrp, slug, costCenterCode, alias
        case v = "__v"
    }
}

// MARK: - Market
struct Market: Codable {
    let type: String?
    let name, description, createdAt, updatedAt: String?
    let image: String?
    let subMarkets: [Market]?
    let id, slug: String?
    let mainMarket: String?

    enum CodingKeys: String, CodingKey {
        case type, name, description, createdAt, updatedAt
        case image, subMarkets, id, slug, mainMarket
    }
}


struct searchVideoResultMainModel: Codable {
    let searchVideodata: [searchVideoResult]?
    let page, limit, totalPages, totalResults: Int?
    enum CodingKeys: String, CodingKey {
        case searchVideodata = "results"
        case  page, limit, totalPages, totalResults
        
    }
}

// MARK: - searchVideoAPIModule
// MARK: - Datum
struct searchVideoResult: Codable {
    let id: String?
       let productsID: [String]?
       let featured: Bool?
       let duration: Double?
       let pin: Bool?
       let videoType: String?
       let streamingURL: String?
       let userID, title: String?
        var slotStatus: String?
       let slug: String?
       var brandName: String?
      var brandID: String?
       let thumbnail: String?
       let description: String?
       let mbrURL: String?
       let liveViews, totalViews, like: Int?
       let datumID: String?

       enum CodingKeys: String, CodingKey {
           case id = "_id"
           case productsID = "productsId"
           case featured, duration, pin, videoType
           case streamingURL = "streamingUrl"
           case userID = "userId"
           case title, slotStatus, slug, brandName
           case brandID = "brandId"
           case thumbnail, description
           case mbrURL = "mbrUrl"
           case liveViews, totalViews, like
           case datumID = "id"
       }
   }



// MARK: - order response
struct OrderResponse: Codable {
    let orderAddress: OrderAddress?
    let paymentTrace: OrderPaymentTrace?
    let orders: [Order]?
    let status: String?
    let isAdmin: Bool?
    let adminUser: String?
    let paymentMethod: String?
    let paymentMethodTotal: Double?
    let groupBuy: Bool?
    let adminDiscount: Double?
    let customer: OrderCustomer?
    let orderNote, payment: String?
    let createdAt, updatedAt, orderDetailID: String?
    let subTotal, total, retailTotal, shippmentCharges: Double?
    let payableShippment, payable, discount: Double?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case orderAddress, paymentTrace, orders, status, isAdmin, adminUser, paymentMethod, paymentMethodTotal, groupBuy, adminDiscount, customer, orderNote, payment, createdAt, updatedAt
        case orderDetailID = "OrderDetailId"
        case subTotal, total, retailTotal, shippmentCharges, payableShippment, payable, discount

        case id
    }
}

// MARK: - Customer
struct OrderCustomer: Codable {
    let wallet: OrderWallet?
    let isEmailVarified, isPhoneVarified: Bool?
    let userType, role, googleID, fullname: String?
    let createdAt, updatedAt, refCode: String?
    let v: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case wallet, isEmailVarified, isPhoneVarified, userType, role
        case googleID = "googleId"
        case fullname, createdAt, updatedAt, refCode
        case v = "__v"
        case id
    }
}

// MARK: - Wallet
struct OrderWallet: Codable {
    let balance: Int?
}

// MARK: - OrderAddress
struct OrderAddress: Codable {
    let addressType, localType: String?
}

// MARK: - Order
struct Order: Codable {
    let orderItems: [OrderItem]?
    let paymentMethod: String?
    let wallet: Bool?
    let paymentMethodTotal: Double?
    let groupBuy: Bool?
    let groupBuyQuantity: Int?
    let customer, seller, orderDetail: String?
    let shippmentCharges: Double?
    let orderNote: String?
    let subTotal, retailTotal, discount: Double?
    let subWeight: Double?
    let orderID, statusUpdatedAt: String?
    let adminDiscount: Double?
    let vendor: PlaceOrderVendor?
    let store: PlaceOrderStore?
    let payableShippment, payable: Double?
    let orderStatus: PlaceOrderStatus?
    let v: Int?
    let createdAt, updatedAt, id: String?

    enum CodingKeys: String, CodingKey {
        case orderItems, paymentMethod, wallet, paymentMethodTotal, groupBuy, groupBuyQuantity, customer, seller, orderDetail, shippmentCharges, orderNote, subTotal, retailTotal, discount, subWeight
        case orderID = "orderId"
        case statusUpdatedAt, adminDiscount, vendor, store, payableShippment, payable, orderStatus
        case v = "__v"
        case createdAt, updatedAt, id
    }
}

// MARK: - OrderItem
struct OrderItem: Codable {
    let adminDiscount: PlaceOrderAdminDiscount?
    let discount, adminTotalDiscount: Double?
    let product: OrderProduct?
    let quantity: Int?
    let createdAt, updatedAt: String?
    let total, retailTotal, v: Double?
    let weight: Double?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case adminDiscount, discount, adminTotalDiscount, product, quantity, createdAt, updatedAt, total, weight, retailTotal
        case v = "__v"
        case id
    }
}

// MARK: - AdminDiscount
struct PlaceOrderAdminDiscount: Codable {
    let discountType: String?
    let amount: Double?
}

// MARK: - Product
struct OrderProduct: Codable {
    let featured, onSale: Bool?
    let attributes : [attributeobject]?
let selectedAttributes: [SelectObjItems]?
    let isVariable: Bool?
    let productType: String?
    let gallery: [String]?
    let variantGroupBuy: Bool?
    let categoryTree: [String]?
    let onDeal, relief: Bool?
    let videoType, productName, slug: String?
    let mainImage: String?
    let active: Bool?
    let description: String?
    let price, regularPrice: Double?
    let quantity: Int?
    let   weight: Double?
    let user, createdAt, updatedAt, id: String?
    let salePrice: Double?
}
struct attributeobject: Codable {
    let name: String?
    let values: [String]?
   
}

// MARK: - OrderStatus
struct PlaceOrderStatus: Codable {
    let name: String?
    let current: Bool?
    let order, createdAt, seller, id: String?
}

// MARK: - Store
struct PlaceOrderStore: Codable {
    let id, brandName, slug: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brandName, slug
    }
}

// MARK: - Vendor
struct PlaceOrderVendor: Codable {
    let id, email, fullname: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email, fullname
    }
}

// MARK: - PaymentTrace
struct OrderPaymentTrace: Codable {
    let walletPaid, cardPaid: Int?
}



// MARK: - getvidoebyproductIds
struct GetVidoeByProductIds: Codable {
    let featured, onSale: Bool?
    let attributes: [GetVidoeByProductAttribute]?
   
    let gallery: [String]?
    let productName, slug: String?
   
    let mainImage: String?
    let active: Bool?
    let description: String?
    let price, quantity, regularPrice, salePrice: Double?
    let variants: [GetVidoeByProductVariant]?
    let groupBuy, reviews: [String]?
    let id: String?
}

// MARK: - Attribute
struct GetVidoeByProductAttribute: Codable {
    let name: String?
    let values: [String]?
}

// MARK: - User
struct GetVidoeByProductUser: Codable {
    let wallet: GetVidoeByProductWallet?
    let isEmailVarified, isPhoneVarified: Bool?
    let userType, role, email, fullname: String?
    let phone, createdAt, updatedAt: String?
    let v: Int?
    let sellerDetail: GetVidoeByProductSellerDetail?
    let refCode: String?
    let defaultAddress: DefaultAddress?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case wallet, isEmailVarified, isPhoneVarified, userType, role, email, fullname, phone, createdAt, updatedAt
        case v = "__v"
        case sellerDetail, refCode, defaultAddress, id
    }
}

// MARK: - DefaultAddress
//struct DefaultAddress: Codable {
//    let addressType, localType, address, city: String?
//    let cityCode, fullname, phone, province: String?
//    let user, createdAt, updatedAt: String?
//    let v: Int?
//    let country, state, id: String?
//
//    enum CodingKeys: String, CodingKey {
//        case addressType, localType, address, city
//        case cityCode = "city_code"
//        case fullname, phone, province, user, createdAt, updatedAt
//        case v = "__v"
//        case country, state, id
//    }
//}

// MARK: - SellerDetail
struct GetVidoeByProductSellerDetail: Codable {
    let images: [String]?
    let country: String?
    let costCode, approved: Bool?
    let brandName, description: String?
    let market: GetVidoeByProductMarket?
    let address, cityCode, city, seller: String?
    let createdAt, updatedAt, rrp, slug: String?
    let costCenterCode, alias: String?
    let v: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case images, country, costCode, approved, brandName, description, market, address, cityCode, city, seller, createdAt, updatedAt, rrp, slug, costCenterCode, alias
        case v = "__v"
        case id
    }
}

// MARK: - Market
struct GetVidoeByProductMarket: Codable {
    let type, name, description, createdAt: String?
    let updatedAt: String?
    let v: Int?
//    let subMarkets: [String]?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case type, name, description, createdAt, updatedAt
        case v = "__v"
        case  id
    }
}

// MARK: - Wallet
struct GetVidoeByProductWallet: Codable {
    let balance: Int?
}

// MARK: - Variant
struct GetVidoeByProductVariant: Codable {
    let featured, onSale: Bool?

    let selectedAttributes: [GetVidoeByProductSelectedAttribute]?
    let isVariable: Bool?
    let productType: String?
    let gallery: [String]?
    let variantGroupBuy: Bool?
    let categoryTree: [String]?
    let onDeal, relief: Bool?
    let videoType, productName, sku, slug: String?
    let sellerDetail, mainProduct, createdAt: String?
    //let user : User?
    let updatedAt: String?
    let v, quantity, regularPrice, salePrice: Double?
    let weight: Int?
    let mainImage: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case featured, onSale, selectedAttributes, isVariable, productType, gallery, variantGroupBuy, categoryTree, onDeal, relief, videoType, productName, sku, slug, sellerDetail, mainProduct, createdAt, updatedAt
        case v = "__v"
        case quantity, regularPrice, salePrice, weight, mainImage, id
    }
}


struct GetVidoeByProductSelectedAttribute: Codable {
    let name, value: String?
}




// MARK: - GroupByDataModel
struct GroupByDataModel: Codable {
    let result: [GroupByResult]?
    let totalResults, totalPages, limit, page: Int?
}

// MARK: - Result
struct GroupByResult: Codable {
    let id: String?
    let buyAbleProduct, remainingProduct, groupSalePrice: Double?
    let status: String?
    let productID: ProductID?
    let limit: Int?
    let startDate, endDate: String?
    let minSubscription, maxSubscription: Double?
    let sellerID: String?
    let inStock, discount: Double?
    let createdAt, updatedAt: String?
    let v: Int?
    let sellerDetails: [GroupBySellerDetail]?
    let remainingTime: RemainingTime?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case buyAbleProduct, remainingProduct, groupSalePrice, status
        case productID = "productId"
        case limit, startDate, endDate, minSubscription, maxSubscription
        case sellerID = "sellerId"
        case inStock, discount, createdAt, updatedAt
        case v = "__v"
        case sellerDetails, remainingTime
    }
}

// MARK: - ProductID
struct ProductID: Codable {
    let id: String?
    let featured, onSale: Bool?
    let attributes : [attributeobject]?
    let selectedAttributes: [SelectObjItems]?
    let isVariable: Bool?
    let productType: String?
    let gallery: [String]?
    let variantGroupBuy: Bool?
    let categoryTree: [String]?
    let onDeal, relief: Bool?
    let videoType, productName, sku, slug: String?
    let user, sellerDetail, createdAt, updatedAt: String?
    let v: Int?
    let mainImage: String?
    let active: Bool?
    let categories: GroupByCategories?
    let category, description: String?
    let packageInfo: PackageInfo?
    let price, quantity, regularPrice: Double?
    let warranty: Warranty?
    let salePrice, weight: Double?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case featured, onSale, attributes, selectedAttributes, isVariable, productType, gallery, variantGroupBuy, categoryTree, onDeal, relief, videoType, productName, sku, slug, user, sellerDetail, createdAt, updatedAt
        case v = "__v"
        case mainImage, active, categories, category, description, packageInfo, price, quantity, regularPrice, warranty, salePrice, weight
    }
}

// MARK: - Categories
struct GroupByCategories: Codable {
    let lvl0: String?
}

// MARK: - PackageInfo
struct PackageInfo: Codable {
    let volume: Volume?
    let id: String?
    let weight: Double?

    enum CodingKeys: String, CodingKey {
        case volume
        case id = "_id"
        case weight
    }
}

// MARK: - Volume
struct Volume: Codable {
    let unit: String?
    let length, width, height: Int?
}

// MARK: - Warranty
struct Warranty: Codable {
    let warrantyPeriod: WarrantyPeriod?
    let warrantyType, id: String?

    enum CodingKeys: String, CodingKey {
        case warrantyPeriod, warrantyType
        case id = "_id"
    }
}

// MARK: - WarrantyPeriod
struct WarrantyPeriod: Codable {
    let unit: String?
    let tenure: Int?
}

// MARK: - RemainingTime
struct RemainingTime: Codable {
    let days, minutes, hours: Int?
}

// MARK: - SellerDetail
struct GroupBySellerDetail: Codable {
    let id: String?
    let images: [String]?
    let country: String?
    let approved: Bool?
    let brandName, description, market, address: String?
    let cityCode, city, seller, createdAt: String?
    let updatedAt, rrp: String?
    let v: Int?
    let alias, costCenterCode: String?
    let costCode: Bool?
    let slug: String?
    let lang: Lang?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case images, country, approved, brandName, description, market, address, cityCode, city, seller, createdAt, updatedAt, rrp
        case v = "__v"
        case alias, costCenterCode, costCode, slug, lang
    }
}

// MARK: - Lang
struct Lang: Codable {
    let ar: Ar?
}

// MARK: - Ar
struct Ar: Codable {
    let brandName: String?
}

// MARK: - CollectionRespones




// MARK: - Datum
struct CollectionData: Codable {
    let id: String?
    let active: Bool?
    let name, expireDate: String?
    let image: String?
    let slug, createdAt, updatedAt: String?
    let v: Int?
    let products: [CollectionProductData]?
    let description: String?
    let totalCount, totalPages, limit, page: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case active, name, expireDate, image, slug, createdAt, updatedAt
        case v = "__v"
        case products, description, totalCount, totalPages, limit, page
    }
}

// MARK: - Product
struct CollectionProductData: Codable {
    let id: String?
    let onSale: Bool?
    let productName, slug: String?
    let mainImage: String?
    let description: String?
    let price, regularPrice: Double?
    let sellerDetail: String?
    let relief: Bool?
    let salePrice: Double?
    let variantGroupBuy, onDeal: Bool?
    let videoType: String?
    let videoURL: String?
    let mainProduct: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case onSale, productName, slug, mainImage, description, price, regularPrice, sellerDetail, relief, salePrice, variantGroupBuy, onDeal, videoType
        case videoURL = "videoUrl"
        case mainProduct
    }
}




// MARK: - ChineseBellResponse

struct ChineseBellResponse: Codable {
    let type: String?
    let unread: Bool?
    let sellerID, brandName, description, fullname: String?
    let userID, sendTo, id: String?

    enum CodingKeys: String, CodingKey {
        case type, unread
        case sellerID = "sellerId"
        case brandName, description, fullname
        case userID = "userId"
        case sendTo, id
    }
}


class PMsg {
  var unreadCount : Int?
  var idarray:PMsgMaain?
  init(jsonData : JSON?) {
    let obj = jsonData?["_id"].dictionaryObject
    let charData_ = PMsgMaain(jsonData: JSON(jsonData?["_id"]))
     self.unreadCount = jsonData?["unreadCount"].intValue
    self.idarray = charData_
   }
}
class PMsgMaain {
  var _id : String!
  var customerName : String!
  var chat = [Pchat]()
  var sellerId: String!
  var updatedAt: String
  var createdAt: String
  var brandName: String
  var customerId:String?
  var storeId:String?
  init(jsonData : JSON?) {
    var chartDataArray = [Pchat]()
    for obj in (jsonData?["chat"].arrayValue)! {
      let charData_ = Pchat(jsonData: JSON(obj))
      chartDataArray.append(charData_)
    }
    _id = jsonData?["_id"].stringValue ?? ""
    customerName = jsonData?["customerName"].stringValue ?? ""
    self.chat = chartDataArray
    sellerId = jsonData?["sellerId"].stringValue ?? ""
    updatedAt = jsonData?["updatedAt"].stringValue ?? ""
    createdAt = jsonData?["createdAt"].stringValue ?? ""
    brandName = jsonData?["brandName"].string ?? ""
    customerId = jsonData?["customerId"].stringValue ?? ""
    storeId = jsonData?["storeId"].stringValue ?? ""
  }
}
  class Pchat {
    var _id : String!
    var unread : Bool!
    var roomId : String!
    var contentType: String!
    var receiverId: String
    var message: String
    var date: String
    init(jsonData:JSON) {
      _id = jsonData["_id"].stringValue
      unread = jsonData["unread"].boolValue
      roomId = jsonData["roomId"].stringValue
      contentType = jsonData["contentType"].stringValue
      receiverId = jsonData["receiverId"].stringValue
      message = jsonData["message"].stringValue
      date = jsonData["date"].string ?? ""
    }
  }




class PuserMainModel {
  var roomId : String!
  var messages : PuserModel!
   
  init(jsonData:JSON?) {
      roomId = jsonData?["roomId"].stringValue
     
   
let charData_ = PuserModel(jsonData:  JSON(jsonData?["messages"]))
    
      messages = charData_
  }
}






class PuserModel {
  var limit : Int!
  var page : Int!
    var chat = [Pusermessage]()



    
    
  init(jsonData:JSON?) {
      
      var chartDataArray = [Pusermessage]()
      for obj in (jsonData?["results"].arrayValue)! {
        let charData_ = Pusermessage(jsonData: JSON(obj))
        chartDataArray.append(charData_)
      }
      
      
      limit = jsonData?["limit"].intValue
      page = jsonData?["page"].intValue
      chat = chartDataArray
  }
}










class Pusermessage {
  var contentType : String!
  var date : String!

  var id: String!
    var multimedia: String!
 
  var message: String!
  var receiverId: String!
  var roomId: String!
    var unread: Int!

    
    
  init(jsonData:JSON?) {
      
      var chartDataArray = [String]()
      for obj in (jsonData?["multimedia"].arrayValue)! {
       
          chartDataArray.append(obj.rawString() ?? "")
      }
      
      
      
      
      
      contentType = jsonData?["contentType"].stringValue
      date = jsonData?["date"].stringValue
      id = jsonData?["id"].stringValue
      message = jsonData?["message"].stringValue
      multimedia = chartDataArray.first
      receiverId = jsonData?["receiverId"].stringValue
      roomId = jsonData?["roomId"].stringValue
      unread = jsonData?["unread"].intValue
  }
}


class notificationmodel {
    var brandName, descriptions, fullname, id: String
    var sellerID, sendTo, type: String
    var unread: Int
    var userID: String
    var action: String?

    init(jsonData : JSON?) {
  
        brandName = jsonData?["brandName"].stringValue ?? ""
        descriptions = jsonData?["description"].stringValue ?? ""
     
      fullname = jsonData?["fullname"].stringValue ?? ""
        id = jsonData?["id"].stringValue ?? ""
        sellerID = jsonData?["sellerID"].stringValue ?? ""
        sendTo = jsonData?["sendTo"].string ?? ""
        type = jsonData?["type"].stringValue ?? ""
        unread = jsonData?["unread"].intValue ?? 0
        userID = jsonData?["userID"].stringValue ?? ""
        action = jsonData?["action"].stringValue ?? ""
    }
}






//struct FollowedResponsed: Codable {
//    let data: DataClass
//    let status: Int
//    let message: String
//}

// MARK: - DataClass
struct FollowedResponse: Codable {
    let followed: String
}



class GetDataOfPushProduct {
    var feature: String
    var product: String
    var token: String
    var isSuccess: Bool
    var message: String
    var status: Int

    init(jsonData: JSON) {
        self.feature = jsonData["data"]["feature"].stringValue
        self.product = jsonData["data"]["product"].stringValue
        self.token = jsonData["data"]["token"].stringValue
        self.isSuccess = jsonData["isSuccess"].boolValue
        self.message = jsonData["message"].stringValue
        self.status = jsonData["status"].intValue
    }
}






// MARK: - Datum
struct getAllCategoryResponse: Codable {
    let type: String?
    let platform: Platform?
    let name: String?
    let mainImage: String?
    let slug: String?
    let categorySpecs: DatumCategorySpecs?
    let lang: DatumLang?
    let subCategories: [DatumSubCategory]?
    let id: String?
}

// MARK: - DatumCategorySpecs
struct DatumCategorySpecs: Codable {
    let productsCount: Int?
    let active: Bool?
    let id: String?
    let updated: Bool?

    enum CodingKeys: String, CodingKey {
        case productsCount, active
        case id = "_id"
        case updated
    }
}



// MARK: - DatumLang
struct DatumLang: Codable {
    let ar: PurpleAr?
}

// MARK: - PurpleAr
struct PurpleAr: Codable {
    let name, description: String?
    let bannerImage, wideBannerImage: String?
    let wideBannerImageAr: String?
}

enum Platform: String, Codable {
    case aliExpress = "aliExpress"
    case bazaarGhar = "bazaarGhar"
}

// MARK: - DatumSubCategory
struct DatumSubCategory: Codable {
    let gallery: [String]?
    let type: String?
    let attributes: [String]?
    let attributeRequired: Bool?
    let platform: Platform?
    let deleted: Bool?
    let name, mainCategory, createdAt: String?
    let updatedAt: String?
    let description: String?
    let mainImage: String?
    let v: Int?
    let slug: String?
    let products: Int?
    let categorySpecs: DatumCategorySpecs?
    let lang: PurpleLang?
    let videoCount: Int?
    let subCategories: [PurppleSubCategory]?
    let id: String?
    let commission: Int?
    let bannerImage, wideBannerImage: String?
    let platformID: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type, attributes, attributeRequired, platform, deleted, name, mainCategory, createdAt, updatedAt, description, mainImage
        case v = "__v"
        case slug, products, categorySpecs, lang, videoCount, subCategories, id, commission, bannerImage, wideBannerImage
        case platformID = "platformId"
    }
}

// MARK: - PurpleLang
struct PurpleLang: Codable {
    let ar: FluffyAr?
}

// MARK: - FluffyAr
struct FluffyAr: Codable {
    let name, description: String?
}

// MARK: - PurpleSubCategory
struct PurppleSubCategory: Codable {
    let gallery: [String]?
    let type: String?
    let attributes: [String]?
    let attributeRequired: Bool?
    let platform: Platform?
    let name: String?
    let commission: Int?
    let mainCategory, createdAt: String?
    let updatedAt: String?
    let v: Int?
    let description: String?
    let mainImage: String?
    let slug: String?
    let categorySpecs: DatumCategorySpecs?
    let lang: PurpleLang?
    let subCategories: [FlufffySubCategory]?
    let id: String?
    let products: Int?
    let deleted: Bool?
    let bannerImage: String?
    let videoCount: Int?

    enum CodingKeys: String, CodingKey {
        case gallery, type, attributes, attributeRequired, platform, name, commission, mainCategory, createdAt, updatedAt
        case v = "__v"
        case description, mainImage, slug, categorySpecs, lang, subCategories, id, products, deleted, bannerImage, videoCount
    }
}

// MARK: - FluffySubCategory
struct FlufffySubCategory: Codable {
    let gallery: [String]?
    let type: String?
    let attributes: [String]?
    let attributeRequired: Bool?
    let platform: Platform?
    let name, mainCategory: String?
    let v: Int?
    let createdAt: String?
    let updatedAt: String?
    let slug: String?
    let lang: FluffyLang?
    let categorySpecs: PurpleCategorySpecs?
    let subCategories: [String]?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case gallery, type, attributes, attributeRequired, platform, name, mainCategory
        case v = "__v"
        case createdAt, updatedAt, slug, lang, categorySpecs, subCategories, id
    }
}

// MARK: - PurpleCategorySpecs
struct PurpleCategorySpecs: Codable {
    let productsCount: Int?
    let active: Bool?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case productsCount, active
        case id = "_id"
    }
}

// MARK: - FluffyLang
struct FluffyLang: Codable {
    let ar: TentacledAr?
}

// MARK: - TentacledAr
struct TentacledAr: Codable {
    let name: String?
}

//struct latestMobileDataModel: Codable {
//    let name, id, slug: String?
//    let lang: DatumLang?
//    let products: [Product]?
//    let wideBannerImage: String?
//}

// MARK: - DatumLang
struct DatumLangg: Codable {
    let ar: PurpleAr?
}

// MARK: - PurpleAr
struct PurpleArr: Codable {
    let name, description: String?
}

// MARK: - Product
struct latestMobileDataModel: Codable {
    let featured, onSale, isVariable: Bool?
    let productName: String?
    let regularPrice: Double?
    let salePrice: Double?
    let quantity: Int?
    let mainImage: String?
    let slug: String?
    let price: Double?
    let variants: [Variant]?
    let id: String?
    let lang: ProductLangg?
}

// MARK: - ProductLang
struct ProductLangg: Codable {
    let ar: FluffyAr?
}

// MARK: - FluffyAr
struct FluffyArr: Codable {
    let productName, description: String?
}
