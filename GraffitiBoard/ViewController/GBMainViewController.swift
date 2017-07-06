//
//  GBMainViewController.swift
//  GraffitiBoard
//
//  Created by jeongkyu kim on 2017. 7. 5..
//  Copyright © 2017년 jeongkyu kim. All rights reserved.
//

import UIKit

class GBMainViewController: UIViewController {
    
    @IBOutlet weak var message: UILabel!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if FBInterface.shared.auth.isLogin() == false {
            self.performSegue(withIdentifier: "Login", sender: nil)
        }
    }

}
