//
//  PopularVC.swift
//  TMDBMovies
//
//  Created by appinventiv on 26/12/22.
//

import UIKit

/// ``Usage:``      `This controller is used as a segment to the container to display 'Popular'.`
/// ``How to Reach:``       `Launch the app -> You will land on this scren.
/// ``UI Components:``       `Used UICollectionView.`

protocol PopularVCDelegate: NSObjectProtocol {
    func tapOnPopularCell(with movieId: Int)
}

class PopularVC: BaseVC {
    
//  MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
//  MARK: - Properties
    private var isApiCallDone: Bool = false
    private var viewModel = PopularVM()
    weak var delegate: PopularVCDelegate?
    
//  MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !self.isApiCallDone {
            self.view.makeToastActivity(.center)
            self.viewModel.checkAndCallApiForPopular()
        }
    }
    
    override func bindDelegates() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func setupColors() {
        self.view.backgroundColor = .clear
        self.collectionView.backgroundColor = .clear
    }
    
//  MARK: - Private Functions
    private func setupCollectionView() {
        self.collectionView.layer.cornerRadius = 12.0
        self.collectionView.register(MovieListCVCell.nib, forCellWithReuseIdentifier: MovieListCVCell.reuseIdentifire)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        self.collectionView.collectionViewLayout = layout
    }
    
}

//MARK: - Extension UICollectionView Delegate and DataSource
extension PopularVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getRowCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCVCell.reuseIdentifire, for: indexPath) as? MovieListCVCell else {
            fatalError("MovieListCVCell Not found")
        }
        cell.configCell(cellVM: self.viewModel.getCellVM(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.tapOnPopularCell(with: self.viewModel.getMovieId(at: indexPath.row))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (UIScreen.width - 36)/2
        return CGSize(width: cellWidth, height: cellWidth * 1.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == self.viewModel.getRowCount() - 2) {
            self.view.makeToastActivity(.center)
            self.viewModel.checkAndCallApiForPopular()
        }
    }

}

//MARK: - Extension CommonApiCall Delegate (Api call Listeners)
extension PopularVC: CommonApiCallDelegate {
    
    func didFetchAPIResult(with success: Bool, msg: String) {
        self.view.hideToastActivity()
        if success {
            self.collectionView.reloadData()
            self.isApiCallDone = true
        } else {
            self.isApiCallDone = false
            self.view.makeToast(msg, position: .center)
        }
    }
    
}


extension PopularVC: HomeVMdelegate {
    func getAllMovies() -> [CommonMovieCellVM] {
        self.viewModel.getAllMoviesData()
    }
}
