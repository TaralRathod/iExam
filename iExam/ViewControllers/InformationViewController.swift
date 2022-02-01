//
//  LandingPageViewController.swift
//  iExam
//
//  Created by Taral Rathod on 21/01/22.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var assignmentNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var marksLabel: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!

    var infoViewModel: InformationViewModel?
    var controllerData: Assessment?
    var navigator: Navigator?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigator = Navigator(vc: self)
        setupUI()
        populateData()
    }

    func setupUI() {
        view.setGradientBackground(topColor: UIColor(red: 88.0/255.0,
                                                          green: 86.0/255.0,
                                                          blue: 214.0/255.0, alpha: 1.0),
                                        bottomColor: UIColor(red: 175.0/255.0,
                                                             green: 82.0/255.0,
                                                             blue: 222.0/255.0, alpha: 1.0))
        assignmentNameLabel.addCornerRadius(radius: 10.0,
                                            borderColor: .clear,
                                            borderWidth: 0.0)
        subjectLabel.addCornerRadius(radius: 10.0,
                                            borderColor: .clear,
                                            borderWidth: 0.0)
        durationLabel.addCornerRadius(radius: 10.0,
                                            borderColor: .clear,
                                            borderWidth: 0.0)
        marksLabel.addCornerRadius(radius: 10.0,
                                            borderColor: .clear,
                                            borderWidth: 0.0)
        getStartedButton.addCornerRadius(radius: 10.0,
                                            borderColor: .clear,
                                            borderWidth: 0.0)
    }

    func populateData() {
        guard let data = controllerData else {return}
        assignmentNameLabel.text = Constants.assesmentName + (data.assessmentName ?? Constants.blankString)
        subjectLabel.text = Constants.subject + (data.subject ?? Constants.blankString)
        durationLabel.text = Constants.duration + String(describing: data.duration) + Constants.minutes
        marksLabel.text = Constants.totalMarks + String(describing: data.totalMarks)
    }

    @IBAction func getStartedBtnTapped(_ sender: Any) {
        DispatchQueue.main.async {
            guard let vc = self.navigator?.instantiateVC(withDestinationViewControllerType: QuestionsViewController.self) else { return }
            vc.controllerData = self.controllerData
            let navController = UINavigationController(rootViewController: vc)
            self.navigator?.goTo(viewController: navController,
                                 withDisplayVCType: .present,
                                 andModalTransitionStyle: .crossDissolve)
            
        }
    }
}
