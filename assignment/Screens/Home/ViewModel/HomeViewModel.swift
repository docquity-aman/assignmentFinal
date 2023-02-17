//
//  HomeViewModel.swift
//  assignment
//
//  Created by Aman Verma on 14/02/23.
//

import Foundation
import Combine
final class HomeViewModel:ObservableObject{
    var apiManager:APIManger!
    var dbService:DbService!
    init(apiManager:APIManger=APIManger(),dbService:DbService=DbService()){
        self.apiManager=apiManager
        self.dbService=dbService
    }
    
    @Published var gifModel:GifModel?
    var gifDataModel:[DataValue]!
    private var cancellables = Set<AnyCancellable>()
    //    print(self.gifModel)
    //GIPHY
    func fetchGif(){
        self.apiManager.fetchGif()
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

