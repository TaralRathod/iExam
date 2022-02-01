//
//  ResultViewController.swift
//  iExam
//
//  Created by Taral Rathod on 01/02/22.
//

import UIKit
import WebKit
import CoreData

class ResultViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var yourScoreLabel: UILabel!
    @IBOutlet weak var retakeTestBtn: UIButton!
    @IBOutlet weak var seeAnswersBtn: UIButton!

    var controllerData: Assessment?
    var navigator: Navigator?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigator = Navigator(vc: self)
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawCircle()
    }

    func setupUI() {
        retakeTestBtn.addCornerRadius(radius: 5.0, borderColor: .clear, borderWidth: 1.0)
        seeAnswersBtn.addCornerRadius(radius: 5.0, borderColor: .systemPink, borderWidth: 2.0)
        navigationController?.navigationBar.isHidden = true
        guard let url = URL(string: Constants.gifURL) else {return}
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func drawCircle() {
        let circleWidth = CGFloat(150)
        let circleHeight = circleWidth
        
        // Create a new CircleView
        let circleView = CircleView(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 75, y: (UIScreen.main.bounds.height / 2) - 75, width: circleWidth, height: circleHeight))
        
        view.addSubview(circleView)
        
        // Animate the drawing of the circle over the course of 1 second
        circleView.animateCircle(duration: 1.0)
    }

    func navigateToLandingScreen() {
        view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }

    @IBAction func retakeTestBtnTapped(_ sender: Any) {
        let fetchRequest = NSFetchRequest<Assessment>(entityName: Constants.assessmentEntity)
        fetchRequest.includesPropertyValues = false

        do {
            let results = try Constants.VIEW_CONTEXT.fetch(fetchRequest)

            for result in results {
                Constants.VIEW_CONTEXT.delete(result)
            }
            try Constants.VIEW_CONTEXT.save()
            navigateToLandingScreen()
        } catch {
            debugPrint("Result not found")
        }
    }

    @IBAction func seeAnsersBtnTapped(_ sender: Any) {
        if let controllers = self.navigationController?.viewControllers {
            for vc in controllers {
                if vc is QuestionsViewController {
                    guard let qVC = vc as? QuestionsViewController else {return}
                    qVC.isForAnswers = true
                    _ = self.navigationController?.popToViewController(qVC, animated: false)
                }
            }

        } else {
            guard let vc = self.navigator?.instantiateVC(withDestinationViewControllerType: QuestionsViewController.self) else { return }
            vc.controllerData = self.controllerData
            vc.isForAnswers = true
            let navController = UINavigationController(rootViewController: vc)
            self.navigator?.goTo(viewController: navController,
                                 withDisplayVCType: .present,
                                 andModalTransitionStyle: .crossDissolve)
        }
    }
}
