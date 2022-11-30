//
//  GIFHUDProgressViewController.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

class GIFHUDProgressViewController: UIViewController {

    var background: GIFHUDProgressBackgroundView = {
        let bg = GIFHUDProgressBackgroundView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        return bg
    }()

    var indicator: GIFHUDActivityIndicatorView = {
        let indicator = GIFHUDActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    internal override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(background)

        let x = background.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let y = background.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let w = background.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0)
        let h = background.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0)

        NSLayoutConstraint.activate([x, y, w, h])

        self.addProgressHudView()
    }

    private func addProgressHudView() {
            background.addSubview(indicator)
            self.setupConstraint(indicator)
    }

    private func setupConstraint(_ view: GIFHUDProgressBaseView) {
        let config = GIFHUD.config

        let x = view.centerXAnchor.constraint(equalTo: background.centerXAnchor)
        let y = view.centerYAnchor.constraint(equalTo: background.centerYAnchor, constant: -config.hudYOffset)
        let w = view.widthAnchor.constraint(equalToConstant: config.width)
        let h = view.heightAnchor.constraint(equalToConstant: config.height)

        NSLayoutConstraint.activate([x, y, w, h])
    }

    public func stopAnimations() {
        self.indicator.stopAnimation()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        super.loadViewIfNeeded()
    }

    internal override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
            return rootViewController.supportedInterfaceOrientations
        } else {
            return UIInterfaceOrientationMask.portrait
        }
    }

    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return GIFHUD.config.preferredStatusBarStyle
    }

    internal override var prefersStatusBarHidden: Bool {
        return GIFHUD.config.prefersStatusBarHidden
    }

    internal override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
            return rootViewController.preferredStatusBarUpdateAnimation
        } else {
            return .none
        }
    }

    internal override var shouldAutorotate: Bool {
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
            return rootViewController.shouldAutorotate
        } else {
            return false
        }
    }
}
