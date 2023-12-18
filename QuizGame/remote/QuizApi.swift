//
//  QuizApi.swift
//  QuizGame
//
//  Created by Jasper Lefever on 17/11/2023.
//

import Foundation

var baseURL = "http://localhost:8080"

extension URLSession {
    func fetchData<T: Codable>(
        at base: String = baseURL, endpoint: String, method: String = "GET", body: Data? = nil,
        completion: @escaping (Result<T, QuizApiError>) -> Void
    ) {
        guard let url = URL(string: "\(base)/\(endpoint)") else {
            completion(.failure(QuizApiError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        self.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(QuizApiError.custom(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(QuizApiError.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(QuizApiError.failedToDecode))
                    }
                }
            case 400...499:
                completion(.failure(QuizApiError.clientError(statusCode: httpResponse.statusCode)))
            case 500...599:
                completion(.failure(QuizApiError.serverError(statusCode: httpResponse.statusCode)))
            default:
                completion(.failure(QuizApiError.unknownError))
            }
            
        }.resume()
    }
    
    func postData<T: Codable, U: Codable>(
        at base: String = baseURL,
        endpoint: String,
        body: T,
        completion: @escaping (Result<U, QuizApiError>) -> Void
    ) {
        do {
            let bodyData = try JSONEncoder().encode(body)
            fetchData(
                at: base,
                endpoint: endpoint,
                method: "POST",
                body: bodyData,
                completion: completion
            )
        } catch {
            completion(.failure(QuizApiError.failedToEncode))
        }
    }
    
    func putData<T: Codable, U: Codable>(
        at base: String = baseURL,
        endpoint: String,
        body: T,
        completion: @escaping (Result<U, QuizApiError>) -> Void
    ) {
        do {
            let bodyData = try JSONEncoder().encode(body)
            fetchData(
                at: base,
                endpoint: endpoint,
                method: "PUT",
                body: bodyData,
                completion: completion
            )
        } catch {
            completion(.failure(QuizApiError.failedToEncode))
        }
    }
    
    func deleteData(
        at base: String = baseURL,
        endpoint: String,
        completion: @escaping (Result<Void, QuizApiError>) -> Void
    ) {
        guard let url = URL(string: "\(base)/\(endpoint)") else {
            completion(.failure(QuizApiError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        self.dataTask(with: request) { (_, response, error) in
            if let error = error {
                completion(.failure(QuizApiError.custom(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(QuizApiError.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                completion(.success(()))
            case 400...499:
                completion(.failure(QuizApiError.clientError(statusCode: httpResponse.statusCode)))
            case 500...599:
                completion(.failure(QuizApiError.serverError(statusCode: httpResponse.statusCode)))
            default:
                completion(.failure(QuizApiError.unknownError))
            }
            
        }.resume()
    }
}

enum QuizApiError: LocalizedError {
    case invalidURL
    case invalidResponse
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case unknownError
    case custom(error: Error)
    case failedToDecode
    case failedToEncode
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid"
        case .invalidResponse:
            return "The response is invalid"
        case .clientError(let statusCode):
            return "The client encountered an error with status code \(statusCode)"
        case .serverError(let statusCode):
            return "The server encountered an error with status code \(statusCode)"
        case .unknownError:
            return "An unknown error occured"
        case .custom(let error):
            return error.localizedDescription
        case .failedToDecode:
            return "Failed to decode the data"
        case .failedToEncode:
            return "Failed to encode the data"
        }
    }
}
