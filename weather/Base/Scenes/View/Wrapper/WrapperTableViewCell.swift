//
//  WrapperTableViewCell.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

import RxSwift

class WrapperTableViewCell: BaseTableViewCell, XibPackedContentLoading {
    
    @IBOutlet private(set) var xibLoadedContentView: UIView!
    
    var xibContainerView: UIView {
        return self.contentView
    }
    
    override func commonInit() {
        super.commonInit()
        
        self.loadContentViewFromXib()
    }
}
