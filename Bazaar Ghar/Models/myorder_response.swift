//
//  myorder_response.swift
//  Bazaar Ghar
//
//  Created by Developer on 19/09/2023.
//

import Foundation
struct MyOrderResponse: Codable {
    let results: [MyOrderResult]?
    let totalResults, page, limit, totalPages: Int?
}

// MARK: - Result
struct MyOrderResult: Codable {
    let id, paymentMethod: String?
    let wallet: Bool? 
    let paymentMethodTotal: Double?
    let groupBuy: Bool?
    let groupBuyQuantity: Int?
    let customer: MyOrderCustomer?
    let seller: Seller?
    let orderDetail: String?
    let shippmentCharges: Double?
    let orderNote: String?
    let subTotal, retailTotal, discount: Double?
    let  subWeight: Double?
    let orderID, statusUpdatedAt: String?
    let adminDiscount: Double?
    let vendor: Vendor?
    let store: Store?
    let payableShippment, payable, v: Double?
    let createdAt, updatedAt: String?
    let orderStatus: OrderStatus?
    let orderItems: [NewOrderItem]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case paymentMethod, wallet, paymentMethodTotal, groupBuy, groupBuyQuantity, customer, seller, orderDetail, shippmentCharges, orderNote, subTotal, retailTotal, discount, subWeight
        case orderID = "orderId"
        case statusUpdatedAt, adminDiscount, vendor, store, payableShippment, payable
        case v = "__v"
        case createdAt, updatedAt, orderStatus, orderItems
    }
}

// MARK: - Customer
struct MyOrderCustomer: Codable {
    let id: String?
    let wallet: MyOrderWallet?
    let isEmailVarified, isPhoneVarified: Bool?
    let userType, role, googleID, fullname: String?
    let createdAt, updatedAt, refCode: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case wallet, isEmailVarified, isPhoneVarified, userType, role
        case googleID = "googleId"
        case fullname, createdAt, updatedAt, refCode
        case v = "__v"
    }
}

// MARK: - Wallet
struct MyOrderWallet: Codable {
    let balance: Int?
}

// MARK: - OrderItem
struct NewOrderItem: Codable {
    let id: String?
    let adminDiscount: AdminDiscount?
    let discount, adminTotalDiscount: Double?
    let product: Product?
    let quantity: Int?
    let createdAt, updatedAt: String?
    let total, retailTotal, v: Double?
    let weight: Double?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case adminDiscount, discount, adminTotalDiscount, product, quantity, createdAt, updatedAt, total, weight, retailTotal
        case v = "__v"
    }
}

// MARK: - AdminDiscount
struct AdminDiscount: Codable {
    let discountType: String?
    let amount: Double?
}

// MARK: - Product
struct MyOrderProduct: Codable {
    let featured, onSale: Bool?
    let attributes : [attributeobject]?
        let selectedAttributes: [SelectObjItems]?
    let isVariable: Bool?
    let productType: String?
    let gallery: String?
    let variantGroupBuy: Bool?
    let categoryTree: [String]?
    let onDeal, relief: Bool?
    let videoType, id, productName, slug: String?
    let mainImage: String?
    let active: Bool?
    let description: String?
    let price,  regularPrice, salePrice: Double?
    let quantity: Int?
    let weight: Double?
    let user, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case featured, onSale, attributes, selectedAttributes, isVariable, productType, gallery, variantGroupBuy, categoryTree, onDeal, relief, videoType
        case id = "_id"
        case productName, slug, mainImage, active, description, price, quantity, regularPrice, salePrice, weight, user, createdAt, updatedAt
    }
}

// MARK: - OrderStatus
struct OrderStatus: Codable {
    let id, name: String?
    let current: Bool?
    let order, createdAt, seller: String?
    let v: Int?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, current, order, createdAt, seller
        case v = "__v"
        case updatedAt
    }
}

// MARK: - Seller
struct Seller: Codable {
    let id: String?
    let isEmailVarified, isPhoneVarified: Bool?
    let userType, role, email, password: String?
    let fullname, phone, createdAt, updatedAt: String?
    let sellerDetail: MyOrderSellerDetail?
    let wallet: Wallet?
    let refCode: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case isEmailVarified, isPhoneVarified, userType, role, email, password, fullname, phone, createdAt, updatedAt, sellerDetail, wallet, refCode
    }
}

// MARK: - SellerDetail
struct MyOrderSellerDetail: Codable {
    let id: String?
    let images: [String]?
    let brandName, description, market, seller: String?
    let createdAt, updatedAt: String?
    let v: Int?
    let address, city, cityCode, country: String?
    let approved: Bool?
    let rrp, alias, costCenterCode: String?
    let costCode: Bool?
    let slug: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case images, brandName, description, market, seller, createdAt, updatedAt
        case v = "__v"
        case address, city, cityCode, country, approved, rrp, alias, costCenterCode, costCode, slug
    }
}

// MARK: - Store
struct Store: Codable {
    let id, brandName, slug: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brandName, slug
    }
}

// MARK: - Vendor
struct Vendor: Codable {
    let id, email, fullname: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email, fullname
    }
}
