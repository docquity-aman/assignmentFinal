//
//  FavoriteViewController.swift
//  assignment
//
//  Created by Aman Verma on 13/02/23.
//

import UIKit
import SDWebImage
 
class FavoriteViewModel{
    var dbService:DbService!
    init(dbService:DbService=DbService()){
        self.dbService=dbService
    }
}

class FavoriteViewController: UIViewController, UIGestureRecognizerDelegate {
 
    @Published private var models=[FavoriteItems]()
    private var favoriteViewModel=FavoriteViewModel()
    
    private var longPressGesture:UILongPressGestureRecognizer!
    private var tapGestures:UITapGestureRecognizer!
   

    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        favoriteCollectionView.collectionViewLayout=UICollectionViewFlowLayout()
        models=self.favoriteViewModel.dbService.getAllItem()
        favoriteCollectionView.reloadData()
        


        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteCollectionView.collectionViewLayout=UICollectionViewFlowLayout()
        models=self.favoriteViewModel.dbService.getAllItem()
        DispatchQueue.main.async {
            self.favoriteCollectionView.reloadData()
            
        }
        
    }
    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.favoriteCollectionView?.reloadData()
        }

    private var flag:Bool=false
    @IBAction private func favoriteCardViewChangeaLayout(_ sender: Any) {
        flag = !flag
        favoriteCollectionView.reloadData()
    }
    
 
 
    deinit{
        debugPrint("Deinit: Favorite View Controller....")
        print("deallocated...")
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
        tapGestures = UITapGestureRecognizer(target: self, action: #selector(didTripleTap(_:)))
        tapGestures.numberOfTapsRequired = 3
        favCell.addGestureRecognizer(tapGestures)
        
        return favCell
    }
}

extension FavoriteViewController{
    @objc func didTripleTap(_ gesture: UITapGestureRecognizer) {
        deleteButton(gesture)
        let tap = gesture.location(in: self.favoriteCollectionView)
        guard let index:NSIndexPath=self.favoriteCollectionView.indexPathForItem(at: tap) as? NSIndexPath else{
            return
        }
        print("Triple Tap : ",index.row)
        let item = models[index.row]
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8){
            self.favoriteViewModel.dbService.deleteItem(item: item)
            self.models=self.favoriteViewModel.dbService.getAllItem()
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
     
        
            UIView.animate(withDuration: 0.5, animations: {
                trash.alpha=0
            },completion: {done in
                if done{
                    UIView.animate(withDuration: 0.5, animations: {trash.alpha=0},completion: {
                        done in
                        if done{
                            trash.removeFromSuperview()
                        }
                    })
                    
                }
            })

    }
}

extension FavoriteViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var spacing:CGFloat
        var numberOfItemsPerRow:CGFloat
        var spacingBetweenCells:CGFloat
        if(flag){
            spacing=1
            numberOfItemsPerRow = 1
            spacingBetweenCells = 1
        }else{
            spacing=2
            numberOfItemsPerRow=2
            spacingBetweenCells=2
        }
        
        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        if let collection = self.favoriteCollectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right:1)
    }
}

