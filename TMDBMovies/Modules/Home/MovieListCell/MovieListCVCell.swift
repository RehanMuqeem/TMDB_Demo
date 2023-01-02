//
//  MoviewListCVCell.swift
//  TMDBMovies
//
//  Created by appinventiv on 26/12/22.
//

import UIKit
import Kingfisher

class MovieListCVCell: UICollectionViewCell {
    
    static let nib = UINib(nibName: "MovieListCVCell", bundle: nil)
    static let reuseIdentifire = "MovieListCVCell"
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var labelMovieName: UILabel!
    @IBOutlet weak var labelRating: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    private func setupUI() {
        self.contentView.backgroundColor = AppColors.pageControlGray.withAlphaComponent(0.5)
        self.layer.cornerRadius = 12
        self.poster.contentMode = .scaleAspectFill
        self.poster.roundParticularCorners(12.0, [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        self.labelMovieName.textColor = .black
        self.labelRating.textColor = .darkGray
    }
    
    func configCell(cellVM: CommonMovieCellVM) {
        self.labelMovieName.text = cellVM.getMovieTitle()
        self.labelRating.text = "\(cellVM.getMovieRatings())/10"
        let posterStr = cellVM.getMoviePoster()
        if posterStr.isEmpty {
        } else {
            let url = URL(string: AppConstants.imageBaseUrl.rawValue + posterStr)
            self.poster.kf.setImage(with: url)
        }
//        self.poster.downloadImage(from: cellVM.getMoviePoster())
    }
    
//    func configCellForPopular(cellVM: PopularCellVM) {
//        self.labelMovieName.text = cellVM.getMovieTitle()
//        self.labelRating.text = "\(cellVM.getMovieRatings())/10"
//        self.poster.downloadImage(from: cellVM.getMoviePoster())
//    }

}

extension UIImageView {
    
    func sendRequest(_ url: String, parameters: [String: String]) {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let imageData = UIImage(data: data)?.jpegData(compressionQuality: 0.3)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = UIImage(data: imageData)
            }
        }
        task.resume()
    }
    
    func downloadImage(from link: String) {
        let params: [String: String] = ["api_key": AppConstants.apiKey.rawValue]
        let completeLink = AppConstants.imageBaseUrl.rawValue + link
        sendRequest(completeLink, parameters: params)
    }
    
}

class CommonMovieCellVM {
    
    private var nowPlayingCellData: CommonMoviesResult
    
    init(_ cellModel: CommonMoviesResult) {
        self.nowPlayingCellData = cellModel
    }
    
    func getMoviePoster() -> String { (self.nowPlayingCellData.posterPath ?? "") }
    func getMovieTitle() -> String { self.nowPlayingCellData.originalTitle ?? "" }
    func getMovieRatings() -> Double { self.nowPlayingCellData.voteAverage ?? 0.0 }
    func getMovieId() -> Int { self.nowPlayingCellData.id ?? 0 }
    
}
