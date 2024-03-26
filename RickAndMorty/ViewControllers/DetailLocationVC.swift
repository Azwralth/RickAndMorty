//
//  DetailLocationViewController.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 23.03.2024.
//

import UIKit

class DetailLocationVC: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var descriptionLabel: UILabel!
    
    var location: Location!
    
    var characters: [Character] = [] {
        didSet {
            if characters.count == location.residents.count {
                characters = characters.sorted { $0.id < $1.id }
            }
        }
    }
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = location.description
        setCharacters()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        if let detailVC = segue.destination as? DetailCharacterLocationVC {
            detailVC.character = characters[indexPath.item]
        }
    }
    
    private func setCharacters() {
        location.residents.forEach { characterURL in
            networkManager.fetch(Character.self, from: characterURL) { [unowned self] result in
                switch result {
                case .success(let character):
                    self.characters.append(character)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}


extension DetailLocationVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        location.residents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewCharacterLocation", for: indexPath) as! CharacterLocationCell
        let characterURL = location.residents[indexPath.item]
        NetworkManager.shared.fetch(Character.self, from: characterURL) { result in
            switch result {
            case .success(let character):
                cell.configure(with: character)
            case .failure(let error):
                print(error)
            }
        }
        return cell
    }
}
