//
//  QuizApi.swift
//  QuizGame
//
//  Created by Jasper Lefever on 17/11/2023.
//

import Foundation

var baseURL = "http://localhost:8080"

extension URLSession {
    func fetchData<T : Codable>(at base: String = baseURL, endpoint: String , completion: @escaping (Result<T, Error>) -> Void) {
        let url = URL(string: "\(base)/\(endpoint)")!
        
        self.dataTask(with: url) { (data, response, error) in
        
      if let error = error {
        completion(.failure(error))
      }

      if let data = data {
        do {
            
          let data = try JSONDecoder().decode(T.self, from: data)
          completion(.success(data))
            
        } catch let decoderError {
            
          completion(.failure(decoderError))
            
        }
      }
    }.resume()
  }
}
