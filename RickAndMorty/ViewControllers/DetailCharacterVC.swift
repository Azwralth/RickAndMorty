//
//  ViewController.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 15.03.2024.
//

import UIKit

final class DetailCharacterVC: UIViewController {
    
    @IBOutlet var characterImage: UIImageView!
    @IBOutlet var descriptionCharacterLabel: UILabel!
    
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

