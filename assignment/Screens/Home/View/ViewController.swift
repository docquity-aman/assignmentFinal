//
//  ViewController.swift
//  assignment
//
//  Created by Aman Verma on 13/02/23.
//

import UIKit
import Combine
class ViewController: UIViewController {
    private var cancellables = [AnyCancellable]()
    private var homeViewModel=HomeViewModel()
    
    private var gifModel:GifModel?
    var dataModel:[DataValue]?
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
//        print("After Init: ",self.dataModel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            print("After INit: ",self.dataModel)
        }
    }
    
    func  initViewModel() {
        homeViewModel.$gifModel
            .sink(receiveValue: {
            [weak self] gifModel in
            self?.gifModel=gifModel
                let datav=gifModel?.data
                self?.dataModel=datav
        }).store(in: &cancellables)
        
        

    }
}
