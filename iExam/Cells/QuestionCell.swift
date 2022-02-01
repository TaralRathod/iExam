//
//  QuestionCell.swift
//  iExam
//
//  Created by Taral Rathod on 24/01/22.
//

import UIKit
import WebKit
import CoreData

class QuestionCell: UICollectionViewCell {

    @IBOutlet weak var optionsTableView: UITableView!
    
    var optionsArray: [[String: Bool]]?
    var content: [String] = []
    var contentHeights: [CGFloat]?
    var questionId = Constants.blankString
    var isForAnswers = false

    override func awakeFromNib() {
        setupTableView()
    }

    func setupUI(question: Questions) {
        optionsArray = question.mcOptions
        questionId = question.id ?? Constants.blankString
        content = [question.text ?? Constants.blankString]
        for option in question.mcOptions! {
            content.append(option.keys.first ?? Constants.blankString)
        }
        contentHeights = [CGFloat](repeating: 0.0, count: content.count)
    }

    func setupTableView() {
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.tableFooterView = UIView()
    }

    func updateValueInStore() {
        let fetchRequest = NSFetchRequest<Questions>(entityName: Constants.questionsEntity)
        let predicate = NSPredicate(format: "id = %@", questionId)
        fetchRequest.predicate = predicate
        do {
            let result = try Constants.VIEW_CONTEXT.fetch(fetchRequest)
            if result.count == 1 {
                guard let question = result.first else {return}
                question.mcOptions = optionsArray
                try Constants.VIEW_CONTEXT.save()
                debugPrint ( "Question Saved Successfully")
            }
        } catch {
            debugPrint("Result not found")
        }
    }
}

extension QuestionCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (optionsArray?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.questionsCell, for: indexPath) as? QuestionsCell else {return UITableViewCell()}
            cell.setupUI(question: content[indexPath.row])
            cell.questionsLabel.navigationDelegate = self
            cell.questionsLabel.tag = indexPath.row + 100
            let htmlHeight = contentHeights?[indexPath.row]
            cell.questionsLabelHeight.constant = htmlHeight ?? 0
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.optionsCell, for: indexPath) as? OptionsCell else {return UITableViewCell()}
            guard let option = optionsArray?[indexPath.row] else {return UITableViewCell()}
            cell.setupUI(option: option.keys.first ?? Constants.blankString)
            tableView.separatorColor = indexPath.row == 1 ? .white : .gray
            cell.optionTextLabel.navigationDelegate = self
            cell.optionTextLabel.tag = indexPath.row + 100
            let htmlHeight = contentHeights?[indexPath.row]
            cell.optionLabelHeight.constant = htmlHeight ?? 0
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = isForAnswers ? false : true
            cell.accessoryType = option.values.first ?? false ? .checkmark : .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
                guard let array = optionsArray else {return}
                for (index, var dict) in array.enumerated() {
                    let key = dict.keys.first
                    dict[key ?? Constants.blankString] = index == indexPath.row ?  true : false
                    optionsArray?[index] = dict
                    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
                updateValueInStore()
            }
    }
    
}

extension QuestionCell: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    if self.contentHeights?[webView.tag - 100] == 0.0 {
                        DispatchQueue.main.async {
                            self.contentHeights?[webView.tag - 100] = height as! CGFloat + CGFloat(15.0)
                            self.optionsTableView.reloadRows(at: [IndexPath(row: webView.tag - 100, section: 0)], with: .automatic)
                            webView.layoutIfNeeded()
                        }
                    }
                })
            }
            
        })
    }
}
