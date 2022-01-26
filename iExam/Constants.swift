//
//  Constants.swift
//  iExam
//
//  Created by Taral Rathod on 23/01/22.
//

import Foundation

struct Constants {
    // Storyboard Constants
    static let mainStroyboard = "Main"
    static let infoViewController = "InformationViewController"
    static let questionsViewController = "QuestionsViewController"

    // Webservice Constants
    static let questionsURL = "https://assessed-da.s3-ap-southeast-1.amazonaws.com/exam/exam.json"

    // InformationViewController Constants
    static let subject = "Subject: "
    static let assesmentName = "Assessment: "
    static let duration = "Duration: "
    static let totalMarks = "Total Marks: "
    static let minutes = " mins"

    // Cell Identifiers Constants
    static let questionCell = "questionCell"
    static let questionsCell = "questionsCell"
    static let optionsCell = "optionsCell"
    
    // Utility Constants
    static let blankString = ""
}
