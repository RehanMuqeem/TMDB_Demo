//
//  SearchMovieVC.swift
//  TMDBMovies
//
//  Created by appinventiv on 29/12/22.
//

import UIKit

/// ``Usage:``      `This controller is used to display the local and remote of the searched movie.`
/// ``How to Reach:``       `Launch the app -> at Home screen tap on search button in top right corner.
/// ``UI Components:``      `Used UISearchBar, UICollectionView and custom Navigation bar with title and back button.`

class SearchMovieVC: BaseVC {
    
//  MARK: - IBOutlets
    @IBOutlet weak var customNavView: UIView!
    @IBOutlet weak var customNavTitle: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
//  MARK: - Properties
    private var viewModel = SearchMovieVM()
    
//  MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
    }
    
    override func initialSetup() {
        self.customNavView.roundParticularCorners(12.0, [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        self.collectionView.layer.cornerRadius = 12.0
    }
    
    override func bindDelegates() {
        self.searchBar.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(MovieListCVCell.nib, forCellWithReuseIdentifier: MovieListCVCell.reuseIdentifire)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        self.collectionView.keyboardDismissMode = .onDrag
        collectionView!.collectionViewLayout = layout
    }
    
//  MARK: - Setup View Model
    func setupVM(localCollection: [CommonMovieCellVM]) {
        self.viewModel.setLocalCollection(data: localCollection)
    }
    
//  MARK: - IBActions
    @IBAction func backTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK: - Extension UICollectionView Delegate and DataSource
extension SearchMovieVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getRowsCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCVCell.reuseIdentifire, for: indexPath) as? MovieListCVCell else {
            fatalError("MovieListCVCell Not found in project")
        }
        cell.configCell(cellVM: self.viewModel.getCellVM(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC else { return }
        vc.setupVM(movieId: self.viewModel.getMovieId(at: indexPath.row))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (UIScreen.width - 36)/2
        return CGSize(width: cellWidth, height: cellWidth * 1.8)
    }

}

//MARK: - Extension SearchMovieVM Delegate (Called when the searched text presents in local or fetched from remote)
extension SearchMovieVC: SearchMovieVMDelegate {
    func getRemoteData(isSuccess: Bool, count: Int) {
        self.view.hideToastActivity()
        if isSuccess {
            self.collectionView.restore()
            self.collectionView.reloadData()
            if count == 0 {
                self.collectionView.setEmptyMessage("No data found...\n Try to search another name")
            }
        } else {
            self.view.makeToast("Something went wrong")
        }
    }
}

//MARK: - Extension UISearchBar Delegate
extension SearchMovieVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return !(text.isContainEmoji() || text.containsSpecialCharacters())
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(requestToSearch(_:)), with: searchText, afterDelay: 1.0)
    }
    
    @objc func requestToSearch(_ serchText: String) {
        printDebug(">>> \(serchText)")
        self.view.makeToastActivity(.center)
        self.viewModel.getMovieByName(name: serchText)
    }
    
}
