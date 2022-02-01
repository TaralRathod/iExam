//
//  Constants.swift
//  iExam
//
//  Created by Taral Rathod on 23/01/22.
//

import Foundation
import UIKit

struct Constants {
    // Storyboard Constants
    static let mainStroyboard = "Main"
    static let infoViewController = "InformationViewController"
    static let questionsViewController = "QuestionsViewController"
    static let resultsViewController = "ResultViewController"

    // Webservice Constants
    static let questionsURL = "https://assessed-da.s3-ap-southeast-1.amazonaws.com/exam/exam.json"
    static let gifURL = "https://cliply.co/wp-content/uploads/2021/09/CLIPLY_372109170_FREE_FIREWORKS_400.gif"

    // InformationViewController Constants
    static let subject = "Subject: "
    static let assesmentName = "Assessment: "
    static let duration = "Duration: "
    static let totalMarks = "Total Marks: "
    static let minutes = " mins"

    // QuestionsViewController Constants
    static let retakeBtn = "Retake Test"
    static let submitBtn = "Submit"
    static let questionTitle = "Questions"
    static let answerTitle = "Answers"
    
    // Cell Identifiers Constants
    static let questionCell = "questionCell"
    static let questionsCell = "questionsCell"
    static let optionsCell = "optionsCell"

    // Database Entity Constants
    static let assessmentEntity = "Assessment"
    static let questionsEntity = "Questions"
    
    // Utility Constants
    static let blankString = ""

    // Userdefaults Constatnts
    static let timestemp = "timeStemp"
    static let timeLeft = "timeLeft"
    static let timeValue = "timeValue"

    static let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
    static let VIEW_CONTEXT = APPDELEGATE.persistentContainer.viewContext
}
