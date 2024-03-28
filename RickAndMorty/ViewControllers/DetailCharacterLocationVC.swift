//
//  DetailCharacterLocationVC.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 24.03.2024.
//

import UIKit
import Kingfisher

class DetailCharacterLocationVC: UIViewController {
    
    @IBOutlet var descriptionCharacterLabel: UILabel!
    @IBOutlet var characterImage: UIImageView!
    
    var character: Character!
    
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
}
