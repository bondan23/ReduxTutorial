//
//  CartAction.swift
//  ReduxTutorial
//
//  Created by Bondan Prasetyo on 31/01/20.
//  Copyright © 2020 Bondan Prasetyo. All rights reserved.
//

import Foundation

enum CartAction: Action {
    case getData(Cart)
    case showLoading(Bool)
    case globalSwitch(Bool)
    case toggleProductAt(section: Int, index: Int)
    case toggleShopAt(section: Int)
    case addToCart(Recommendation)
}
