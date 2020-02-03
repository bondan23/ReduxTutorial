//
//  ProductCartViewController.swift
//  ReduxTutorial
//
//  Created by Bondan Prasetyo on 31/01/20.
//  Copyright © 2020 Bondan Prasetyo. All rights reserved.
//

import UIKit

class ProductCartViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var indicator = UIActivityIndicatorView()
    
    private var dataSource = [ProductGroup]()
    private let store: Store<CartState>
    
    init(store: Store<CartState>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        
        self.store.subscribe(self) {
            $0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.\
        setupTableView()
        
        activityIndicator()
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.large
        self.view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        indicator.startAnimating()
    }


    func setupTableView() {
        let nib = UINib(nibName: "ProductCartTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.sectionHeaderHeight = 50
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }

}

extension ProductCartViewController: StoreSubscriber {
    func newState(state: CartState) {
        if state.isLoading == .hideLoading, indicator.isAnimating {
            indicator.stopAnimating()
        }
        
        if !state.cartData.isEmpty {
            dataSource = state.cartData
            tableView.reloadData()
        }
    }

}

extension ProductCartViewController: UITableViewDataSource {
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        return formatter
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource[section].products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataSource[indexPath.section].products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCartTableViewCell
        
        cell.label.text = data.name
        cell.switchBox.setOn(data.isSelected, animated: false)
        
        cell.switchBox
        .rx
        .isOn
        .changed
        .asDriver()
        .drive(onNext:{ [store] _ in
            store.dispatch(action: CartAction.toggleProductAt(
                section: indexPath.section,
                index: indexPath.row
            ))
        })
        .disposed(by: cell.disposeBag)

        let price = currencyFormatter.string(for: data.price) ?? "0"
        cell.priceLabel.text = price

        return cell
    }
}

extension ProductCartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let data = dataSource[section]
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let uiswitch =  UISwitch()
        view.addSubview(uiswitch)
        let label = UILabel()
        label.text = "Toko \(data.groupId)"
        view.addSubview(label)
        
        // When there is any item not selected
        // this section will automate turn off
        let getIsSelected = data.products.first(where: { $0.isSelected == false })
        uiswitch.setOn(getIsSelected == nil, animated: false)
        
        uiswitch.rx
        .isOn
        .changed
        .asDriver()
        .drive(onNext:{ [store] _ in
            store.dispatch(action: CartAction.toggleShopAt(section: section))
        })
        .disposed(by: rx.disposeBag)
        
        uiswitch.snp.makeConstraints { maker in
            maker.centerY.equalTo(view.snp.centerY)
            maker.leading.equalTo(view.snp.leading).offset(8)
        }
        
        label.snp.makeConstraints { maker in
            maker.centerY.equalTo(uiswitch.snp.centerY)
            maker.leading.equalTo(uiswitch.snp.trailing).offset(8)
        }
        
        return view
    }
}
