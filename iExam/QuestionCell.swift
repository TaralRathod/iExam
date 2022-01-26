//
//  QuestionCell.swift
//  iExam
//
//  Created by Twinkle Rathod on 24/01/22.
//

import UIKit
import WebKit

class QuestionCell: UICollectionViewCell {

    @IBOutlet weak var optionsTableView: UITableView!
    
    var optionsArray: [String]?
    var content: [String] = []
    var contentHeights: [CGFloat]?

    override func awakeFromNib() {
        setupTableView()
    }

    func setupUI(question: QuestionData) {
        optionsArray = question.mcOptions
        content = [question.text ?? Constants.blankString]
        content.append(contentsOf: question.mcOptions ?? [String]())
        contentHeights = [CGFloat](repeating: 0.0, count: content.count)
    }

    func setupTableView() {
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.tableFooterView = UIView()
    }
}

extension QuestionCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (optionsArray?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.questionsCell, for: indexPath) as? QuestionsCell else {return UITableViewCell()}
            cell.setupUI(question: content[indexPath.row])
            cell.questionsLabel.navigationDelegate = self
            cell.questionsLabel.tag = indexPath.row + 100
            let htmlHeight = contentHeights?[indexPath.row]
            cell.questionsLabelHeight.constant = htmlHeight ?? 0
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.optionsCell, for: indexPath) as? OptionsCell else {return UITableViewCell()}
            guard let option = optionsArray?[indexPath.row - 1] else {return UITableViewCell()}
            cell.setupUI(option: option)
            cell.optionTextLabel.navigationDelegate = self
            cell.optionTextLabel.tag = indexPath.row + 100
            let htmlHeight = contentHeights?[indexPath.row]
            cell.optionLabelHeight.constant = htmlHeight ?? 0
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
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
