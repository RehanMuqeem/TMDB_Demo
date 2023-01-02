//
//  MovieDetailVC.swift
//  TMDBMovies
//
//  Created by appinventiv on 27/12/22.
//

/// ``Usage:``      `This controller is used to display the local and remote of the selected movie.`
/// ``How to Reach:``       `Launch the app -> tap on any grid/cell -> You will land on this scren OR at home screen tap on search button in top right corner -> tap on any movie or search a movie name then tap at any result if available.
/// ``UI Components:``       `Used UITableView and custom Navigation bar with title and back button.`

import UIKit

class MovieDetailVC: BaseVC {
    
//  MARK: - IBOutlets
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var customNavView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
//  MARK: - Properties
    private var viewModel: MovieDetailVM?
    
//  MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel?.delegate = self
        self.view.makeToastActivity(.center)
    }
    
    override func initialSetup() {
        self.tableView.register(PosterDetailTVCell.nib, forCellReuseIdentifier: PosterDetailTVCell.reuseId)
        self.tableView.register(DetailsTVCell.nib, forCellReuseIdentifier: DetailsTVCell.reuseId)
        self.tableView.register(CastCrewTVCell.nib, forCellReuseIdentifier: CastCrewTVCell.reuseId)
        self.customNavView.roundParticularCorners(12.0, [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
    
    override func bindDelegates() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
//  MARK: - Setup View Model
    func setupVM(movieId: Int) {
        guard self.viewModel == nil else { return }
        self.viewModel = MovieDetailVM(movieId: movieId)
    }
    
//  MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Extension UITableView Delegate and DataSource
extension MovieDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel?.getSectionsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.viewModel?.getSections(at: section) {
        case .detailSection, .castingActors, .genreSection:
            return 30.0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MovieDetailHeaderView()
        switch self.viewModel?.getSections(at: section) {
        case .detailSection:
            headerView.titleLabel.text = "Movie details"
            return headerView
        case .castingActors:
            headerView.titleLabel.text = "Casting actors"
            return headerView
        case .genreSection:
            headerView.titleLabel.text = "Movie genres"
            return headerView
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.getCellsCount(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (self.viewModel?.getCellType(at: indexPath) ?? .posterCell)
        let isLast = indexPath.row == ((self.viewModel?.getCellsCount(in: indexPath.section) ?? 0) - 1)
        switch cell {
        case .posterCell:
            guard let posterCell = tableView.dequeueReusableCell(withIdentifier: PosterDetailTVCell.reuseId, for: indexPath) as? PosterDetailTVCell else { return UITableViewCell() }
            let posterData = self.viewModel?.getCellValue(at: indexPath)
            posterCell.configPosterCell(posterUrlStr: posterData?.1 ?? "", desc: posterData?.0 ?? "")
            return posterCell
            
        case .detailCell:
            guard let detailCell = tableView.dequeueReusableCell(withIdentifier: DetailsTVCell.reuseId, for: indexPath) as? DetailsTVCell else { return UITableViewCell() }
            let cellData = self.viewModel?.getCellValue(at: indexPath)
            detailCell.configCell(title: cellData?.0 ?? "", val: cellData?.1 ?? "", isLastCell: isLast)
            return detailCell
            
        case .castCell:
            guard let detailCell = tableView.dequeueReusableCell(withIdentifier: CastCrewTVCell.reuseId, for: indexPath) as? CastCrewTVCell else { return UITableViewCell() }
            let cellData = self.viewModel?.getCellValue(at: indexPath)
            let logo = self.viewModel?.getMovieCrewPoster(at: indexPath.row) ?? ""
            detailCell.configCell(name: cellData?.0 ?? "", moviChar: cellData?.1 ?? "", profilePic: logo, isLastCell: isLast)
            return detailCell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK: - Extension MovieDetailVM Delegate (Api call listeners)
extension MovieDetailVC: MovieDetailVMDelegate {
    
    func didFetchMovieDetail(isSuccess: Bool, movieName: String) {
        self.view.hideToastActivity()
        if isSuccess {
            DispatchQueue.main.async {
                self.movieTitle.text = movieName
                self.tableView.reloadData()
            }
        }
    }
    
}
