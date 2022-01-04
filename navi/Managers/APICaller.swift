//
//  APICaller.swift
//  navi
//
//  Created by Даня on 04.01.2022.
//

import Foundation

struct Constant{
    static let api_key = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
}

enum APIError: Error{
    case failedToGetData
}

class APICaller{
    static let shared = APICaller()
    
    
    func getTrendingMovies(completion: @escaping(Result<[Movie], Error>)->Void){
        
        guard let url = URL(string: "\(Constant.baseURL)/3/trending/movie/day?api_key=\(Constant.api_key)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            guard let data = data else {
                return
            }
            do{
                let results = try JSONDecoder().decode(ResultMovies.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getTrendingTV(completion: @escaping(Result<[Movie], Error>)->Void){
        guard let url = URL(string: "\(Constant.baseURL)/3/trending/tv/day?api_key=\(Constant.api_key)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            guard let data = data else {
                return
            }
            do{
                let results = try JSONDecoder().decode(ResultMovies.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    func getUpcomingMovies(completion: @escaping(Result<[Movie], Error>)->Void){
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/upcoming?api_key=\(Constant.api_key)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            guard let data = data else {
                return
            }
            do{
                let results = try JSONDecoder().decode(ResultMovies.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping(Result<[Movie], Error>)->Void){
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/popular?api_key=\(Constant.api_key)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            guard let data = data else {
                return
            }
            do{
                let results = try JSONDecoder().decode(ResultMovies.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
