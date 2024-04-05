//
//  ViewController.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 15.03.2024.
//

import UIKit
import Kingfisher

final class DetailCharacterViewController: UIViewController {
    
    @IBOutlet var characterImage: UIImageView!
    @IBOutlet var descriptionCharacterLabel: UILabel!
    
    var character: Character!

    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionCharacterLabel.text = character.description
        let processor = DownsamplingImageProcessor(size: characterImage.bounds.size)
        characterImage.kf.indicatorType = .activity
        characterImage.kf.setImage(
            with: character.image,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.brightness),
                .transition(.fade(0.5)),
                .cacheOriginalImage
            ]
        )
    }
    
    private func fetchEpisode(from url: URL, closure: @escaping(Episode) -> Void) {
        networkManager.fetch(Episode.self, from: url) { result in
            switch result {
            case .success(let episode):
                closure(episode)
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension DetailCharacterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        character.episode.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episods", for: indexPath) as? EpisodeCell else { return UICollectionViewCell() }
        let episodeUrl = character.episode[indexPath.item]
        fetchEpisode(from: episodeUrl) { episode in
            cell.configure(with: episode)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailCharacterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (view.window?.windowScene?.screen.bounds.width ?? 0) - 100, height: 130)
    }
}
