//
//  AppViewController.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
//import Lottie
import RxSwift
import RxCocoa

protocol AppViewControllerDatasource: ViewDatasource {
    var showError: Driver<Error?> { get }
}

class AppViewController: BaseViewController {
    
    @IBOutlet weak var animationContainerView: UIView!
   // private let animationView = AnimationView()

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.animationContainerView.addSubview(self.animationView)
//
//        let animation = Animation.named("manzanita_logo_loader")
//        self.animationView.animation = animation
//        self.animationView.contentMode = .scaleAspectFill
//        self.animationView.backgroundBehavior = .pauseAndRestore
//
//        self.animationView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            self.animationView.topAnchor.constraint(equalTo: self.animationContainerView.topAnchor),
//            self.animationView.leadingAnchor.constraint(equalTo: self.animationContainerView.leadingAnchor),
//            self.animationView.bottomAnchor.constraint(equalTo: self.animationContainerView.bottomAnchor),
//            self.animationView.trailingAnchor.constraint(equalTo: self.animationContainerView.trailingAnchor)
//        ])
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.animationView.play(fromProgress: 0, toProgress: 1, loopMode: LottieLoopMode.loop)
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.animationView.stop()
//    }
    
    override func setupInterfaceToDatasourceBindings(_ datasource: BaseViewControllerDatasource,
                                                     disposeBag: DisposeBag) {
        guard let datasource = datasource as? AppViewControllerDatasource else { return }
     
        datasource.showError
            .filter { $0 != nil }
            .map { $0! }
            .drive(self.showErrorBinder)
            .disposed(by: disposeBag)
    }
    
    private var showErrorBinder: Binder<Error> {
        return Binder(self) { target, error in
            
            guard let vc = UIApplication.getTopViewController() as? BaseViewController else { return }
            vc.displayAlert(withMessage: error.localizedDescription,
                            title: NSLocalizedString("BaseViewController.OperationFailed"),
                            actions: [.init(title: NSLocalizedString("BaseViewController.Ok"))],
                            animated: true)
        }
    }
}
