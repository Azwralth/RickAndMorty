//
//  CollectionViewController.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 20.03.2024.
//

import UIKit

final class LocationCollection: UICollectionViewController {
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var locations: [Location] = []
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
        let location = isFiltering ? filterLocations[indexPath.item] : locations[indexPath.item]
        if let detailVC = segue.destination as? DetailLocationVC {
            detailVC.location = location
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isFiltering ? filterLocations.count : locations.count
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
        let location = isFiltering ? filterLocations[indexPath.item] : locations[indexPath.item]
        cell.configure(with: location)
        return cell
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Начните поиск"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func fetchLocation(from url: URL?) {
        networkManager.fetch(RMLocation.self, from: url) { [weak self] result in
            switch result {
            case .success(let locationData):
                self?.rmLocations = locationData
                guard let currentLocation = self?.locations.count else { return }
                self?.locations.append(contentsOf: locationData.results)
                let indexPath = (currentLocation..<(self?.locations.count ?? 0)).map { IndexPath(item: $0, section: 0)}
                self?.collectionView.performBatchUpdates {
                    self?.collectionView.insertItems(at: indexPath)
                }
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
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = locations.count - 1
        if indexPath.item == lastItem, let nextPageURL = rmLocations?.info.next {
            fetchLocation(from: nextPageURL)
        }
    }
}
// MARK: - UISearchResultsUpdating
extension LocationCollection: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filterLocations = locations.filter({ location in
            location.name.lowercased().contains(searchText.lowercased())
        })
        
        collectionView.reloadData()
    }
}
