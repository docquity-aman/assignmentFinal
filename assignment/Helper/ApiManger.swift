//
//  ApiManger.swift
//  assignment
//
//  Created by Aman Verma on 14/02/23.
//

import Foundation
import Combine
import UIKit



//typealias Handler=(Result<GifModel,DataError>)->Void

final public class APIManger{
    private var cancellables = Set<AnyCancellable>()
//    static let shared=APIManger()
//    private init(){}

    //Using Combine
    func fetchGif() -> Future<GifModel,Error>{
        return Future<GifModel,Error>{
            [weak self] promise in
            guard let url=URL(string:Constant.API.gifApi)else{
                return
            }
            URLSession.shared.dataTaskPublisher(for:url)
                .tryMap{ (data,response)->Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    throw NetworkError.responseError
                }
                return data
               }
                .decode(type: GifModel.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                                    if case let .failure(error) = completion {
                                        switch error {
                                        case let decodingError as DecodingError:
                                            promise(.failure(decodingError))
                                        case let apiError as NetworkError:
                                            promise(.failure(apiError))
                                        default:
                                            promise(.failure(NetworkError.unknown))
                                        }
                                    }
                                }, receiveValue: { promise(.success($0)) }
                )
                .store(in: &self!.cancellables)
        

        }
    }
}


enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
