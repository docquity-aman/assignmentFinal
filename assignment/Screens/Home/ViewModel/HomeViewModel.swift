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
       return APIManger.shared.fetchGif()
             .receive(on: DispatchQueue.main)
             .sink(receiveCompletion:{ (completion) in
            switch completion{
            case .failure(let err):
                    print("Error is \(err.localizedDescription)")
            case .finished:
                    print("Finished Home View Model")
                    
            }
        }, receiveValue: {[weak self] gifModel in
            self?.gifModel=gifModel
         }
        ).store(in: &cancellables)

    }
    
}

extension HomeViewModel{
    enum Event{
        case loading
        case dataloading
        case stoploading
        case error(Error?)
    }
}
