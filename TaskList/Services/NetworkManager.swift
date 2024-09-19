//
//  NetworkManager.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    
    static let shared = NetworkManager()

    private init() {}
    
    func fetchData(completion:  @escaping (Result<TasksInAPI, NetworkError>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                completion(.failure(.noData))
                return
            }
            do {
                let tasks = try JSONDecoder().decode(TasksInAPI.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
}
