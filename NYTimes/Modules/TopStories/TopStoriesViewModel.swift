//
//  TopStoriesViewModel.swift
//  NYTimes
//
//  Created by MAC on 07/09/21.
//

import Foundation
import Combine

protocol TopStoriesViewModelType {
    var numberofItems:Int { get }
    var topStoriesBinding:Published<TopStories?>.Publisher { get }
    func getTopStories()
    func getTopStoryDetails(for index:Int)-> TopStoryDetails?
}

class TopStoriesViewModel {
    var numberofItems:Int {
        return topStories?.results.count ?? 0
    }
    var subscriptions:Set<AnyCancellable> = []
    let repository:Repository
    
    @Published private var topStories:TopStories?
    
    var topStoriesBinding:Published<TopStories?>.Publisher { $topStories }
    
    init(repository:Repository = RepositoryImpl()) {
        self.repository = repository
    }
}

extension TopStoriesViewModel:TopStoriesViewModelType {
    
    func getTopStories() {
        repository.fetchNews(modelType: TopStories.self)
            .receive(on: DispatchQueue.main).sink{ [weak self] completion in
                
            }
            receiveValue: { [weak self ] response in
                self?.topStories = response
            }.store(in: &subscriptions)
    }
    
    func getTopStoryDetails(for index:Int)-> TopStoryDetails? {
        if let newsResult = topStories?.results,  index >= 0 , index < newsResult.count {
            let newsDetails =  newsResult[index]
            return TopStoryDetails(title: newsDetails.title, byline: newsDetails.byline, updatedDate: newsDetails.updatedDate)
        }
        return nil
    }
}
