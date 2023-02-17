//
//  ViewController.swift
//  assignment
//
//  Created by Aman Verma on 13/02/23.
//

import UIKit
import Combine
import SDWebImage

class ViewController: UIViewController {
    private  var cancellables = Set<AnyCancellable>()
    private  var homeViewModel=HomeViewModel()
    private var dataModel:[DataValue]?
    
    private var tapGestures:UITapGestureRecognizer!
    private var models=[FavoriteItems]()
    private var items:FavoriteModel=FavoriteModel()
    
    @IBOutlet private weak var cardViewLayoutButton: UIBarButtonItem!
    @IBOutlet private weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        // Do any additional setup after loading the view.
    }
    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("Value: ",self.collectionView.accessibilityElementCount())
//        guard
        self.collectionView?.reloadData()
        }
    
 
    
    
    private var flag:Bool=false
    
    @IBAction func cardChangeLayoutButton(_ sender: Any) {
        flag = !flag
        collectionView.reloadData()
    }
    
    deinit{
        debugPrint("Deinit: Home View Controller....")
        print("Deinit: Home View Controller....")
    }
    
}

extension ViewController {
    func configuration() {
        initViewModel()
        homeViewModel.fetchGif()
        
    }
    
    func  initViewModel() {
        homeViewModel.$gifModel
            .sink(receiveValue:{
                [weak self] gifModel in
                let datav=gifModel?.data
                self?.dataModel=datav
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }).store(in: &self.cancellables)
        collectionView.collectionViewLayout=UICollectionViewFlowLayout()
        
        
    }
    
    
}

extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.dataModel?.count else{
            return 1
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell
        else  {
            return UICollectionViewCell()
        }
        guard let imageURL=self.dataModel?[indexPath.row].images.downsizedMedium.url else{
            cell.gifImageView.image=UIImage(imageLiteralResourceName: "emptyImage")
            return cell;
        }

        
        //add gif
        cell.gifImageView.sd_imageIndicator=SDWebImageActivityIndicator.gray
        cell.gifImageView.sd_imageIndicator?.startAnimatingIndicator()
        cell.gifImageView.sd_setImage(with: URL(string: imageURL) , placeholderImage:    UIImage(imageLiteralResourceName: "emptyImage"),options:.continueInBackground,completed: nil)
        cell.gifImageView.contentMode = .scaleAspectFill
        cell.gifImageView.layer.cornerRadius=5
        tapGestures = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tapGestures.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tapGestures)
        return cell
        
    }
    
    
}

extension ViewController{
    @objc func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        let tap = gesture.location(in: self.collectionView)
        let idx : NSIndexPath = self.collectionView.indexPathForItem(at: tap)! as NSIndexPath
        print("Double tapped",idx.row)
        items.id=self.dataModel?[idx.row].id
        items.title=self.dataModel?[idx.row].title
        items.width=Int16(self.dataModel![idx.row].images.downsizedMedium.width)!
        items.height=Int16(self.dataModel![idx.row].images.downsizedMedium.height)!
        let dataurl=self.dataModel![idx.row].images.downsizedMedium.url
        items.url = URL(string: dataurl)
        DbService.shareInstance.createItem(title: items.title!, id: items.id! , width: items.width, height: items.height, url: items.url!)
        
        likeButton(gesture: gesture)
        
    }
    
    
    func likeButton(gesture: UITapGestureRecognizer){
        print("like")
        let heart=UIImageView(image: UIImage(systemName: "heart.fill"))
        heart.tintColor = .systemPink
        gesture.view?.addSubview(heart)
        let size=gesture.view!.frame.size.width/4
        heart.tintColor = .red
        heart.frame=CGRect(x: ((gesture.view?.frame.size.height)!)/3, y: ((gesture.view?.frame.size.width)!)/4, width: size, height: size)
        heart.center = CGPoint(x: gesture.view!.frame.size.width  / 2,
                               y: gesture.view!.frame.size.height / 2)
        
        
        UIView.animate(withDuration: 0.5, animations: {
            heart.alpha=0
        },completion: {done in
            if done{
                UIView.animate(withDuration: 0.5, animations: {heart.alpha=0},completion: {
                    done in
                    if done{
                        heart.removeFromSuperview()
                    }
                })
                
            }
        })
        
    }
    
}

extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var spacing:CGFloat
        var numberOfItemsPerRow:CGFloat
        var spacingBetweenCells:CGFloat
        if(flag){
            spacing=1
            numberOfItemsPerRow=1
            spacingBetweenCells=1
            
        }else{
            spacing=2
            numberOfItemsPerRow=2
            spacingBetweenCells=2
            
        }
        
        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        //Amount of total spacing in a row
        if let collection = self.collectionView{
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
        return  1;
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right:1)
    }
}


extension ViewController{
}
