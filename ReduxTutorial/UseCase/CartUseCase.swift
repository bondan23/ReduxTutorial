//
//  CartUseCase.swift
//  ReduxTutorial
//
//  Created by Bondan Prasetyo on 31/01/20.
//  Copyright © 2020 Bondan Prasetyo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CartUseCase {
    var getCart = CartUseCase.getCart
    var getRecomm = CartUseCase.getRecomm
    
    static func getCart() -> Observable<Cart> {
        return Observable.just(
            Cart(productGroup: [
                ProductGroup(shopId: 1, products: [
                        Product(isSelected: true, id: 1, name: "Kolak", price: 10000),
                        Product(isSelected: true, id: 2, name: "Sambal", price: 20000)
                    ]
                ),
                ProductGroup(shopId: 2, products: [
                    Product(isSelected: true, id: 3, name: "Kalung", price: 15000),
                    Product(isSelected: true, id: 4, name: "Cincin", price: 50000)
                    ]
                )
            ])
        ).delay(.milliseconds(500), scheduler: MainScheduler.instance)
    }
    
    static func getRecomm() -> Observable<[Recommendation]> {
        return Observable.just([
            Recommendation(
                shopId: 1,
                product: Product(isSelected: false, id: 5, name: "Kuda", price: 99000)
            ),
            Recommendation(
                shopId: 2,
                product: Product(isSelected: false, id: 6, name: "Sapi", price: 25000)
            ),
            Recommendation(
                shopId: 3,
                product: Product(isSelected: false, id: 7, name: "Monyet", price: 25000)
            ),
            Recommendation(
                shopId: 3,
                product: Product(isSelected: false, id: 8, name: "Kambing", price: 15000)
            ),
        ]).delay(.milliseconds(500), scheduler: MainScheduler.instance)
    }
}
