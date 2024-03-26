//
//  MainViewCollectionViewController.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 16.03.2024.
//

import UIKit

final class CharacterCollection: UICollectionViewController {
    
    @IBOutlet var nextButton: UIBarButtonItem!
    @IBOutlet var previewsButton: UIBarButtonItem!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCharacter(from: Link.characterUrl.url)
        setupSearchController()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        let chacarter = isFiltering ? filterCharacters[indexPath.item] : rickAndMorty?.results[indexPath.item]
        if let detailVC = segue.destination as? DetailCharacterVC {
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
