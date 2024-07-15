//
//  typesense.swift
//  Bazaar Ghar
//
//  Created by Zany on 12/07/2024.
//



import Foundation
import Alamofire
//https://search.bazaarghar.com/db_live_products

class TypeSenseManager {
    static let shared = TypeSenseManager()
    let baseURL = "https://search.bazaarghar.com"
    let apiKey = "HS1Ic15Yt9Ly75Xx9SjQbOkzZSfqxebC"


   
    func search(completion: @escaping (Result<TypeSenseModel>) -> Void) {
        let parameters: [String: Any] = [
            "searches": [
                [
                    "query_by": "productName",
                    "highlight_full_fields": "productName",
                    "collection": "bg_stage_products",
                    "q": "*",
                    "facet_by": "averageRating,brandName,color,lvl0,price,size,style",
//                    "filter_by": "brandName:=[`AL Fajar Crockery`]",
                    "max_facet_values": 250,
                    "page": 1,
                    "per_page": 20
                ]
            ]
        ]

        let url = "https://search.bazaarghar.com/multi_search?x-typesense-api-key=RCWZ1ftzaBXQ3wjXwvT5velUhQJJlfdn"

        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
