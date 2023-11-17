//
//  QuizApi.swift
//  QuizGame
//
//  Created by Jasper Lefever on 17/11/2023.
//

import Foundation

var baseURL = "http://localhost:8080"

extension URLSession {
    func fetchData<T : Codable>(at base: String = baseURL, endpoint: String , completion: @escaping (Result<T, QuizApiError>) -> Void) {
        let url = URL(string: "\(base)/\(endpoint)")!
        
        self.dataTask(with: url) { (data, response, error) in
        
      if let error = error {
          completion(.failure(QuizApiError.custom(error: error)))
      }

      if let data = data {
        do {
            
          let data = try JSONDecoder().decode(T.self, from: data)
          completion(.success(data))
            
        } catch _ {
            
            completion(.failure(QuizApiError.failedToDecode))
            
        }
      }
    }.resume()
  }
}


enum QuizApiError: LocalizedError {
    case failedToDecode
    case badRequest
    case custom(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .failedToDecode:
            return "Failed to decode response"
        case .badRequest:
            return "Bad server request"
        case .custom(let error):
            return error.localizedDescription
        }
    }
}

struct Metadata : Codable {
    var total: Int
    var page: Int
    var per: Int
}
