//
//  AuthManger.swift
//  Spotify
//
//  Created by ayman on 11/03/2024.
//

import Foundation
final class AuthManger{
    static let shared = AuthManger()
    
    private init(){}
    
     var isSignedIn:Bool {
        return false
    }
    private var accessToken:String?{
        return nil
    }
    private var refreshToken:String?{
        return nil
    }
    private var tokenExpirationDate: Date?{
        return nil
    }
    private var shouldRefreshToken : Bool {
        return false
        
    }

}
struct Constants {
    let clientID = "6e4f913610894af688da8fb3f06549ab"
    let clientSecret = "13485f31992243f8a7330fac93dc68fb"
}
