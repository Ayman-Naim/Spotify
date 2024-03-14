//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by ayman on 11/03/2024.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let signInButton :UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 20,
                                    y: view.height - 50 - view.safeAreaInsets.bottom,
                                    width: view.width - 40 ,
                                    height: 50)
    }
    

    @objc func didTapSignIn(){
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
   

}
