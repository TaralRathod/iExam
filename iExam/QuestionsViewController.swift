//
//  QuestionsViewController.swift
//  iExam
//
//  Created by Taral Rathod on 23/01/22.
//

import UIKit

class QuestionsViewController: UIViewController {

    @IBOutlet weak var questionsCollectionView: UICollectionView!
    @IBOutlet weak var submitBtn: UIButton!

    var controllerData: ExamData?
    var questionsData: [QuestionData]?
    let questionsViewModel = QuestionsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupCollectionView()
        questionsData = questionsViewModel.getMCQs(questions: controllerData?.questions)
    }

    func setupUI() {
        view.setGradientBackground(topColor: UIColor(red: 88.0/255.0,
                                                          green: 86.0/255.0,
                                                          blue: 214.0/255.0, alpha: 1.0),
                                        bottomColor: UIColor(red: 175.0/255.0,
                                                             green: 82.0/255.0,
                                                             blue: 222.0/255.0, alpha: 1.0))
        submitBtn.addCornerRadius(radius: 10.0,
                                  borderColor: .clear,
                                  borderWidth: 1.0)
        title = "Questions"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.yellow]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    func setupCollectionView() {
        questionsCollectionView.delegate = self
        questionsCollectionView.dataSource = self
    }

    @IBAction func submitBtnTapped(_ sender: Any) {
    }
}

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
}
