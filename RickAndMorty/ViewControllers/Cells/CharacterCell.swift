//
//  CharacterLocationCell.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 20.03.2024.
//

import UIKit
import Kingfisher

final class CharacterCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var characterImage: UIImageView!
    
    private let networkManager = NetworkManager.shared
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }
    
    func configure(with character: Character?) {
        guard let character else { return }
        nameLabel.text = character.name
        statusLabel.text = "Status: \(character.status ?? "")"
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
