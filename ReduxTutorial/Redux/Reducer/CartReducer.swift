//
//  CartReducer.swift
//  ReduxTutorial
//
//  Created by Bondan Prasetyo on 31/01/20.
//  Copyright © 2020 Bondan Prasetyo. All rights reserved.
//

import Foundation

struct CartReducer: Reducer {
    typealias State = CartState
    
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        return formatter
    }
    
    private func grandTotal(data: [ProductGroup]) -> String {
        let grandTotal = data.map{
            $0.products
                .filter{ $0.isSelected }
                .map{
                    $0.price
                }.reduce(0) { (accumulate, next) -> Int in
                    return accumulate + next
                }
        }.reduce(0) { (accumulate, next) -> Int in
            return accumulate + next
        }
        
        let totalString = currencyFormatter.string(for: grandTotal) ?? "0"
        
        return "\(totalString)"
    }
    
    func reduce(_ state: CartState, action: Action) -> CartState {
        var state = state
        if let action = action as? CartAction {
            switch action {
            case .getData(let data):
                let totalPrice = grandTotal(data: data.productGroup)
                
                state.grandTotal = GrandTotalState.totalprice(totalPrice)
                state.cartData = data.productGroup
            case .showLoading(let isLoading):
                state.isLoading = isLoading ? LoadingState.showLoading : LoadingState.hideLoading
            case .globalSwitch(let isOn):
                let mutated = state.cartData.map{ val -> ProductGroup in
                    var mutated = val
                    let products = val.products.map({ product -> Product in
                        var mutated = product
                        mutated.isSelected = isOn
                        
                        return mutated
                    })
                    mutated.products = products
                    
                    return mutated
                }
                let totalPrice = grandTotal(data: mutated)
                state.grandTotal = GrandTotalState.totalprice(totalPrice)
                state.cartData = mutated
            case .toggleProductAt(let section, let index):
                var mutated = state.cartData
                let prevSelected = state.cartData[section].products[index].isSelected
                mutated[section].products[index].isSelected = !prevSelected
                let totalPrice = grandTotal(data: mutated)
                state.cartData = mutated
                state.grandTotal = GrandTotalState.totalprice(totalPrice)
            case .toggleShopAt(let section):
                var mutated = state.cartData
                let prevSelected = state.cartData[section].products.first?.isSelected ?? false
                let productMutated = mutated[section].products.map{ val -> Product in
                    var mut = val
                    mut.isSelected = !prevSelected
                    return mut
                }
                mutated[section].products = productMutated
                state.cartData = mutated
                let totalPrice = grandTotal(data: mutated)
                state.grandTotal = GrandTotalState.totalprice(totalPrice)
            case .addToCart(let recomm):
                let shopId = recomm.shopId
                var product = recomm.product
                product.isSelected = true
                var prevState = state.cartData
                if let getIndex = prevState.firstIndex(where: { $0.shopId == shopId}){
                    prevState[getIndex].products.append(product)
                } else {
                    prevState.append(
                        ProductGroup(shopId: shopId, products: [product])
                    )
                }
                
                state.cartData = prevState
                let totalPrice = grandTotal(data: prevState)
                state.grandTotal = GrandTotalState.totalprice(totalPrice)
            }
        }
        
        return state
    }
}
