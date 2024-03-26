//
//  CollectionViewController.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 20.03.2024.
//

import UIKit

final class LocationCollection: UICollectionViewController {
    
    @IBOutlet var nextButton: UIBarButtonItem!
    @IBOutlet var previewButton: UIBarButtonItem!
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var rmLocations: RMLocation?
    private var filterLocations: [Location] = []
    private let networkManager = NetworkManager.shared
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocation(from: Link.locationUrl.url)
        setupSearchController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        let location = isFiltering ? filterLocations[indexPath.item] : rmLocations?.results[indexPath.item]
        if let detailVC = segue.destination as? DetailLocationVC {
            detailVC.location = location
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isFiltering ? filterLocations.count : rmLocations?.results.count ?? 0
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "viewLocation",
            for: indexPath
        )
        guard let cell = cell as? LocationCell else { return UICollectionViewCell() }
        let location = isFiltering ? filterLocations[indexPath.item] : rmLocations?.results[indexPath.item]
        cell.configure(with: location)
        return cell
    }
    
    @IBAction func updateData(_ sender: UIBarButtonItem) {
        sender.tag == 1
        ? fetchLocation(from: rmLocations?.info.next)
        : fetchLocation(from: rmLocations?.info.prev)
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Начните поиск"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func fetchLocation(from url: URL?) {
        networkManager.fetch(RMLocation.self, from: url) { [unowned self] result in
            switch result {
            case .success(let rickAndMortyLocation):
                rmLocations = rickAndMortyLocation
                collectionView.reloadData()
                nextButton.isEnabled = rmLocations?.info.next != nil
                previewButton.isEnabled = rmLocations?.info.prev != nil
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LocationCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.window?.windowScene?.screen.bounds.width ?? 0, height: 100)
    }
}

// MARK: - UISearchResultsUpdating
extension LocationCollection: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filterLocations = rmLocations?.results.filter({ location in
            location.name.lowercased().contains(searchText.lowercased())
        }) ?? []
        
        collectionView.reloadData()
    }
}
