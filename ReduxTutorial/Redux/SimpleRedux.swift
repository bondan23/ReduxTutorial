//
//  SimpleRedux.swift
//  ReduxTutorial
//
//  Created by Bondan Prasetyo on 31/01/20.
//  Copyright © 2020 Bondan Prasetyo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import NSObject_Rx

protocol Action {}

protocol StateType {}

typealias State = StateType

protocol Reducer {
    associatedtype State: StateType

    func reduce(_ state: State, action: Action) -> State
}

class Store<State: StateType>: NSObject {
    private let _dispatcher = PublishRelay<Action>()
    private let _state: BehaviorRelay<State>
    
    private(set) var state: State! {
        didSet {
            subscriptions.forEach {
                $0.newValues(oldState: oldValue, newState: state)
            }
        }
    }
    
    var subscriptions: Set<SubscriptionBox<State>> = []
    
    func dispatch(action: Action) {
        _dispatcher.accept(action)
    }
    
    private func _subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, originalSubscription: Subscription<State>,
        transformedSubscription: Subscription<SelectedState>?)
        where S.StoreSubscriberStateType == SelectedState
    {
        let subscriptionBox = SubscriptionBox(
            originalSubscription: originalSubscription,
            transformedSubscription: transformedSubscription,
            subscriber: subscriber
        )

        subscriptions.update(with: subscriptionBox)
    }
    
    func subscribe<SelectedState: Equatable, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<State>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState {
        // Create a subscription for the new subscriber.
        let originalSubscription = Subscription<State>()
        
         // Call the optional transformation closure. This allows callers to modify
        let transformedSubscription = transform?(originalSubscription).skipRepeats()
        
        _subscribe(subscriber,
                   originalSubscription: originalSubscription,
                   transformedSubscription: transformedSubscription
        )
    }
    
    init<R: Reducer>(reducer: R, state: State) where R.State == State {
        self._state = BehaviorRelay<State>(value: state)
        super.init()
        
        self.state = _state.value
        
        let actionState: Observable<State> = _dispatcher
            .withLatestFrom(_state) { (action, state) in
            
            return reducer.reduce(state, action: action)
        }
        
        actionState
            .do(onNext: { [_state] in
                _state.accept($0)
            })
            .subscribe(onNext: { [weak self] state in
                guard let self = self else {
                    return
                }
                
                self.state = state
            }).disposed(by: rx.disposeBag)
    }
    
    private func subscriptionBox<T>(
        originalSubscription: Subscription<State>,
        transformedSubscription: Subscription<T>?,
        subscriber: AnyStoreSubscriber
        ) -> SubscriptionBox<State> {

        return SubscriptionBox(
            originalSubscription: originalSubscription,
            transformedSubscription: transformedSubscription,
            subscriber: subscriber
        )
    }
}


public protocol AnyStoreSubscriber: AnyObject {
    func _newState(state: Any)
}

public protocol StoreSubscriber: AnyStoreSubscriber {
    associatedtype StoreSubscriberStateType

    func newState(state: StoreSubscriberStateType)
}

extension StoreSubscriber {
    // swiftlint:disable:next identifier_name
    public func _newState(state: Any) {
        if let typedState = state as? StoreSubscriberStateType {
            newState(state: typedState)
        }
    }
}
