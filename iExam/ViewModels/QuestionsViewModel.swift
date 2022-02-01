//
//  QuestionsViewModel.swift
//  iExam
//
//  Created by Taral Rathod on 24/01/22.
//

import Foundation


class QuestionsViewModel {
    init() {
        
    }

    func getMCQs(questions: NSOrderedSet?) -> [Questions]? {
        guard let qs = questions else {return nil}
        var returnArray: [Questions] = []
        for question in qs {
            if let q = question as? Questions, q.type == "MC" {
                returnArray.append(q)
            }
        }
        return returnArray
    }

    func getQuestions(questions: [Questions]?) -> [String] {
        var data: [String] = []
        if let questions = questions {
            for question in questions {
                data.append(question.text ?? Constants.blankString)
            }
        }
        return data
    }
}
