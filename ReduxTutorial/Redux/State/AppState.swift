//
//  CartState.swift
//  ReduxTutorial
//
//  Created by Bondan Prasetyo on 31/01/20.
//  Copyright © 2020 Bondan Prasetyo. All rights reserved.
//

import Foundation

enum LoadingState: Int, Equatable {
    case showLoading
    case hideLoading
}

enum GrandTotalState: Equatable {
    case totalprice(String)
}

struct CartState: Equatable, State {
    var cartData: [ProductGroup] = []
    var isLoading: LoadingState = .showLoading
    var grandTotal: GrandTotalState = .totalprice("Rp.0")
}

struct AppState: Equatable, State {
    var cart = CartState()
}
