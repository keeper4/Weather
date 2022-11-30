//
//  UITableView+Extensions.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withIdentifier: cellType.className, for: indexPath) as! T
        return cell
    }
    
    func registerCellWithNib<T: UITableViewCell>(_ cellType: T.Type) {
        self.register(UINib(nibName: cellType.className, bundle: nil), forCellReuseIdentifier: cellType.className)
    }
    
    func registerCell<T: UITableViewCell>(_ cellType: T.Type) {
        self.register(cellType, forCellReuseIdentifier: cellType.className)
    }
    
    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type) {
        self.register(UINib(nibName: viewType.className, bundle: nil),
                      forHeaderFooterViewReuseIdentifier: viewType.className)
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type) -> T {
        let headerFooterView = self.dequeueReusableHeaderFooterView(withIdentifier: viewType.className) as! T
        return headerFooterView
    }
}

extension UITableView {

    func scrollToLast(isAnimated: Bool = true) {
        guard self.visibleCells.count > 0, self.numberOfRows(inSection: 0) > 5 else { return }
        let rows = self.numberOfRows(inSection: 0)
        if isAnimated {
            guard rows > 0 else { return }
            self.scrollToRow(at: IndexPath(row: rows - 1, section: 0), at: .bottom, animated: false)
        } else {
            guard rows > 5 else { return }
            let cell = self.cellForRow(at: IndexPath(row: rows - 5, section: 0))
            if let cell = cell, self.visibleCells.contains(cell) {
                self.scrollToRow(at: IndexPath(row: rows - 1, section: 0), at: .bottom, animated: false)
            }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
