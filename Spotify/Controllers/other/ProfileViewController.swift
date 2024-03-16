//
//  ProfileViewController.swift
//  Spotify
//
//  Created by ayman on 11/03/2024.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        APICaller.shared.getCurrentUserProfile { result in
            switch result{
            case.success(let model ):
                break
            case.failure(let error ):
                print(error.localizedDescription)
            }
        }
        // Do any additional setup after loading the view.
    }
    

    

}
