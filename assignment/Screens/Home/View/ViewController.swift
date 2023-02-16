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
    private var cancellables = [AnyCancellable]()
    private var homeViewModel=HomeViewModel()
    private var gifModel:GifModel?
    var dataModel:[DataValue]?
    private var tapGestures:UITapGestureRecognizer!
    private var models=[FavoriteItems]()
    var items:FavoriteModel=FavoriteModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
         configuration()
        // Do any additional setup after loading the view.
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
            self?.gifModel=gifModel
                let datav=gifModel?.data
                self?.dataModel=datav
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }).store(in: &self.cancellables)
        
        

    }
}

extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = gifModel?.data.count else{
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
        cell.gifImageView.sd_imageIndicator=SDWebImageActivityIndicator.gray
        cell.gifImageView.sd_imageIndicator?.startAnimatingIndicator()
        cell.gifImageView.sd_setImage(with: URL(string: imageURL) , placeholderImage:    UIImage(imageLiteralResourceName: "emptyImage"),options:.continueInBackground,completed: nil)
        cell.gifImageView.contentMode = .scaleAspectFill
        cell.gifImageView.layer.cornerRadius=5
        tapGestures = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tapGestures.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tapGestures)
//        cell.add
        

        return cell
        
    }
    @objc func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let gestureView=gesture.view else{
            return
        }
        let tap = gesture.location(in: self.collectionView)
        let idx : NSIndexPath = self.collectionView.indexPathForItem(at: tap)! as NSIndexPath
        print("Double tapped",idx.row)
        items.id=self.dataModel?[idx.row].id
        items.title=self.dataModel?[idx.row].title
        items.width=Int16(self.dataModel![idx.row].images.downsizedMedium.width)!
        items.height=Int16(self.dataModel![idx.row].images.downsizedMedium.height)!
        var dataurl=self.dataModel![idx.row].images.downsizedMedium.url
        items.url = URL(string: dataurl)
        DbService.shareInstance.createItem(title: items.title!, id: items.id! , width: items.width, height: items.height, url: items.url!)

        likeButton(gesture: gesture)
       
        }
    
    
    func likeButton(gesture: UITapGestureRecognizer){
        print("like")
        let heart=UIImageView(image: UIImage(systemName: "heart.fill"))
        heart.tintColor = .red
        gesture.view?.addSubview(heart)
        let size=gesture.view!.frame.size.width/4
        heart.tintColor = .red
        heart.frame=CGRect(x: ((gesture.view?.frame.size.height)!)/3, y: ((gesture.view?.frame.size.width)!)/4, width: size, height: size)
        heart.center = CGPoint(x: gesture.view!.frame.size.width  / 2,
                               y: gesture.view!.frame.size.height / 2)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            UIView.animate(withDuration: 0.5, animations: {
                heart.alpha=0
            },completion: {done in
                if done{
                    heart.removeFromSuperview()
                }
            })
        })
    }
    
}
