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
    @IBOutlet private weak var collectionView: UICollectionView!
    
    fileprivate var models: [Model]? = [Model]()
    fileprivate var index = Int()
    fileprivate let cellName = "cell"
    fileprivate var page = 1
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate var selectedImage: UIImage?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        setupRefreshControl()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    @IBAction private func goSearch(sender: UIButton) {
        performSegue(withIdentifier: Constants.UI.Storyboard.Segue.search, sender: nil)
    }
    
    fileprivate func loadData(page: Int = 1) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Requests.getMovies(page: page) { [weak self] (jsonMovies, error) in
            
            func successFinish() {
                DispatchQueue.main.async {
                    
                    // Remove duplicates
                    if let models = self?.models, models.count > 0 {
                        var result = [Model]()
                        for model in models {
                            let hasData = result.filter({ $0.movie?.title == model.movie?.title }).count > 0
                            guard !hasData else { continue }
                            result.append(model)
                        }
                        self?.models = result
                    }
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self?.index = Int()
                    self?.page = page
                    self?.refreshControl.endRefreshing()
                    self?.updateUI()
                }
            }
            
            func errorFinish(error: String?) {
                DispatchQueue.main.async {
                    
                    self?.index = Int()
                    self?.refreshControl.endRefreshing()
                    
                    let action = UIAlertAction(title: Constants.Text.done, style: .destructive, handler: nil)
                    AlertUtil.showAlert(message: error ?? Constants.API.Errors.getErrorMessage(byCode: 0), actions: [action], target: self)
                }
            }
            
            func prepare(movies: [JSON]) {
                
                var model = Model(json: movies[self?.index ?? 0])
                
                guard let movie = model.movie else { errorFinish(error: error); return }
                
                Requests.getImages(for: movie) { (jsonImage, error) in
                    
                    if let jsonImage = jsonImage as? JSON, error == nil {
                        
                        model.movie?.image = Image(json: jsonImage)
                        
                        self?.models?.append(model)
                        self?.index += 1
                        
                        if self?.index ?? 0 < movies.count {
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
    
    private func updateUI() {
        
        navigationItem.title = NSLocalizedString(Constants.Text.movies, comment: "")
        
        view.backgroundColor = Constants.Color.dark
        
        collectionView.contentInset.top = 5
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.reloadData()
        
        print("Page: \(page)")
        print("Count: \(models?.count ?? 0)")
    }
    
    private func setupRefreshControl() {
        
        refreshControl.tintColor = Constants.Color.yellow
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        loadData()
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let models = models, models.count > 0 else { return }
        let lastItem = models.count-1
        if indexPath.row == lastItem {
            loadData(page: self.page+1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        NotificationCenter.default.removeObserver(cell, name: Constants.NotificationObserver.Name.didClickOnLikedButton, object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell
        selectedImage = cell?.imageView.image
        performSegue(withIdentifier: Constants.UI.Storyboard.Segue.details, sender: indexPath)
    }
}

extension HomeController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case Constants.UI.Storyboard.Segue.details:
            guard let indexPath = sender as? IndexPath else { return }
            let controller = segue.destination as? DetailsViewController
            controller?.model = models?[indexPath.row]
            controller?.selectedImage = selectedImage
        case Constants.UI.Storyboard.Segue.search:
            let controller = segue.destination as? SearchViewController
            controller?.models = models
        default:
            break
        }
    }
}
