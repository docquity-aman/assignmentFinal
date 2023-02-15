//
//  FavoriteViewController.swift
//  assignment
//
//  Created by Aman Verma on 13/02/23.
//

import UIKit
import SDWebImage

class FavoriteViewController: UIViewController, UIGestureRecognizerDelegate {
    @Published private var models=[FavoriteItems]()
    private var longPressGesture:UILongPressGestureRecognizer!
    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        models=DbService.shareInstance.getAllItem()
        favoriteCollectionView.reloadData()
        

    }
   
}
extension FavoriteViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favCell=(favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "favCell", for: indexPath) as? FavoriteCollectionViewCell)!
        
        let model=models[indexPath.row]
        print(model)
        guard let imageURL=model.url else{
            favCell.favoriteImageView.image=UIImage(imageLiteralResourceName: "emptyImage")
            return favCell;
        }
        favCell.favoriteImageView.sd_imageIndicator=SDWebImageActivityIndicator.gray
        favCell.favoriteImageView.sd_imageIndicator?.startAnimatingIndicator()
        favCell.favoriteImageView.sd_setImage(with:imageURL , placeholderImage:    UIImage(imageLiteralResourceName: "emptyImage"),options:.continueInBackground,completed: nil)
        favCell.favoriteImageView.contentMode = .scaleAspectFill
        favCell.favoriteImageView.layer.cornerRadius=5
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        longPressGesture.delaysTouchesBegan = true
       favCell.addGestureRecognizer(longPressGesture)
        return favCell
    }
    @objc func longPress(_ gesture: UILongPressGestureRecognizer) {
        let tap = gesture.location(in: self.favoriteCollectionView)
        let index:NSIndexPath=self.favoriteCollectionView.indexPathForItem(at: tap)! as NSIndexPath
        
        print("Long Pressed : ",index.row)
        let item = models[index.row]
       
        DbService.shareInstance.deleteItem(item: item)
        self.favoriteCollectionView.reloadData()
        
        
        }
    
    
    
}
