//
//  LandingPageViewModel.swift
//  iExam
//
//  Created by Taral Rathod on 21/01/22.
//

import Foundation

struct ExamData: Codable {
    var assessmentId: String?
    var assessmentName: String?
    var subject: String?
    var duration: Double?
    var questions: [QuestionData]?
    var totalMarks: Int?
}

struct QuestionData: Codable {
    var id: String?
    var qno: Int?
    var text: String?
    var mcOptions: [String]?
    var type: String?
    var marks: Int?
}

protocol LandingPageDelegate: AnyObject {
    func dataReceived(model: ExamData)
}

class LandingPageViewModel: LandingPageDelegate {
    weak var delegate: LandingPageDelegate?
    
    init(delegate: LandingPageDelegate) {
        self.delegate = delegate
        fetchData()
    }

    public func fetchData() {
        NetworkManager(data: nil, url: Constants.questionsURL, method: .get).executeQuery() {
            (result: Result<ExamData,Error>) in
            switch result{
            case .success(let examModel):
                self.dataReceived(model: examModel)
            case .failure(let error):
                print(error)
            }
        }
    }

    func dataReceived(model: ExamData) {
        delegate?.dataReceived(model: model)
    }
}
