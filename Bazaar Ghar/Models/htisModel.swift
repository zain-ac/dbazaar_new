//
//  htisModel.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 22/07/2024.
//

import Foundation



// MARK: - Result
struct TpResult: Codable {

    let hits: [TPHit]?
  

    enum CodingKeys: String, CodingKey {
     
        case hits
       
    }
}

// MARK: - FacetCount


// MARK: - Hit
struct TPHit: Codable {
    let document: TpDocument?
    let highlights: [TypeSenseHighlight]?
}

// MARK: - Document
struct TpDocument: Codable {
    let active: Bool?
    let averageRating: Double?
    let brandName: String?
    let categories: TypeSenseCategories?
//    let categoryTree: [String?]
    let createdAt: String?
    let currency: String?
    let documentDescription: String?
    let featured: Bool?
    let fiveStar, fourStar: Int?
    let gallery: [String]
    
    let id: String?
    let isVariable: Bool?
    let lvl0: String?
    let lvl1: String?
    let mainImage: String?
    let onDeal, onSale: Bool?
    let oneStar: Int?
    let platform: String?
    let price: Double? // Changed from Int to Double
    let productName: String?
    let quantity: Int?
    let ratings: TypeSenseRatings?
   
    let regularPrice: Double? // Changed from Int to Double
    let relief: Bool?
    let salePrice: Double? // Changed from Int to Double
    let sellerDetail: String?
    let sku, slug: String?
    let threeStar, total, twoStar: Int
    let user: TypeSenseUser?
    let variantGroupBuy: Bool?
    let videoType: TypeSenseVideoType?
    let weight: Int?
    let category: String?

    enum CodingKeys: String, CodingKey {
        case active
        case averageRating = "averageRating"
        case brandName = "brandName"
        case categories
//        case categoryTree = "categoryTree"
        case createdAt = "createdAt"
        case currency
        case documentDescription = "description"
        case featured
        case fiveStar = "fiveStar"
        case fourStar = "fourStar"
        case gallery
        case id
        case isVariable = "isVariable"
        case lvl0
        case lvl1
        case mainImage = "mainImage"
        case onDeal = "onDeal"
        case onSale = "onSale"
        case oneStar = "oneStar"
        case platform
        case price
        case productName = "productName"
        case quantity
        case ratings
        case regularPrice = "regularPrice"
        case relief
        case salePrice = "salePrice"
        case sellerDetail = "sellerDetail"
        case sku
        case slug
        case threeStar = "threeStar"
        case total
        case twoStar = "twoStar"
        case user
        case variantGroupBuy = "variantGroupBuy"
        case videoType = "videoType"
        case weight
        case category
    }
}
