//
//  ViewController.swift
//  GraffitiBoard
//
//  Created by jeongkyu kim on 2017. 7. 5..
//  Copyright © 2017년 jeongkyu kim. All rights reserved.
//

import UIKit
import GoogleSignIn

class GBLoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet var signInButton : GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(type(of:self).changeAuthStatus(notification:)), name: Notification.Name.didChangeAuthStatus, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func changeAuthStatus(notification:Notification) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
}

