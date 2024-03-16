//
//  AuthManger.swift
//  Spotify
//
//  Created by ayman on 11/03/2024.
//

import Foundation
final class AuthManger{
    static let shared = AuthManger()
    private var refreshingToke = false
    private init(){}
    
     var isSignedIn:Bool {
        return accessToken != nil
    }
    public var signInURL:URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURL)&show_dialog=TRUE"
        return URL(string: string)
    }
    private var accessToken:String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    private var refreshToken:String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    private var tokenExpirationDate: Date?{
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    private var shouldRefreshToken : Bool {
        guard let expirationData = tokenExpirationDate else {return false}
        let currentDate = Date()
        let fiveMineteTime :TimeInterval = 300
        
        return currentDate.addingTimeInterval(fiveMineteTime) >= expirationData
        
    }
    
    
    public func exchangeCodeForToken(
        code:String,
        completion:@escaping ((Bool)->Void)
    ){
        // get token
        guard let url = URL(string: Constants.tokenAPIURL) else{return}
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value:Constants.redirectURL)
            
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else{
            print("sonthing went wrong to get base64 string ")
            completion(false)
            return
            
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self ]data, _, error in
            guard let data = data ,error == nil else{
                completion(false)
                return
                
            }
            do{
               // let data1 = try JSONSerialization.jsonObject(with: data,options: .fragmentsAllowed)
                //print(data1)
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result:result)
                completion(true)
                
                
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        task.resume()
    }
    
    private var onRefreshBlocks = [((String)->Void)]()
    /// supplies accsess toiken valid  to be used in api call
    public func withValidToke(completion : @escaping (String)->Void){
        //be sure that its not already refreshing
        guard !refreshingToke else {
            // append the completion
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            //refresh
            refreshIfNeeded { success in
                if let token = self.accessToken , success {
                    completion(token)
                }
            }
        }
        else if let token = accessToken{
            completion(token)
            
        }
    }
    
    public func refreshIfNeeded(completion : @escaping ((Bool) -> Void)){
        guard !refreshingToke else {
            return
        }
        guard shouldRefreshToken else {return
            completion(true)
        }
        guard let refreshToken = self.refreshToken else{
            return
        }
        // refresh token
        guard let url = URL(string: Constants.tokenAPIURL) else{return}
        refreshingToke = true
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
            
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else{
            print("sonthing went wrong to get base64 string ")
            completion(false)
            return
            
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self ]data, _, error in
            guard let data = data ,error == nil else{
                completion(false)
                return
                
            }
            do{
               // let data1 = try JSONSerialization.jsonObject(with: data,options: .fragmentsAllowed)
                //print(data1)
                self?.refreshingToke = false
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach{$0(result.access_token)}
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result:result)
                completion(true)
                
                
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        task.resume()
        
        
    }
    
    private func cacheToken(result:AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
      
    
    }

}
struct Constants {
    static let clientID = "6e4f913610894af688da8fb3f06549ab"
    static let clientSecret = "13485f31992243f8a7330fac93dc68fb"
    static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    static let redirectURL = "https://open.spotify.com/"
    static let scopes = "user-read-private%20playlist-modify-private%20playlist-read-private%20playlist-modify-public%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
}
