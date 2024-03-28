//
//  ViewController.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 15.03.2024.
//

import UIKit
import Kingfisher

final class DetailCharacterVC: UIViewController {
    
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
}

