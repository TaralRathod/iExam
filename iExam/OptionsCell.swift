//
//  OptionsCell.swift
//  iExam
//
//  Created by Twinkle Rathod on 24/01/22.
//

import UIKit

class OptionsCell: UITableViewCell {

    @IBOutlet weak var radioBtn: UIButton!
    @IBOutlet weak var optionTextLabel: KatexMathView!
    @IBOutlet weak var optionLabelHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupUI(option: String) {
        optionTextLabel.loadLatex(option)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func radioBtnTapped(_ sender: Any) {
    }
}
