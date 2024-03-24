//
//  CustomCollectionViewCell.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 16.03.2024.
//

import UIKit

final class CharacterCell: UICollectionViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var characterImage: UIImageView!
    
    private let networkManager = NetworkManager.shared
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        statusLabel.text = "Status: \(character.status)"
        networkManager.fetchImage(from: character.image) { [unowned self] result in
            switch result {
            case .success(let imageData):
                characterImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 4
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
