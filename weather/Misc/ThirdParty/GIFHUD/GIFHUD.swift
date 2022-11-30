//
//  GIFHUD.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

public class GIFHUD {

    /// HUD Window added on top of current window.
    /// - Default: nil
    fileprivate var hudWindow: UIWindow? = nil

    /// - `` shared instance
    public static var shared = GIFHUD()

    /// - `MKConfig` shared instance for the Progress HUD
    public static var config = GIFHUDConfig()

    /// Flag to indicate if dismiss animation is being played to dismiss the ProgressHUD
    fileprivate var isDismissing = false

    /// Flag to indicate if Progress is waiting for the timeInterval given before showing up
    fileprivate var isWaitingToShow = false

    /// Creating `UIWindow` to present Progress HUD
    /// 'ViewController' initialization and settting as rootViewController for the window.
    /// Returns 'UIWindow'.
    fileprivate func getHUDWindow() -> UIWindow {
        let hudWindow = UIWindow()
        hudWindow.frame = UIScreen.main.bounds
        hudWindow.isHidden = false
        hudWindow.windowLevel = UIWindow.Level.normal
        hudWindow.backgroundColor = UIColor.clear
        let controller = GIFHUDProgressViewController()
        hudWindow.rootViewController = controller
        return hudWindow
    }

    fileprivate func stopAnimatoins() {
        guard let rootViewController = self.hudWindow?.rootViewController else { return }
        (rootViewController as? GIFHUDProgressViewController)?.stopAnimations()
    }

    /// Showing Progress HUD
    /// - parameter animated: Flag to indicate if progress hud should appear with animation.
    /// - animated: Default: true
    public static func show(_ animated: Bool = true) {
        if shared.isDismissing {
            shared.isDismissing = false
            makeKeyWindowVisible(animated)
            return
        }

        guard shared.hudWindow == nil else { return }
        makeKeyWindowVisible(animated)
    }

    /// Presenting Progress window
    /// - parameter animated: Flag to indicate if progress hud should appear with animation.
    /// - animated: Default: true
    fileprivate static func makeKeyWindowVisible(_ animated: Bool) {
        shared.hudWindow = shared.getHUDWindow()
        shared.hudWindow?.makeKeyAndVisible()

        guard animated else { return }
        shared.playFadeInAnimation()
    }

    /// Shows progress hud after the given time interval
    /// - parameter wait: Wait interval before showing the progress hud.
    /// - wait: Default: 0.2 sec
    /// - parameter animated: Flag to handle the fadeIn animation on presenting.
    /// - animated: Default: true
    public static func show(after wait: TimeInterval = 0.2, animated: Bool = true) {
        shared.isWaitingToShow = true

        DispatchQueue.main.asyncAfter(deadline: .now() + wait) {[weak shared] in
            guard shared?.isWaitingToShow == true else { return }
            GIFHUD.show(animated)
        }
    }

    /// Plays fade in animation
    private func playFadeInAnimation() {
        guard let rootViewController = self.hudWindow?.rootViewController else { return }

        rootViewController.view.layer.opacity = 0.0

        UIView.animate(withDuration: GIFHUD.config.fadeInAnimationDuration, animations: {
            rootViewController.view.layer.opacity = 1.0
        })
    }

    /// Plays fade out animation
    private func playFadeOutAnimation(_ completion: ((Bool) -> Void)?) {
        guard let rootViewController = self.hudWindow?.rootViewController else { return }

        GIFHUD.shared.isDismissing = true

        rootViewController.view.layer.opacity = 1.0

        UIView.animate(withDuration: GIFHUD.config.fadeOutAnimationDuration, animations: {
            guard GIFHUD.shared.isDismissing else { return }
            rootViewController.view.layer.opacity = 0.0
        }, completion: completion)
    }

    /// Hiding the progress hud
    /// - parameter animated: Flag to handle the fadeOut animation on dismiss.
    /// - animated: Default: true
    public static func dismiss(_ animated: Bool = true) {
        let progress = GIFHUD.shared
        func hideProgressHud() {
            progress.isDismissing = false

            progress.stopAnimatoins()
            progress.hudWindow?.resignKey()
            progress.hudWindow = nil
        }

        GIFHUD.shared.isWaitingToShow = false

        if animated {
            progress.playFadeOutAnimation({ _ in
                guard GIFHUD.shared.isDismissing else { return }
                hideProgressHud()
            })
        } else {
            hideProgressHud()
        }
    }
}
