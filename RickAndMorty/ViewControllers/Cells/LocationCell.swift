//
//  EpisodeCell.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 20.03.2024.
//

import UIKit

final class LocationCell: UICollectionViewCell {
    
    @IBOutlet var nameLocationLabel: UILabel!
    @IBOutlet var nameTypeLabel: UILabel!
    @IBOutlet var dimensionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func configure(with location: Location?) {
        guard let location else { return }
        nameLocationLabel.text = location.name
        nameTypeLabel.text = location.type
        dimensionLabel.text = location.dimension
    }
}
