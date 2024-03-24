//
//  DetailLocation.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 20.03.2024.
//

import UIKit

final class DetailLocation: UICollectionViewController {
    
    var locations: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        locations.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellLocation = collectionView.dequeueReusableCell(withReuseIdentifier: "viewLocationDetail", for: indexPath)
        guard let cellLocation = cellLocation as? CharacterLocationCell else { return UICollectionViewCell() }
        let location = locations[indexPath.item]
//        cellLocation.configure(with: location)
        return cellLocation
    }
}
//// MARK: - UICollectionViewDelegateFlowLayout
//extension DetailLocation: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: view.window?.windowScene?.screen.bounds.width ?? 0, height: 100)
//    }
//}
