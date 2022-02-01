//
//  LandingPageViewModel.swift
//  iExam
//
//  Created by Taral Rathod on 21/01/22.
//

import Foundation
import CoreData

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
    func dataReceived(model: Assessment)
    func navigateToResultScreen(model: Assessment)
}

class LandingPageViewModel: LandingPageDelegate {
    weak var delegate: LandingPageDelegate?
    
    init(delegate: LandingPageDelegate) {
        self.delegate = delegate
        fetchData()
    }

    public func fetchData() {
        fetchAssessment { (result) in
            if result != nil && result?.count ?? 0 > 0 {
                let assessments = result?.filter({$0.assessmentId != nil})
                guard let assessment = assessments?.first else {return}
                if assessment.isSubmitted {
                    self.navigateToResultScreen(model: assessment)
                } else {
                    self.dataReceived(model: assessment)
                }
            } else {
                NetworkManager(data: nil, url: Constants.questionsURL, method: .get).executeQuery() {
                    (result: Result<ExamData,Error>) in
                    switch result{
                    case .success(let examModel):
                        self.storeDataInDatabase(model: examModel)
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
            }
        }
    }

    func dataReceived(model: Assessment) {
        delegate?.dataReceived(model: model)
    }

    func navigateToResultScreen(model: Assessment) {
        delegate?.navigateToResultScreen(model: model)
    }

    func storeDataInDatabase(model: ExamData) {
        var assessment: Assessment! = nil
        let entity = NSEntityDescription.entity(forEntityName: Constants.assessmentEntity, in: Constants.VIEW_CONTEXT)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.assessmentEntity)
        
        let assessmentId = model.assessmentId
        
        let predicate = NSPredicate(format: "assessmentId = %@", assessmentId ?? Constants.blankString)
        fetchRequest.predicate = predicate
        
        do {
            let result = try Constants.VIEW_CONTEXT.fetch(fetchRequest) as! [NSManagedObject]
            
            if(result.count == 0) {
                assessment = NSManagedObject(entity: entity!, insertInto: Constants.VIEW_CONTEXT) as? Assessment
                assessment.assessmentId = assessmentId
            } else {
                assessment = result.first as? Assessment
            }
            assessment = saveQuestions(data: model.questions, assessment: assessment)
            assessment.assessmentName = model.assessmentName
            assessment.duration = model.duration ?? 0.0
            assessment.subject = model.subject
            assessment.totalMarks = Int16(model.totalMarks ?? 0)
            assessment.isSubmitted = false
            do
            {
                try Constants.VIEW_CONTEXT.save()
                self.dataReceived(model: assessment)
                debugPrint ( "assessment Saved Successfully")
            } catch {
                debugPrint( "Failed To Saving")
            }
        } catch {
            debugPrint("failed")
        }
    }

    func saveQuestions(data: [QuestionData]?, assessment: Assessment) -> Assessment {

        let entity = NSEntityDescription.entity(forEntityName: Constants.questionsEntity, in: Constants.VIEW_CONTEXT)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.questionsEntity)
        guard let model = data else {return assessment}
        for q in model {
            let qId = q.id
            
            let predicate = NSPredicate(format: "id = %@", qId ?? Constants.blankString)
            fetchRequest.predicate = predicate
            
            do {
                let result = try Constants.VIEW_CONTEXT.fetch(fetchRequest) as! [NSManagedObject]
                var question: Questions! = nil
                if(result.count == 0) {
                    question = NSManagedObject(entity: entity!, insertInto: Constants.VIEW_CONTEXT) as? Questions
                    question.id = qId
                } else {
                    question = result.first as? Questions
                }
                question.marks = Int16(q.marks ?? 0)
                question.qno = Int16(q.qno ?? 0)
                question.text = q.text
                question.type = q.type
                var options: [[String: Bool]] = [[:]]
                for option in q.mcOptions! {
                    options.append([option: false])
                }
                question.mcOptions = options
                assessment.addToQuestions(question)
            } catch {
                debugPrint("failed")
            }
        }
        do
        {
            try Constants.VIEW_CONTEXT.save()
            debugPrint ( "Question Saved Successfully")
            return assessment
        } catch {
            debugPrint( "Failed To Saving")
            return assessment
        }
    }

    func fetchAssessment(handler: @escaping(([Assessment]?) -> Void)) {
        let fetchRequest = NSFetchRequest<Assessment>(entityName: Constants.assessmentEntity)
        do {
            let result = try Constants.VIEW_CONTEXT.fetch(fetchRequest)
            handler(result)
        } catch {
            debugPrint("Result not found")
            handler(nil)
        }
    }
}
