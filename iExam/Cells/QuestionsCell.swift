//
//  QuestionsCell.swift
//  iExam
//
//  Created by Taral Rathod on 26/01/22.
//

import UIKit

class QuestionsCell: UITableViewCell {

    @IBOutlet weak var questionsLabel: KatexMathView!
    @IBOutlet weak var questionsLabelHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupUI(question: String) {
        questionsLabel.loadLatex(question)
    }

}
