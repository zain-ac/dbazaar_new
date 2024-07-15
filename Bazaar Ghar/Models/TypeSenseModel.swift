struct TypeSenseModel: Decodable {
    let results: [TypeSenseResult?]?
}

// MARK: - Result
struct TypeSenseResult: Decodable {
    let facetCounts: [TypeSenseFacetCount?]?
    let found: Int?
    let hits: [TypeSenseHit]?
    let outOf, page: Int?
    let requestParams: TypeSenseRequestParams?
    let searchCutoff: Bool?
    let searchTimeMS: Int?

    enum CodingKeys: String, CodingKey {
        case facetCounts = "facet_counts"
        case found
        case hits
        case outOf = "out_of"
        case page
        case requestParams = "request_params"
        case searchCutoff = "search_cutoff"
        case searchTimeMS = "search_time_ms"
    }
}

// MARK: - FacetCount
struct TypeSenseFacetCount: Decodable {
    let counts: [TypeSenseCount?]?
    let fieldName: String?
    let sampled: Bool?
    let stats: TypeSenseStats?

    enum CodingKeys: String, CodingKey {
        case counts
        case fieldName = "field_name"
        case sampled
        case stats
    }
}

// MARK: - Count
struct TypeSenseCount: Decodable {
    let count: Int
    let highlighted, value: String

    enum CodingKeys: String, CodingKey {
        case count
        case highlighted
        case value
    }
}

// MARK: - Stats
struct TypeSenseStats: Decodable {
    let avg, max, min, sum: Double?
    let totalValues: Int

    enum CodingKeys: String, CodingKey {
        case avg
        case max
        case min
        case sum
        case totalValues = "total_values"
    }
}

// MARK: - Hit
struct TypeSenseHit: Decodable {
    let document: TypeSenseDocument?
    let highlight: TypeSenseHighlight?
    let highlights: [TypeSenseHighlight]?

    enum CodingKeys: String, CodingKey {
        case document
        case highlight
        case highlights
    }
}

// MARK: - Document
struct TypeSenseDocument: Decodable {
    let active: Bool?
    let attributes: [String?]
    let averageRating: Double?
    let brandName: String?
    let categories: TypeSenseCategories?
    let categoryTree: [String?]
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
    let origin: TypeSenseOrigin?
    let platform: String?
    let price: Int?
    let productName: String?
    let productType: TypeSenseProductType?
    let quantity: Int?
    let ratings: TypeSenseRatings?
    let region: [String?]
    let regularPrice: Int?
    let relief: Bool?
    let salePrice: Int?
    let selectedAttributes: [String?]
    let sellerDetail: String?
    let sku, slug: String?
    let threeStar, total, twoStar: Int
    let user: TypeSenseUser?
    let variantGroupBuy: Bool?
    let variants: [String?]?
    let videoType: TypeSenseVideoType?
    let weight: Int?
    let category: String?

    enum CodingKeys: String, CodingKey {
        case active
        case attributes
        case averageRating = "averageRating"
        case brandName = "brandName"
        case categories
        case categoryTree = "categoryTree"
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
        case origin
        case platform
        case price
        case productName = "productName"
        case productType = "productType"
        case quantity
        case ratings
        case region
        case regularPrice = "regularPrice"
        case relief
        case salePrice = "salePrice"
        case selectedAttributes = "selectedAttributes"
        case sellerDetail = "sellerDetail"
        case sku
        case slug
        case threeStar = "threeStar"
        case total
        case twoStar = "twoStar"
        case user
        case variantGroupBuy = "variantGroupBuy"
        case variants
        case videoType = "videoType"
        case weight
        case category
    }
}

// MARK: - Categories
struct TypeSenseCategories: Decodable {
    let lvl0: String?
    let lvl1: String?

    enum CodingKeys: String, CodingKey {
        case lvl0
        case lvl1
    }
}

enum TypeSenseCurrency: String, Decodable {
    case pkr
}

enum TypeSenseOrigin: String, Decodable {
    case pak
}

enum TypeSenseProductType: String, Decodable {
    case main
}

// MARK: - Ratings
struct TypeSenseRatings: Decodable {
    let avg, total: Int?

    enum CodingKeys: String, CodingKey {
        case avg
        case total
    }
}

// MARK: - User
struct TypeSenseUser: Decodable {
    let fullname: String?
    let id: String?
    let sellerDetail: TypeSenseSellerDetail?

    enum CodingKeys: String, CodingKey {
        case fullname
        case id
        case sellerDetail = "sellerDetail"
    }
}

// MARK: - SellerDetail
struct TypeSenseSellerDetail: Decodable {
    let brandName: String?
    let id: String

    enum CodingKeys: String, CodingKey {
        case brandName = "brand_name"
        case id
    }
}

enum TypeSenseVideoType: String, Decodable {
    case bg
}

// MARK: - Highlight
struct TypeSenseHighlight: Decodable {
}

// MARK: - RequestParams
struct TypeSenseRequestParams: Decodable {
    let collectionName, firstQ: String?
    let perPage: Int?
    let q: String?

    enum CodingKeys: String, CodingKey {
        case collectionName = "collection_name"
        case firstQ = "first_q"
        case perPage = "per_page"
        case q
    }
}
