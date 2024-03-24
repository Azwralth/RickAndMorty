//
//  DetailCharacterLocationVC.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 24.03.2024.
//

import UIKit

class DetailCharacterLocationVC: UIViewController {
    
    @IBOutlet var descriptionCharacterLabel: UILabel!
    @IBOutlet var characterImage: UIImageView!
    
    var character: Character!
    private let networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionCharacterLabel.text = character.description
        networkManager.fetchImage(from: character.image) { [unowned self] result in
            switch result {
            case .success(let imageData):
                characterImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
