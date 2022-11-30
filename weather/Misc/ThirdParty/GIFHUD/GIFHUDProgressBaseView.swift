//
//  GIFHUDProgressBaseView.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

protocol ProgressViewDataSource {
    func configureView()
}

protocol ProgressViewDataDelegate {
    func stopAnimation()
}

class GIFHUDProgressBaseView: UIView, ProgressViewDataSource, ProgressViewDataDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Fatal error occurred while setup!")
    }

    func configureView() {
        let config = GIFHUD.config
        clipsToBounds = true
        layer.cornerRadius = config.cornerRadius
        backgroundColor = config.hudColor
    }

    func stopAnimation() {
        // Implement to provide functionality
    }
}
