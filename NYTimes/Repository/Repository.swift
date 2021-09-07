//
//  Repository.swift
//  NYTimes
//
//  Created by MAC on 07/09/21.
//

import Foundation
import Combine


protocol Repository {
    func fetchNews<T:Decodable>(modelType:T.Type)-> AnyPublisher<T, ServiceError>
}

class RepositoryImpl: Repository {
    
    let service:NewsService
    init(newsService:NewsService = NewsServiceImp()) {
        self.service = newsService
    }
    
    func fetchNews<T:Decodable>(modelType:T.Type)-> AnyPublisher<T, ServiceError> {
        
        guard let request = URLRequest.getRequest(url:ServiceEndPoint.baseUrl, path: APIPath.topStories) else {
            return Fail(error:  ServiceError.errorWith(message: "Something went wrong")).eraseToAnyPublisher()
        }
        
        return  service.get(urlRequest: request)
            .decode(type:T.self , decoder: JSONDecoder())
            .tryMap { result in
                return result
            }.mapError{ _ in
                ServiceError.errorWith(message: "Something went wrong")}
            .eraseToAnyPublisher()

    }
}


