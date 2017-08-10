//
//  HomeController.swift
//  Challenge
//
//  Created by John Lima on 09/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    fileprivate var models: [Model]? = [Model]()
    fileprivate var index = Int()
    fileprivate let cellName = "cell"
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    fileprivate func loadData(page: Int = 1) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Requests.getMovies(page: page) { (jsonMovies, error) in
            
            func successFinish() {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.index = Int()
                    self.updateUI()
                }
            }
            
            func errorFinish(error: String?) {
                self.index = Int()
                let action = UIAlertAction(title: Constants.Text.done, style: .destructive, handler: nil)
                AlertUtil.showAlert(message: error, actions: [action], target: self)
            }
            
            func prepare(movies: [JSON]) {
                
                var model = Model(json: movies[self.index])
                
                guard let movie = model.movie else { errorFinish(error: error); return }
                
                Requests.getImages(for: movie) { (jsonImage, error) in
                    
                    if let jsonImage = jsonImage as? JSON, error == nil {
                        
                        model.movie?.image = Image(json: jsonImage)
                        
                        self.models?.append(model)
                        self.index += 1
                        
                        if self.index < movies.count {
                            prepare(movies: movies)
                        }else {
                            successFinish()
                        }
                    }else {
                        errorFinish(error: error)
                    }
                }
            }
            
            if let moviesJson = jsonMovies as? [JSON], error == nil {
                prepare(movies: moviesJson)
            }else {
                errorFinish(error: error)
            }
        }
    }
    
    fileprivate func updateUI() {
        
        view.backgroundColor = Constants.Color.dark
        
        collectionView?.backgroundColor = .clear
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView?.reloadData()
    }
}

// MARK: - ColletionView DataSource and Delegate
extension HomeController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = models {
            return items.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! HomeCollectionViewCell
        cell.model = models?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Movie: \(models?[indexPath.row].movie?.title ?? "---")")
    }
}
