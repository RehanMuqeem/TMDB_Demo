//
//  NowPlayingVC.swift
//  TMDBMovies
//
//  Created by appinventiv on 26/12/22.
//

import UIKit

/// ``Usage:``      `This controller is used as a segment to the container to display 'Now playing'.
/// ``How to Reach:``       `Launch the app -> You will land on this scren.
/// ``UI Components:``      `Used UICollectionView.`

protocol NowPlayingVCDelegate: NSObjectProtocol {
    func tapOnNowPlayingCell(with movieId: Int)
}

class NowPlayingVC: BaseVC {
    
//  MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
//  MARK: - Properties
    private var isApiCallDone: Bool = false
    private let viewModel = NowPlayingVM()
    weak var delegate: NowPlayingVCDelegate?
    
//  MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !self.isApiCallDone {
            self.view.makeToastActivity(.center)
            self.viewModel.checkAndCallApiForNowPlaying()
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
        collectionView!.collectionViewLayout = layout
    }

}

//MARK: - Extension UICollectionView Delegate and DataSource
extension NowPlayingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getRowCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCVCell.reuseIdentifire, for: indexPath) as? MovieListCVCell else {
            fatalError("MovieListCVCell Not found")
        }
        let cellVm = self.viewModel.getCellVM(at: indexPath.row)
        cell.configCell(cellVM: cellVm)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.tapOnNowPlayingCell(with: self.viewModel.getMovieId(at: indexPath.row))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (UIScreen.width - 36)/2
        return CGSize(width: cellWidth, height: cellWidth * 1.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (self.viewModel.getRowCount() - 4) {
            self.view.makeToastActivity(.center)
            self.viewModel.checkAndCallApiForNowPlaying()
        }
    }

}

//MARK: - Extension CommonApiCall Delegate (Api call Listeners)
extension NowPlayingVC: CommonApiCallDelegate {
    
    func didFetchAPIResult(with success: Bool, msg: String) {
        self.view.hideToastActivity()
        if success {
            self.collectionView.reloadData()
            self.isApiCallDone = true
        } else {
            self.isApiCallDone = true
            self.view.makeToast(msg, position: .center)
        }
    }
    
}

extension NowPlayingVC: HomeVMdelegate {
    
    func getAllMovies() -> [CommonMovieCellVM] {
        self.viewModel.getAllMoviesToPushOnsearchVC()
    }
    
}
