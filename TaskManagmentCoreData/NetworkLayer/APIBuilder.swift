//
//  APIBuilder.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 26.06.2022.
//

import Foundation

protocol APIBuilder {
    var urlRequest: URLRequest { get }
    var baseUrl: URL { get }
    var path: String { get }
}

extension APIBuilder {
    var baseUrl: URL {
        URL(string: "https://api.giphy.com/v1/gifs/search")!
    }
}

enum SearchAPI {
    case getGifsBy(String)
}

extension SearchAPI: APIBuilder {
    var urlRequest: URLRequest {
        switch self {
        case .getGifsBy(let searchString):
            
            
            var components = URLComponents(string: baseUrl.absoluteString)
            components?.queryItems = [
                URLQueryItem(name: "api_key", value: "6QuJRs6bQH6MxsJC9uUHoXPuo2I18aAZ"),
                URLQueryItem(name: "q", value: searchString),
                URLQueryItem(name: "limit", value: "25")
            ]
            guard let url = components?.url else { return URLRequest(url: baseUrl.appendingPathComponent(path)) }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            return request
        }
    }
    
    var path: String {
        return "?api_key=6QuJRs6bQH6MxsJC9uUHoXPuo2I18aAZ"
    }
    
    
}

import Foundation

/// Custom errors of NetworkLayer
public enum APIError: Error {
    case decodingError
    case errorCode(Int)
    case registrationError
    case custom(String)
    case unknown
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decodingError:
            return "APIError: decodingError"
        case .errorCode(let code):
            return "APIError: \(code)"
        case .registrationError:
            return "Error with registration"
        case .custom(let errorDescription):
            return errorDescription
        case .unknown:
            return "APIError: unknown"
        }
    }
}


class ApiManager {
    static let sharedInstance: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        return URLSession(configuration: configuration)
    }()
}


import Combine

final class NetworkService {
    
    func request<T: Codable>(from endpoint: APIBuilder) -> AnyPublisher<T, APIError> {
        
        return ApiManager
            .sharedInstance
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: RunLoop.main)
            .mapError { error in
                return APIError.unknown
            }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }
                
                if (200...299).contains(response.statusCode) {
                    
                    let jsonDecoder = JSONDecoder()
                    
                    return Just(data)
                        .decode(type: T.self, decoder: jsonDecoder)
                        .mapError { error in
                            APIError.custom(error.localizedDescription.description)
                        }
                        .eraseToAnyPublisher()
                    
                } else {
                    return Fail(error: APIError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}

/// Service to network work of restaurants models
public class SearchGIFNetworkService {
    
    public init() {}
    
    fileprivate lazy var networkService = NetworkService()
    
    fileprivate var gifResponse: GIFResponse?
    
    fileprivate var cancellables = Set<AnyCancellable>()
    
    /// Method to get GIFResponse by searchString
    /// - Parameters:
    ///   - searchString: searchString of Gif name
    ///   - completion: It return's single GIFResponse or APIError
    func loadGIFs(by searchString: String, completion: @escaping (GIFResponse?, APIError?) -> Void ) {
        let cancellable = networkService.request(from: SearchAPI.getGifsBy(searchString))
            .sink { [weak self] res in
                guard let strongSelf = self else { return }
                switch res {
                case .finished:
                    guard let gifResponse = strongSelf.gifResponse else {
                        return
                    }
                    completion(gifResponse, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            } receiveValue: { [weak self] response in
                self?.gifResponse = response
            }
        
        cancellables.insert(cancellable)
    }
    
}
