//
//  AppReducer.swift
//  ReduxTutorial
//
//  Created by Bondan Prasetyo on 03/02/20.
//  Copyright © 2020 Bondan Prasetyo. All rights reserved.
//

import Foundation

struct AppReducer: Reducer {
    func reduce(_ state: AppState, action: Action) -> AppState {
        return AppState(
            cart: CartReducer().reduce(state.cart, action: action),
            recomm: RecommReducer().reduce(state.recomm, action: action)
        )
    }
}
