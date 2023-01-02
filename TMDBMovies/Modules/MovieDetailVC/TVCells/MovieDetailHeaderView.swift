//
//  MovieDetailHeaderView.swift
//  TMDBMovies
//
//  Created by appinventiv on 28/12/22.
//

import UIKit

class MovieDetailHeaderView: UIView, NibLoadable {
    
    static let nib = UINib(nibName: "MovieDetailHeaderView", bundle: nil)
    static let reuseId = "MovieDetailHeaderView"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        //for using custom View in code
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        // for using customView in IB
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit(){
        setUpLoadableView()
        self.initialSetup()
    }

    private func initialSetup() {
        self.titleLabel.textColor = .black
        self.titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
}

protocol NibLoadable {
    func setUpLoadableView()
}

extension NibLoadable where Self: UIView {
    
    func setUpLoadableView() {
        
        if let view = viewFromNib() {
            view.frame = self.bounds
            addSubview(view)
        }
    }
    
    private func viewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            return view
        }
        return nil
    }
    
}
