import Foundation


// MARK: - DataClass
struct CartItemsResponse: Codable {
    let packages: [Package]?
    let total, subTotal, shippmentCharges: Float?
    let wallet: Bool?
    let  payable, retailTotal, discount: Float?
    let user: DataUser?
    let id: String?
}




// MARK: - Package
struct Package: Codable {
    let packageItems: [CartPackageItem]?
//    let shippmentCharges: Int?
    let inCart: Bool?
    let seller: CartSeller?
    let cart: String?
    let subTotal, retailTotal: Float?
    let packageWeight: Float?
    let discount: Float?
    let id: String?
}

// MARK: - PackageItem
struct CartPackageItem: Codable {
    let discount: Float?
    let _package: String?
    let product: CartProduct?
    let quantity : Int?
    let total: Float?
    let weight: Float?
    let retailTotal: Float?
    let id: String?
}

// MARK: - Product
struct CartProduct: Codable {
    let featured, onSale: Bool?
    let selectedAttributes: [SelectObjItems]?
    let  attributes: [Attributeobj]?
    let productType, productName, description: String?
    let weight: Float?
    let salePrice: Float?
    let regularPrice: Float?
    let quantity: Int?
    let mainImage: String?
    let user: ProductUser?
    let slug: String?
    let active: Bool?
    let price: Float?
    let id: String?
    let groupBuy: [ProductGroupBuy]?
}

struct ProductGroupBuy: Codable {
    
    let buyAbleProduct, remainingProduct, groupSalePrice: Int?
    let status: String?
//    let productID: PurpleProductID?
    let limit: Int?
    let startDate, endDate: String?
    let minSubscription, maxSubscription: Int?
    let sellerID: String?
    let discount: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case buyAbleProduct, remainingProduct, groupSalePrice, status
//        case productID = "productId"
        case limit, startDate, endDate, minSubscription, maxSubscription
        case sellerID = "sellerId"
        case discount, id
    }
}

// MARK: - ProductUser
struct ProductUser: Codable {
    let id: String?
}

// MARK: - Seller
struct CartSeller: Codable {
    let id, email, fullname: String?
    let sellerDetail: CartSellerDetail?
    let sellerID: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email, fullname, sellerDetail
        case sellerID = "id"
    }
}

// MARK: - SellerDetail
struct CartSellerDetail: Codable {
    let id, brandName, rrp, slug: String?
    let sellerDetailID: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brandName, rrp, slug
        case sellerDetailID = "id"
    }
}

// MARK: - DataUser
struct DataUser: Codable {
    let wallet: CartWallet?
    let fullname, id: String?
    let defaultAddress: DefaultAddress?
}



// MARK: - Wallet
struct CartWallet: Codable {
    let balance: Float?
}
// MARK: - Attribute

struct CitiesResponse: Codable {
    let cityCode, cityName: String?

    enum CodingKeys: String, CodingKey {
        case cityCode = "CITY_CODE"
        case cityName = "CITY_NAME"
    }
}
