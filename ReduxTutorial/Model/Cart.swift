//
//  Cart.swift
//  ReduxTutorial
//
//  Created by Bondan Prasetyo on 31/01/20.
//  Copyright © 2020 Bondan Prasetyo. All rights reserved.
//

import Foundation

struct Product: Equatable {
    var isSelected: Bool
    let id: Int
    let name: String
    let price: Int
}


struct ProductGroup: Equatable  {
    let groupId: Int
    var products: [Product]
}

struct Cart {
    var productGroup: [ProductGroup]
}

extension Cart {
    static var initialState: Cart = Cart(productGroup: [])
}
