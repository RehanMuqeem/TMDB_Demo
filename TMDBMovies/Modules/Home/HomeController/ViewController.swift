//
//  ViewController.swift
//  TMDBMovies
//
//  Created by appinventiv on 26/12/22.
//

import UIKit

/// ``Usage:``      `This controller is used as a container to display segmented control for 'Now playing' and 'Popular'.`
/// ``How to Reach:``       `Launch the app -> You will land on this scren.
/// ``UI Components:`` `Used UISegmentedControl, UIPageViewController() and other UI components.`


protocol HomeVMdelegate: NSObjectProtocol {
    func getAllMovies() -> [CommonMovieCellVM]
}

class ViewController: BaseVC {
        
//  MARK: - IBOutlets
    @IBOutlet weak var customNavView: UIView!
    @IBOutlet weak var customNavTitle: UILabel!
    @IBOutlet weak var segmentContainerView: UIView!
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet weak var pageContainerView: UIView!
    
//  MARK: - Properties
    private var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var childControllers: [UIViewController] = []
    weak var homeDelegate: HomeVMdelegate?
    
//  MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.setupPagingView()
        self.customNavView.roundParticularCorners(12.0, [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
    
}
    
//MARK: - Extension Private Functions
extension ViewController {

    private func setupPagingView() {
        self.addViewControllers()
        self.setupSegmentController()
        self.setupPageController()
        self.setHomeDelegate()
    }
    
    private func addViewControllers() {
        guard let popularVC = self.storyboard?.instantiateViewController(withIdentifier: "PopularVC") as? PopularVC else { return }
        popularVC.delegate = self
        guard let nowPlayingVC = self.storyboard?.instantiateViewController(withIdentifier: "NowPlayingVC") as? NowPlayingVC else { return }
        nowPlayingVC.delegate = self
        self.childControllers = [nowPlayingVC, popularVC]
    }
    
    private func setupSegmentController(){
        self.segmentedControl.setTitle("Now Playing", forSegmentAt: 0)
        self.segmentedControl.setTitle("Popular", forSegmentAt: 1)
    }
    
    private func setupSegmentIndex(){
        if (self.pageController.viewControllers?.first?.isKind(of: NowPlayingVC.self) ?? false) {
            self.segmentedControl.selectedSegmentIndex = 0
        } else {
            self.segmentedControl.selectedSegmentIndex = 1
        }
        self.setHomeDelegate()
    }
    
    private func setupPageController() {
        self.pageController.delegate = self
        self.pageController.dataSource = self
        self.pageController.view.frame = self.pageContainerView.bounds
        self.pageController.setViewControllers([self.childControllers.first!], direction: .forward, animated: true, completion: nil)
        self.pageContainerView.addSubview(self.pageController.view)
        self.pageController.didMove(toParent: self)
    }
    
    private func setHomeDelegate() {
        if let delegate = (self.pageController.viewControllers?.first as? NowPlayingVC) {
            self.homeDelegate = delegate
        } else {
            self.homeDelegate = (self.pageController.viewControllers?.first as? PopularVC)
        }
    }
    
}

//MARK: - Extension IBActions
extension ViewController {
    
    @IBAction func searchTapped(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchMovieVC") as? SearchMovieVC else { return }
        let movieData = self.homeDelegate?.getAllMovies() ?? []
        vc.setupVM(localCollection: movieData)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapPageController(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection
        if index == 0 {
            direction = .reverse
        } else {
            direction = .forward
        }
        self.pageController.setViewControllers([self.childControllers[index]], direction: direction, animated: true, completion: nil)
        self.setHomeDelegate()
    }
    
}

//MARK: - Extension UIPageViewController Delegate and DataSource
extension ViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.childControllers.firstIndex(of: viewController), index > 0 else { return nil }
        return self.childControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.childControllers.firstIndex(of: viewController), (index < (self.childControllers.count - 1)) else { return nil }
        return self.childControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        self.setupSegmentIndex()
    }
    
}

extension ViewController: NowPlayingVCDelegate, PopularVCDelegate {
    
//    func tapOnNowPlayingCell(with movieData: CommonMovieCellVM) {
    func tapOnNowPlayingCell(with movieId: Int) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC else { return }
//        vc.setupVMForMovieDetail(movieData.getItemData())
        vc.setupVM(movieId: movieId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func tapOnPopularCell(with movieData: CommonMovieCellVM) {
    func tapOnPopularCell(with movieId: Int) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC else { return }
        vc.setupVM(movieId: movieId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
