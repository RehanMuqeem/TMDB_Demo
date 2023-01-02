//
//  DetailsTVCell.swift
//  TMDBMovies
//
//  Created by appinventiv on 28/12/22.
//

import UIKit

class DetailsTVCell: UITableViewCell {
    
    static let nib: UINib = UINib(nibName: "DetailsTVCell", bundle: nil)
    static let reuseId = "DetailsTVCell"
    
    @IBOutlet weak var tileLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(title: String, val: String, isLastCell: Bool) {
        self.tileLabel.text = title
        self.valueLabel.text = val
        self.separatorView.isHidden = isLastCell
    }
    
}
