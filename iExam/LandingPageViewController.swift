//
//  ViewController.swift
//  iExam
//
//  Created by Taral Rathod on 20/01/22.
//

import UIKit

class LandingPageViewController: UIViewController {

    @IBOutlet weak var appNameLabel: UILabel!

    var landingPageViewModel: LandingPageViewModel?
    var navigator: Navigator?

    override func viewDidLoad() {
        super.viewDidLoad()
        landingPageViewModel = LandingPageViewModel(delegate: self)
        navigator = Navigator(vc: self)
        setBackgroundColor()
        addShimmerEffect()
    }

    func setBackgroundColor() {
        view.setGradientBackground(topColor: UIColor(red: 88.0/255.0,
                                                          green: 86.0/255.0,
                                                          blue: 214.0/255.0, alpha: 1.0),
                                        bottomColor: UIColor(red: 175.0/255.0,
                                                             green: 82.0/255.0,
                                                             blue: 222.0/255.0, alpha: 1.0))
    }

    func addShimmerEffect() {
        appNameLabel.startShimmering()
    }

}

extension LandingPageViewController: LandingPageDelegate {
    func dataReceived(model: ExamData) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            appNameLabel.stopShimmering()
            guard let vc = self.navigator?.instantiateVC(withDestinationViewControllerType: InformationViewController.self) else { return }
            vc.controllerData = model
            self.navigator?.goTo(viewController: vc,
                                 withDisplayVCType: .present,
                                 andModalTransitionStyle: .crossDissolve)
        }
    }
}
