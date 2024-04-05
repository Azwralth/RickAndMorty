//
//  EpisodeCell.swift
//  RickAndMorty
//
//  Created by Владислав Соколов on 31.03.2024.
//

import UIKit

final class EpisodeCell: UICollectionViewCell {
    
    @IBOutlet var nameEpisode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func configure(with episode: Episode?) {
        guard let episode else { return }
        
        nameEpisode.text = episode.name
    }
    
}
