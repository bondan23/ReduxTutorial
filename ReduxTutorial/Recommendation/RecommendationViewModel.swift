//
//  RecommendationViewModel.swift
//  ReduxTutorial
//
//  Created by Bondan Prasetyo on 03/02/20.
//  Copyright © 2020 Bondan Prasetyo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RecommendationViewModel: ViewModelType {
    struct Input {
        let didLoadTrigger: Driver<Void>
    }
    
    struct Output {
        let recomData: Driver<[Recommendation]>
        let showLoading: Driver<Bool>
    }
    
    let useCase: CartUseCase
    
    init(useCase: CartUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let recomData = input.didLoadTrigger.flatMap{ [useCase] in
            useCase
                .getRecomm()
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
        }
        
        return Output(
            recomData: recomData,
            showLoading: activityIndicator.asDriver()
        )
    }
}
