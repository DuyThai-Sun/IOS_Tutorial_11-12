//
//  APICaller.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thai on 20/12/2022.
//

import Foundation

class APICaller {
    static let shared = APICaller()
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func getJSON<T: Codable>(urlApi: String, completion: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: urlApi) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = MethodRequest.get.rawValue
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, NetworkError.badResponse)
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NetworkError.badStatusCode(httpResponse.statusCode))
                return
            }
            guard let data = data else {
                completion(nil, NetworkError.badData)
                return
            }
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                completion(results, nil)
            }
            catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func getImage(imageURL: String ,completion: @escaping (Data?, Error?) -> (Void)) {
        guard let url = URL(string: imageURL) else {
            completion(nil, NetworkError.badData)
            return
        }
        let task = session.downloadTask(with: url) { (localUrl: URL?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, NetworkError.badResponse)
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NetworkError.badStatusCode(httpResponse.statusCode))
                return
            }
            guard let localUrl = localUrl else {
                completion(nil, NetworkError.badData)
                return
            }
            do {
                let data = try Data(contentsOf: localUrl)
                completion(data, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
