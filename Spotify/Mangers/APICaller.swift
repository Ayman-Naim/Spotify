//
//  ApiCaller.swift
//  Spotify
//
//  Created by ayman on 11/03/2024.
//

import Foundation
enum HTTPMethod:String{
    case GET
    case POST
}
enum APIError:Error {
    case faildToGetData
}
final class APICaller{
    static let shared = APICaller()
    struct constants {
        static let baseAPiUrl = "https://api.spotify.com/v1"
    }
    private init(){}
    public func getCurrentUserProfile(completion:@escaping (Result<UserProfile,Error>)->Void){
        CreateRequest(
            with: URL(string: constants.baseAPiUrl+"/me"),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data , error == nil else {
                    // completion error
                    completion(.failure(APIError.faildToGetData))
                    return
                    
                }
                do{
                   // let result = try JSONSerialization.jsonObject(with: data,options: .fragmentsAllowed)
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    
                    print(result )
                }catch{
                    completion(.failure(error))
                }
                    
                
            }
            task.resume()
        }
        
    }
    
    //MARK: - generic request
    private func CreateRequest(
        with url : URL?,
        type:HTTPMethod,
        completion : @escaping (URLRequest) -> Void
    ){
            
        AuthManger.shared.withValidToke { token in
            guard let apiUrl = url else {return}
            var request = URLRequest(url: apiUrl)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
        
    }
}
