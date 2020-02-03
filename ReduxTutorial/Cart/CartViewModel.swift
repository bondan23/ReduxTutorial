//
//  CartViewModel.swift
//  ReduxTutorial
//
//  Created by Bondan Prasetyo on 31/01/20.
//  Copyright © 2020 Bondan Prasetyo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CartViewModel: ViewModelType {
    struct Input {
        let didLoadTrigger: Driver<Void>
        let globalSwitchTrigger: Driver<Bool>
    }
    
    struct Output {
        let cartData: Driver<Cart>
        let showLoading: Driver<Bool>
        let globalSwitchAction: Driver<CartAction>
    }
    
    let useCase: CartUseCase
    
    init(useCase: CartUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: CartViewModel.Input) -> CartViewModel.Output {
        let activityIndicator = ActivityIndicator()
        
        let cartData = input.didLoadTrigger.flatMap{ [useCase] in
            useCase
                .getCart()
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
        }
        
        let globalSwitchAction = input.globalSwitchTrigger.map {
            CartAction.globalSwitch($0)
        }
        
        return Output(
            cartData: cartData,
            showLoading: activityIndicator.asDriver(),
            globalSwitchAction: globalSwitchAction
        )
    }
}
