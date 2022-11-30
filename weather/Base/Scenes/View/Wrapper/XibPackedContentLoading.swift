//
//  XibPackedContentLoading.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

public protocol XibPackedContentLoading {
    
    static var xibNameContainingContentView: String { get }
    
    var xibLoadedContentView: UIView! { get }
    var xibContainerView: UIView { get }
}

extension XibPackedContentLoading where Self: UIView {
    
    static var xibNameContainingContentView: String {
        return String(describing: self)
    }
    
    var xibContainerView: UIView {
        return self
    }
    
    func loadContentViewFromXib() {
        _ = Bundle.main.loadNibNamed(type(of: self).xibNameContainingContentView, owner: self, options: nil)
        assert(self.xibLoadedContentView != nil,
               """
xibLoadedContentView was not loaded from xib file.
Make sure xibLoadedContentView has IBOutlet attribute and is properly linked in the xib file
""")
        self.xibContainerView.addSubviewExpanded(self.xibLoadedContentView)
    }
}
