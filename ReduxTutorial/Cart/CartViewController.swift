//
//  CartViewController.swift
//  ReduxTutorial
//
//  Created by Bondan Prasetyo on 31/01/20.
//  Copyright © 2020 Bondan Prasetyo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class CartViewController: UIViewController {
    @IBOutlet weak var globalSwitch: UISwitch!
    @IBOutlet weak var productCartWrapper: UIView!
    @IBOutlet weak var grandTotalPrice: UILabel!
    @IBOutlet weak var recomWrapper: UIView!
    @IBOutlet weak var wrapperHeight: NSLayoutConstraint!
    
    private let store = Store(reducer: AppReducer(), state: AppState())
    private let viewModel = CartViewModel(useCase: CartUseCase())
    private var isShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        store.subscribe(self) {
            return $0
        }
        
        bindViewModel()
        
        let productCart = ProductCartViewController(store: store)
        addChild(productCart)
        productCart.didMove(toParent: self)
        self.productCartWrapper.addSubview(productCart.view)
        productCart.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let recomm = RecommendationViewController(store: store)
        addChild(recomm)
        recomm.didMove(toParent: self)
        self.recomWrapper.addSubview(recomm.view)
        recomm.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bindViewModel() {
        let input = CartViewModel.Input(
            didLoadTrigger: .just(()),
            globalSwitchTrigger: globalSwitch.rx.isOn.changed.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        output.cartData.drive(onNext: { [store] cart in
            store.dispatch(action: CartAction.getData(cart))
        })
        .disposed(by: rx.disposeBag)

        output.showLoading.drive(onNext: {  [store] loading in
            store.dispatch(action: CartAction.showLoading(loading))
        })
        .disposed(by: rx.disposeBag)
        
        output.globalSwitchAction.drive(onNext:{ [store] action in
            store.dispatch(action: action)
        })
        .disposed(by: rx.disposeBag)
    }

}


extension CartViewController: StoreSubscriber {
    func newState(state: AppState) {
        if case let .totalprice(price) = state.cart.grandTotal {
            grandTotalPrice.text = price
        }
        
        if state.recomm.hideRecomm {
            wrapperHeight.constant = 0
        }
    }
}
