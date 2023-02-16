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
    private var tapGestures:UITapGestureRecognizer!
    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        models=DbService.shareInstance.getAllItem()
        favoriteCollectionView.reloadData()
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        models=DbService.shareInstance.getAllItem()
        DispatchQueue.main.async {
            self.favoriteCollectionView.reloadData()

        }
        
    }
   
}
extension FavoriteViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favCell=(favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "favCell", for: indexPath) as? FavoriteCollectionViewCell)!
        
        let model=models[indexPath.row]
        guard let imageURL=model.url else{
            favCell.favoriteImageView.image=UIImage(imageLiteralResourceName: "emptyImage")
            return favCell;
        }
        favCell.favoriteImageView.sd_imageIndicator=SDWebImageActivityIndicator.gray
        favCell.favoriteImageView.sd_imageIndicator?.startAnimatingIndicator()
        favCell.favoriteImageView.sd_setImage(with:imageURL , placeholderImage:    UIImage(imageLiteralResourceName: "emptyImage"),options:.continueInBackground,completed: nil)
        favCell.favoriteImageView.contentMode = .scaleAspectFill
        favCell.favoriteImageView.layer.cornerRadius=5
        
//        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
//        longPressGesture.minimumPressDuration = 2
//        longPressGesture.delaysTouchesBegan = true
        tapGestures = UITapGestureRecognizer(target: self, action: #selector(didTripleTap(_:)))
        tapGestures.numberOfTapsRequired = 3
        favCell.addGestureRecognizer(tapGestures)
      
        return favCell
    }
    @objc func didTripleTap(_ gesture: UITapGestureRecognizer) {
        deleteButton(gesture)
        let tap = gesture.location(in: self.favoriteCollectionView)
        guard let index:NSIndexPath=self.favoriteCollectionView.indexPathForItem(at: tap) as? NSIndexPath else{
            return
        }
        print("Triple Tap : ",index.row)
        let item = models[index.row]
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8){
            DbService.shareInstance.deleteItem(item: item)
            self.models=DbService.shareInstance.getAllItem()
            self.favoriteCollectionView.reloadData()
           }
       
        
        }
    
    func deleteButton(_ gesture: UITapGestureRecognizer){
        let trash=UIImageView(image: UIImage(systemName: "trash.fill"))
        gesture.view?.addSubview(trash)
        let size=gesture.view!.frame.size.width/4
        trash.tintColor = .red
        trash.frame=CGRect(x: ((gesture.view?.frame.size.height)!)/3, y: ((gesture.view?.frame.size.width)!)/4, width: size, height: size)
        
        trash.center = CGPoint(x: gesture.view!.frame.size.width  / 2,
                               y: gesture.view!.frame.size.height / 2)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
            UIView.animate(withDuration: 0.5, animations: {
                trash.alpha=0
            },completion: {done in
                if done{
                    trash.removeFromSuperview()
                }
            })
        })
    }
    
}
