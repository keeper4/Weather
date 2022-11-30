//
//  MyTableView.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

protocol MyTableViewDatasource: ViewDatasource {
    var sections: Driver<[ViewDatasourceSection]>    { get }
    var selectDS: AnyObserver<ViewDatasource>        { get }
}

class MyTableView: WrapperView {
    
    @IBOutlet private(set) weak var tableView: UITableView! {
        didSet {
            self.tableView.registerCellWithNib(CityTVCell.self)
            self.tableView.backgroundColor = .clear
            self.tableView.allowsSelection = true
            self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
    
    override func commonInit() {
        super.commonInit()
        
    }
    
    override func setupInterfaceToDatasourceBindings(_ datasource: ViewDatasource, disposeBag: DisposeBag) {
        super.setupInterfaceToDatasourceBindings(datasource, disposeBag: disposeBag)
        
        guard let datasource = datasource as? MyTableViewDatasource else { return }
        
        self.tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        self.tableView.rx
            .modelSelected(ViewDatasource.self)
            .bind(to: datasource.selectDS)
            .disposed(by: disposeBag)
        
        datasource.sections
            .drive(self.tableView.rx.items(dataSource: self.tableViewDatasource))
            .disposed(by: disposeBag)
    }
    
    let tableViewDatasource = RxTableViewSectionedReloadDataSource<ViewDatasourceSection>(
        configureCell: { _, tableView, indexPath, datasource in
            
            let cell: BaseTableViewCell
            
            switch datasource {
            case is CityTVCellDatasource:
                cell = tableView.dequeueReusableCell(CityTVCell.self, indexPath: indexPath)
                
            default:
                fatalError("BaseTableViewCell datasource doesn't exists")
            }
            cell.datasource = datasource
            
            return cell
        }
    )
}

extension MyTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
