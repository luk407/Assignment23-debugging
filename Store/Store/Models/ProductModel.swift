//
//  ProductModel.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import Foundation

struct ProductModel: Decodable { // switched to decodable
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    var stock: Int // changed to var
    let brand: String
    let category: String
    let thumbnail: String
    let images: [String]
    var selectedAmount: Int? // remove optional to see error handling
}

