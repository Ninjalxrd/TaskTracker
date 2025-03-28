//
//  NetworkService.swift
//  ToDoApp
//
//  Created by Павел on 19.03.2025.
//

import Foundation

protocol NetworkServiceInput {
    func obtainTasks(completion: @escaping (Result<[NetworkTask], Error>) -> Void)
}

final class NetworkService: NetworkServiceInput {
    
    private let session: URLSession = URLSession(configuration: .default)
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    func obtainTasks(completion: @escaping (Result<[NetworkTask], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.success([]))
            return
        }
        let urlRequest = URLRequest(url: url)
        
        session.dataTask(with: urlRequest) {[weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.success([]))
                }
                return
            }
            
            do {
                guard let self else { return }
                let taskResponse = try self.jsonDecoder.decode(TasksResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(taskResponse.todos))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
