//
//  RecomCollectionViewCell.swift
//  ReduxTutorial
//
//  Created by Bondan Prasetyo on 02/02/20.
//  Copyright © 2020 Bondan Prasetyo. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class RecomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var atcButton: UIButton!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var shopName: UILabel!
    var disposeBag = DisposeBag()
    
    class var reuseIdentifier: String {
        return "recomCollection"
    }
    
    class var nibName: String {
        return "RecomCollectionViewCell"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    }

}
