//
//  PosterDetailTVCell.swift
//  TMDBMovies
//
//  Created by appinventiv on 28/12/22.
//

import UIKit
import Kingfisher


class PosterDetailTVCell: UITableViewCell {
    
    static let nib: UINib = UINib(nibName: "PosterDetailTVCell", bundle: nil)
    static let reuseId = "PosterDetailTVCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var noPosterLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var posterheight: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initialSetup() {
        self.containerView.layer.cornerRadius = 12.0
        self.containerView.backgroundColor = AppColors.pageControlGray
        self.poster.roundParticularCorners(12.0, [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        self.poster.contentMode = .scaleToFill
        self.posterheight.constant = UIScreen.width * 1.618 ///(Golden Ratio)
    }
    
    func configPosterCell(posterUrlStr: String, desc: String) {
        let baseText = desc
        let attText = NSMutableAttributedString(string: baseText)
        let range = (attText.string as NSString).range(of: "Description and Overview:")
        attText.addAttributes([.foregroundColor: UIColor.blue, .font: UIFont.systemFont(ofSize: 16, weight: .bold)], range: range)
        self.labelDesc.attributedText = attText
//        self.labelDesc.text = desc
//        self.poster.downloadImage(from: posterUrlStr)
        if posterUrlStr.isEmpty {
            self.noPosterLabel.isHidden = false
            self.posterheight.constant = 20
            self.poster.isHidden = true
        } else {
            let url = URL(string: AppConstants.imageBaseUrl.rawValue + posterUrlStr)
            self.poster.kf.setImage(with: url)        }
    }
    
}
