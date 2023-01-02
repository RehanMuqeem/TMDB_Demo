//
//  CastCrewTVCell.swift
//  TMDBMovies
//
//  Created by appinventiv on 02/01/23.
//

import UIKit
import Kingfisher

class CastCrewTVCell: UITableViewCell {
    
    static let nib: UINib = UINib(nibName: "CastCrewTVCell", bundle: nil)
    static let reuseId = "CastCrewTVCell"

    @IBOutlet weak var imageCrewMember: UIImageView!
    @IBOutlet weak var labelCrewName: UILabel!
    @IBOutlet weak var labelCharacterName: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.imageCrewMember.contentMode = .scaleAspectFill
        self.imageCrewMember.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(name: String, moviChar: String, profilePic: String, isLastCell: Bool) {
        let nameBaseText = ("Name: " + name)
        let nameAttText = NSMutableAttributedString(string: nameBaseText)
        let nameRange = (nameAttText.string as NSString).range(of: "Name:")
        nameAttText.addAttributes([.foregroundColor: UIColor.blue, .font: UIFont.systemFont(ofSize: 16, weight: .bold)], range: nameRange)
        self.labelCrewName.attributedText = nameAttText
//        self.labelCrewName.text = "Name: " + name
        let charBaseText = ("Character: " + moviChar)
        let charAttText = NSMutableAttributedString(string: charBaseText)
        let charRange = (charAttText.string as NSString).range(of: "Character:")
        charAttText.addAttributes([.foregroundColor: UIColor.blue, .font: UIFont.systemFont(ofSize: 16, weight: .bold)], range: charRange)
        self.labelCharacterName.attributedText = charAttText
//        self.labelCharacterName.text = "Character: " + moviChar
        if profilePic.isEmpty {
        } else {
            let url = URL(string: AppConstants.imageBaseUrl.rawValue + profilePic)
            self.imageCrewMember.kf.setImage(with: url)
        }
        self.separatorView.isHidden = isLastCell
    }
    
}
