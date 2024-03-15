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
        vc.completionHandler = { success in
            DispatchQueue.main.async {
                self.handleSignIn(success:success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
   
    
    func handleSignIn(success:Bool){
        // log the user or show the error hanppened
        guard success else {
            let alert = UIAlertController(title: "Sign In Faild ",message: "Something went wrong when signing in ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        let mainTabBarVC = TabBarViewController()
        mainTabBarVC.modalPresentationStyle = .fullScreen
        present(mainTabBarVC, animated: true)
        
    }

}
