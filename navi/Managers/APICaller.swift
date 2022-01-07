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
    static let youtube_api_key = "AIzaSyAtpV7wCO37Zf81c3jC4SE3n1XSRvHXUDE"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
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
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
            guard let data = data else {
                return
            }
            do{
                let results = try JSONDecoder().decode(ResultMovies.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getTrendingTV(completion: @escaping(Result<[Movie], Error>)->Void){
        guard let url = URL(string: "\(Constant.baseURL)/3/trending/tv/day?api_key=\(Constant.api_key)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
            guard let data = data else {
                return
            }
            do{
                let results = try JSONDecoder().decode(ResultMovies.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    func getUpcomingMovies(completion: @escaping(Result<[Movie], Error>)->Void){
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/upcoming?api_key=\(Constant.api_key)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
            guard let data = data else {
                return
            }
            do{
                let results = try JSONDecoder().decode(ResultMovies.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping(Result<[Movie], Error>)->Void){
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/popular?api_key=\(Constant.api_key)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
            guard let data = data else {
                return
            }
            do{
                let results = try JSONDecoder().decode(ResultMovies.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    func getTopRatedMovies(completion: @escaping(Result<[Movie], Error>)->Void){
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/top_rated?api_key=\(Constant.api_key)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
            guard let data = data else {
                return
            }
            do{
                let results = try JSONDecoder().decode(ResultMovies.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    func getDiscoverMovies(completion: @escaping(Result<[Movie], Error>)->Void){
        guard let url = URL(string: "\(Constant.baseURL)/3/discover/movie?api_key=\(Constant.api_key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
            guard let data = data else {
                return
            }
            do{
                let results = try JSONDecoder().decode(ResultMovies.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func searchMovie(with query: String, completion: @escaping(Result<[Movie], Error>)->Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constant.baseURL)/3/search/movie?api_key=\(Constant.api_key)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
            guard let data = data else {
                return
            }
            do{
                let results = try JSONDecoder().decode(ResultMovies.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping(Result<VideoElement, Error>)->Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constant.youtubeBaseURL)q=\(query)&key=\(Constant.youtube_api_key)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
            guard let data = data else {
                return
            }
            do{
                let results = try JSONDecoder().decode(YouTubeMovieResponse.self, from: data)
                if let result = results.items.first{
                    completion(.success(result))
                }
                
            }catch{
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
