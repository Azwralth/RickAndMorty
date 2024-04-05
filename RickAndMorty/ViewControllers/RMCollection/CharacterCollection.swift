//
//  MainViewCollectionViewController.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 16.03.2024.
//

import UIKit
import Kingfisher

final class CharacterCollection: UICollectionViewController {
    
    @IBOutlet var nextButton: UIBarButtonItem!
    @IBOutlet var previewsButton: UIBarButtonItem!
    
    // MARK: - Private properties
    private var searchController = UISearchController(searchResultsController: nil)
    private var rickAndMorty: RMCharacter?
    private var filterCharacters: [Character] = []
    private var networkManager = NetworkManager.shared
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        searchController.isActive && !searchBarIsEmpty
    }
    
    // MARK: - View life circle app
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCharacter(from: Link.characterUrl.url)
        setupSearchController()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        let chacarter = isFiltering ? filterCharacters[indexPath.item] : rickAndMorty?.results[indexPath.item]
        if let detailVC = segue.destination as? DetailCharacterViewController {
            detailVC.character = chacarter
        }
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        isFiltering ? filterCharacters.count : rickAndMorty?.results.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewCharacter", for: indexPath)
        guard let cell = cell as? CharacterCell else { return UICollectionViewCell() }
        let personage = isFiltering ? filterCharacters[indexPath.item] : rickAndMorty?.results[indexPath.item]
        cell.configure(with: personage)
        return cell
    }
    
    @IBAction func updateData(_ sender: UIBarButtonItem) {
        sender.tag == 1
        ? fetchCharacter(from: rickAndMorty?.info.next)
        : fetchCharacter(from: rickAndMorty?.info.prev)
    }
    
    @IBAction func clearCasheImage(_ sender: UIBarButtonItem) {
        let cashe = ImageCache.default
        cashe.clearMemoryCache()
        cashe.clearDiskCache { [unowned self] in
            let alert = UIAlertController(title: "Cashe cleared", message: "The image cache has been cleared successfully.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
    
    // MARK: - Private method
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Начните поиск"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func fetchCharacter(from url: URL?) {
        networkManager.fetch(RMCharacter.self, from: url) { [weak self] result in
            switch result {
            case .success(let rickAndMorty):
                self?.rickAndMorty = rickAndMorty
                self?.collectionView.reloadData()
                self?.previewsButton.isEnabled = rickAndMorty.info.prev != nil
                self?.nextButton.isEnabled = rickAndMorty.info.next != nil
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UISearchResultsUpdating
extension CharacterCollection: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filterCharacters = rickAndMorty?.results.filter({ character in
            character.name.lowercased().contains(searchText.lowercased())
        }) ?? []
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CharacterCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (view.window?.windowScene?.screen.bounds.width ?? 0) / 2 - 22, height: 220)
    }
}
