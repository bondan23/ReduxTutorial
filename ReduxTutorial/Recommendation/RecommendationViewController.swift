//
//  RecommendationViewController.swift
//  ReduxTutorial
//
//  Created by Bondan Prasetyo on 03/02/20.
//  Copyright © 2020 Bondan Prasetyo. All rights reserved.
//

import UIKit

class RecommendationViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private let store: Store<AppState>
    private let viewModel = RecommendationViewModel(useCase: CartUseCase())
    private var dataSource = [Recommendation]()
    
    
    init(store: Store<AppState>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        
        store.subscribe(self) {
            $0.select{
                $0.recomm
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupCollectionView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = RecommendationViewModel.Input(
            didLoadTrigger: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.recomData.drive(onNext: { [store] recomm in
            store.dispatch(action: RecommAction.getRecommData(recomm))
        })
        .disposed(by: rx.disposeBag)

        
    }

    private func setupCollectionView() {
        
        let nib = UINib(nibName: "RecomCollectionViewCell", bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier:"recomCollection")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.sectionInset  = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView.collectionViewLayout = layout
    }

}

extension RecommendationViewController: StoreSubscriber {
    func newState(state: RecommState) {
        dataSource = state.productRecom
        collectionView.reloadData()
    }
}

extension RecommendationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        return formatter
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"recomCollection", for: indexPath) as? RecomCollectionViewCell else {
            return UICollectionViewCell()
        }
        let data = dataSource[indexPath.row]
        
        cell.shopName.text = "Toko \(data.shopId)"
        cell.itemName.text = data.product.name
        cell.priceLabel.text = currencyFormatter.string(from: data.product.price as NSNumber)
        
        cell.atcButton.rx.tap.asDriver().drive(onNext: { [store] _ in
            store.dispatch(action: CartAction.addToCart(data))
        }).disposed(by: cell.disposeBag)
        
        return cell
    }
    
    
}
