//
//  QuestionsViewModel.swift
//  iExam
//
//  Created by Twinkle Rathod on 24/01/22.
//

import Foundation


class QuestionsViewModel {
    init() {
        
    }

    func getMCQs(questions: [QuestionData]?) -> [QuestionData]? {
        return questions?.filter({$0.type == "MC"})
    }

    func getQuestions(questions: [QuestionData]?) -> [String] {
        var data: [String] = []
        if let questions = questions {
            for question in questions {
                data.append(question.text ?? Constants.blankString)
            }
        }
        return data
    }
}
