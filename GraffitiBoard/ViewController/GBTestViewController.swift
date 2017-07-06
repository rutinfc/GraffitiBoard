//
//  GBTestViewController.swift
//  GraffitiBoard
//
//  Created by jeongkyu kim on 2017. 7. 7..
//  Copyright © 2017년 jeongkyu kim. All rights reserved.
//

import UIKit

class GBTestViewController: UIViewController {

    @IBOutlet weak var testView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if self.view.bounds.width >= self.view.bounds.height {
            self.testView.axis = .horizontal
        } else {
            self.testView.axis = .vertical
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animateAlongsideTransition(in: self.view, animation: { (context) in
            
            self.testView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            
        }) { (context) in
            
            UIView.animate(withDuration: 0.4, animations: { 
                self.testView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }, completion: { (finish) in
                
                UIView.animate(withDuration: 0.2, animations: { 
                    self.testView.transform = CGAffineTransform.identity
                })
            })
        }
    }
}
