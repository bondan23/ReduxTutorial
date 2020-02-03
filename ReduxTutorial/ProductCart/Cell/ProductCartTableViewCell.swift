//
//  ProductCartTableViewCell.swift
//  CartPOC
//
//  Created by Bondan Eko Prasetyo on 05/09/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import RxSwift
import UIKit

class ProductCartTableViewCell: UITableViewCell {

    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var label: UILabel!
    @IBOutlet var switchBox: UISwitch!
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
