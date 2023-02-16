//
//  HomeViewModel.swift
//  assignment
//
//  Created by Aman Verma on 14/02/23.
//

import Foundation
import Combine
final class HomeViewModel:ObservableObject{
    
    @Published var gifModel:GifModel?
    var gifDataModel:[DataValue]!
    private var cancellables = Set<AnyCancellable>()
    //    print(self.gifModel)
    //GIPHY
    func fetchGif(){
        APIManger.shared.fetchGif()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion:{ (completion) in
                switch completion{
                case .failure(let err):
                    print("Home View Model:Error is \(err.localizedDescription)")
                case .finished:
                    print("Home View Model:Finished Home View Model")
                    
                    
                }
            }, receiveValue: {[weak self] gifModel in
                self?.gifModel=gifModel
                self?.gifDataModel=gifModel.data
            }
            ).store(in: &cancellables)
        
    }
    
}

