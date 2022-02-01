//
//  QuestionsViewController.swift
//  iExam
//
//  Created by Taral Rathod on 23/01/22.
//

import UIKit
import CoreData

class QuestionsViewController: UIViewController {

    // Storyboard outlets
    @IBOutlet weak var questionsCollectionView: UICollectionView!
    @IBOutlet weak var submitBtn: UIButton!

    // Variables and Constants
    let questionsViewModel = QuestionsViewModel()
    var controllerData: Assessment?
    var questionsData: [Questions]?
    var timerLabel: UILabel?
    var duration: Int = 0
    var timer: Timer?
    var navigator: Navigator?
    var isForAnswers = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        setupCollectionView()
        addNotificationListner()
        questionsData = questionsViewModel.getMCQs(questions: controllerData?.questions)
        navigator = Navigator(vc: self)
        questionsCollectionView.reloadData()
    }

    func setupUI() {
        view.setGradientBackground(topColor: UIColor(red: 88.0/255.0,
                                                          green: 86.0/255.0,
                                                          blue: 214.0/255.0, alpha: 1.0),
                                        bottomColor: UIColor(red: 175.0/255.0,
                                                             green: 82.0/255.0,
                                                            blue: 222.0/255.0, alpha: 1.0))
        // Adding radius to submit button
        submitBtn.addCornerRadius(radius: 10.0,
                                  borderColor: .clear,
                                  borderWidth: 1.0)

        // Navigationbar related changes
        title = !isForAnswers ? Constants.questionTitle : Constants.answerTitle
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.yellow,
                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35.0, weight: .heavy)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        // Condition based checks
        if !isForAnswers {
            submitBtn.setTitle(Constants.submitBtn, for: .normal)
            guard let navFrame = navigationController?.navigationBar.frame else {return}
            timerLabel = UILabel(frame: CGRect(x: navFrame.maxX - 90, y: 8, width: 80, height: 30))
            timerLabel?.textColor = .systemPink
            timerLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
            duration = Int((controllerData?.duration ?? 1800) * 60)
            navigationController?.navigationBar.addSubview(timerLabel!)
            startTimer()
        } else {
            submitBtn.setTitle(Constants.retakeBtn, for: .normal)
        }
    }

    // Starting the Timer
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(eventWith(timer:)),
                                     userInfo: nil,
                                     repeats: true)
    }

    // Timer expects @objc selector
    @objc func eventWith(timer: Timer!) {
        self.duration -= 1
        self.timerLabel?.text = secondsToHoursMinutesSeconds(self.duration)
        if self.duration == 0 {
            submitTest()
        }
    }
    
    /// Get TimeStemp
    /// - Parameter seconds: Passing seconds to convert into time
    /// - Returns: Time remaining string
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> String {
        return ("\(String(seconds / 3600)): \(String((seconds % 3600) / 60)): \(String((seconds % 3600) % 60))")
    }

    /// Collection view related setup
    func setupCollectionView() {
        questionsCollectionView.delegate = self
        questionsCollectionView.dataSource = self
    }

    /// Adding notification for foreground and background
    func addNotificationListner() {
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] notification in
            if !(self?.isForAnswers ?? false) {
                guard let dict = UserDefaults.standard.value(forKey: Constants.timeValue) as? [String: Any] else {return}
                guard let fromDate = dict[Constants.timestemp] as? Date else { self?.submitTest()
                    return
                }
                let dateComponentsFormatter = DateComponentsFormatter()
                guard let diff = dateComponentsFormatter.difference(from: Date(), to: fromDate) else { self?.submitTest()
                    return
                }
                guard let leftTime = dict[Constants.timeLeft] as? Double else {return}
                Double(diff) ?? 0.0 >= leftTime ? self?.submitTest() : self?.startTimer()
            }
        }

        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self] notification in
            if !(self?.isForAnswers ?? false) {
                let dict = [Constants.timeLeft: self?.duration ?? 0.0, Constants.timestemp: Date()] as [String : Any]
                UserDefaults.standard.setValue(dict, forKey: Constants.timeValue)
            }
        }
    }

    /// Saving answered questions and navigating to score screen
    func submitTest() {
        UserDefaults.standard.setValue(nil, forKey: Constants.timeValue)
        let fetchRequest = NSFetchRequest<Assessment>(entityName: Constants.assessmentEntity)
        do {
            let result = try Constants.VIEW_CONTEXT.fetch(fetchRequest)
            let assessments = result.filter({$0.assessmentId != nil})
            guard let assessment = assessments.first else {return}
            assessment.isSubmitted = true
            try Constants.VIEW_CONTEXT.save()
            navigateToResultsViewController()
            debugPrint ( "Assessment Saved Successfully")
        } catch {
            debugPrint("Result not found")
        }
    }

    /// Navigating user to results view
    func navigateToResultsViewController() {
        DispatchQueue.main.async {
            guard let vc = self.navigator?.instantiateVC(withDestinationViewControllerType: ResultViewController.self) else { return }
            vc.controllerData = self.controllerData
            self.navigator?.goTo(viewController: vc, withDisplayVCType: .push)
            self.timer?.invalidate()
        }
    }

    /// Removing stored data and navigating user to Landing screen
    func navigateToLandingPage() {
        let fetchRequest = NSFetchRequest<Assessment>(entityName: Constants.assessmentEntity)
        fetchRequest.includesPropertyValues = false

        do {
            let results = try Constants.VIEW_CONTEXT.fetch(fetchRequest)

            for result in results {
                Constants.VIEW_CONTEXT.delete(result)
            }
            try Constants.VIEW_CONTEXT.save()
            view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        } catch {
            debugPrint("Result not found")
        }
    }

    /// Submit button action
    @IBAction func submitBtnTapped(_ sender: Any) {
        guard let btn = sender as? UIButton else {return}
        btn.titleLabel?.text == Constants.submitBtn ? submitTest() : navigateToLandingPage()
    }
}

/// Collectionview Delegate and Datasource method
extension QuestionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.questionCell, for: indexPath) as? QuestionCell else {return UICollectionViewCell()}
        cell.addCornerRadius(radius: 10.0,
                             borderColor: .clear,
                             borderWidth: 1.0)
        guard let question = questionsData?[indexPath.row] else {return UICollectionViewCell()}
        cell.setupUI(question: question)
        cell.isForAnswers = isForAnswers
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.frame.width - 16 - 20))
        return CGSize(width: width, height: collectionView.frame.height - 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth: Float = Float(self.questionsCollectionView.frame.width - 10 - 20)
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        let targetOffset: Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0

        if targetOffset > currentOffset {
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
        } else {
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
        }

        if newTargetOffset < 0 {
            newTargetOffset = 0
        } else if (newTargetOffset > Float(scrollView.contentSize.width)) {
            newTargetOffset = Float(Float(scrollView.contentSize.width))
        }
        
        targetContentOffset.pointee.x = CGFloat(currentOffset)
        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)
    }
}
