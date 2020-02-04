//
//  RecommReducer.swift
//  ReduxTutorial
//
//  Created by Bondan Prasetyo on 03/02/20.
//  Copyright © 2020 Bondan Prasetyo. All rights reserved.
//

import Foundation

struct RecommReducer: Reducer {
    typealias State = RecommState
    
    func reduce(_ state: RecommState, action: Action) -> RecommState {
        var state = state
        
        if let action = action as? RecommAction {
            switch action {
                case .getRecommData(let data):
                    state.productRecom = data
            }
        }
        
        if let action = action as? CartAction {
            switch action {
            case .addToCart(let recomm):
                var mutated = state.productRecom
                if let index = mutated.firstIndex(where: { $0.product.id == recomm.product.id}) {
                    mutated.remove(at: index)
                }
                state.hideRecomm = mutated.isEmpty
                state.productRecom = mutated
            default:
                break
            }
        }
        
        return state
    }
}
