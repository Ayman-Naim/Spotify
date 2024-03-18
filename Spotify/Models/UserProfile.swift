//
//  UserProfile.swift
//  Spotify
//
//  Created by ayman on 11/03/2024.
//

import Foundation
struct UserProfile:Codable{
    let country : String
    let display_name:String
    let email:String
    let explicit_content:[String:Int]
    let external_urls:[String:String]
   // let followers :[String :Codable?]
    let href :String
    let id :String
    let images:[UserImage]
    let product : String
    let type:String
    
}

struct UserImage:Codable{
    let url : String
}




