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
                ProductGroup(groupId: 1, products: [
                        Product(isSelected: true, id: 1, name: "Kolak", price: 10000),
                        Product(isSelected: true, id: 2, name: "Sambal", price: 20000)
                    ]
                ),
                ProductGroup(groupId: 2, products: [
                    Product(isSelected: true, id: 3, name: "Kalung", price: 15000),
                    Product(isSelected: true, id: 4, name: "Cincin", price: 50000)
                    ]
                )
            ])
        ).delay(.milliseconds(500), scheduler: MainScheduler.instance)
    }
    
    static func getRecomm() -> Observable<[Product]> {
        return Observable.just([
            Product(isSelected: false, id: 3, name: "Kuda", price: 15000),
            Product(isSelected: false, id: 4, name: "Sapi", price: 50000),
            Product(isSelected: false, id: 3, name: "Kadal", price: 25000),
            Product(isSelected: false, id: 4, name: "Kucing", price: 13500),
        ]).delay(.milliseconds(500), scheduler: MainScheduler.instance)
    }
}
