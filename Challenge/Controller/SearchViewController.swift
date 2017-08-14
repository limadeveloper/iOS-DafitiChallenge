//
//  SearchViewController.swift
//  Challenge
//
//  Created by John Lima on 13/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet fileprivate weak var backgroundImage: UIImageView!
    @IBOutlet fileprivate weak var navigationBarView: UIView!
    @IBOutlet fileprivate weak var navigationImage: UIImageView!
    @IBOutlet fileprivate weak var searchContainerView: UIView!
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate let cellName = "cell"
    fileprivate var selectedImage: UIImage?
    fileprivate var searchEnable = false
    fileprivate var searchController: UISearchController?
    fileprivate var searchModels: [Model]?
    
    var models: [Model]?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let searchBar = searchController?.searchBar, searchEnable else { return }
        
        searchBarCancelButtonClicked(searchBar)
        clearSearch()
    }
    
    // MARK: - Actions
    @IBAction private func dismiss(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateUI() {
        
        backgroundImage.image = #imageLiteral(resourceName: "Placeholder")
        navigationImage.image = #imageLiteral(resourceName: "Placeholder")
        backgroundImage.blur()
        navigationImage.blur()
        
        navigationBarView.setShadow(enable: true, shadowOpacity: 0.4)
        searchContainerView.setShadow(enable: true, shadowOpacity: 0.4)
        
        createSearch()
        
        let footer = UIView(frame: .zero)
        
        tableView.tableFooterView = footer
        tableView.backgroundColor = .clear
        tableView.allowsSelection = (models ?? []).count > 0
        tableView.reloadData()
    }
    
    fileprivate func createSearch() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.loadViewIfNeeded()
        searchController?.searchResultsUpdater = self
        
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.barStyle = .black
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.searchBar.tintColor = .white
        searchController?.searchBar.keyboardAppearance = .dark
        
        if let searchBar = searchController?.searchBar {
            searchContainerView.addSubview(searchBar)
        }
        
        searchController?.delegate = self
        
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.delegate = self
    }
    
    fileprivate func clearSearch() {
        searchModels = []
        searchEnable = false
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = searchEnable ? searchModels : models
        return (items ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        let imageView = cell.viewWithTag(1) as? UIImageView
        let titleLabel = cell.viewWithTag(2) as? UILabel
        let backgroundImageView = cell.viewWithTag(3) as? UIImageView
        
        guard let items = searchEnable ? searchModels : models else { return cell }
        
        titleLabel?.text = items[indexPath.row].movie?.title
        imageView?.image = #imageLiteral(resourceName: "Placeholder")
        backgroundImageView?.image = nil
        backgroundImageView?.unBlur()
        
        let model = items[indexPath.row]
        
        if let photoString = model.movie?.image?.getBestImagesByWidth()?.first, let photoUrl = URL(string: photoString) {
            
            model.movie?.image?.selectedUrl = photoUrl
            
            imageView?.af_setImage(withURL: photoUrl, placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            backgroundImageView?.af_setImage(withURL: photoUrl, placeholderImage: #imageLiteral(resourceName: "Placeholder"))
            
            backgroundImageView?.blur()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        let imageView = cell?.viewWithTag(1) as? UIImageView
        
        selectedImage = imageView?.image
        searchController?.isActive = false
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let items = searchEnable ? searchModels : models, items.count > 0 else { return }
        
        performSegue(withIdentifier: Constants.UI.Storyboard.Segue.details, sender: indexPath)
    }
}

extension SearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case Constants.UI.Storyboard.Segue.details:
            guard let indexPath = sender as? IndexPath else { return }
            let controller = segue.destination as? DetailsViewController
            let items = searchEnable ? searchModels : models
            controller?.model = items?[indexPath.row]
            controller?.selectedImage = selectedImage
        default:
            break
        }
    }
}

extension SearchViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        
        searchModels = []
        
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        
        for model in (models ?? []) {
            if (model.movie?.title ?? "").contains(searchText) {
                searchModels?.append(model)
            }
        }
        
        searchEnable = searchController.searchBar.showsCancelButton
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        tableView.allowsSelection = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarCancelButtonClicked(searchBar)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        clearSearch()
        tableView.allowsSelection = false
        searchBar.showsCancelButton = true
    }
}
