import Foundation
public struct Recipe: Codable {
  var directions: [String]?
  public var id: String?
  var ingredient_names: [String]?
  var ingredients_with_measurements: [String]?
  var link: String?
  var recipe_id: Int?
  var title: String?
    var active: Bool?

    var featured, onSale, isVariable: Bool?
    var productName, slug: String?
    var mainImage: String?
    var regularPrice: Double?
    var quantity: Int?
    var price: Double?
    var lang: languagesModel?
    var sku: String?
    var description: String?
    let salePrice: Double?
 
}
