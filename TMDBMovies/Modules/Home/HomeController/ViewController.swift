//
//  ViewController.swift
//  TMDBMovies
//
//  Created by appinventiv on 26/12/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var segmentContainerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var pageContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    private func setupCollectionView() {
//        self.collectionView.register(MovieListCVCell.nib, forCellWithReuseIdentifier: MovieListCVCell.reuseIdentifire)
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
//    }
    
    private func setupPagingView() {
        self.addViewControllers()
    }
    
    private func addViewControllers() {
        let popularVC = AppRouter.shared.getPopularVC()
        let nowPlayingVC = AppRouter.shared.getNowPlayingVC()
        self.childControllers = [popularVC, nowPlayingVC]
    }
    }

}

//extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCVCell.reuseIdentifire, for: indexPath) as? MovieListCVCell else {
//            fatalError("MoviewListCVCell Not found")
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
//
//}
