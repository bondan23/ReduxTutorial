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
    
    
    init(store: Store<AppState>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupCollectionView()
    }
    
    private func bindViewModel() {
        
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



extension RecommendationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"recomCollection", for: indexPath) as? RecomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.atcButton.rx.tap.asDriver().drive(onNext: { [store] _ in
            print("HELLO")
        }).disposed(by: cell.disposeBag)
        
        return cell
    }
    
    
}
