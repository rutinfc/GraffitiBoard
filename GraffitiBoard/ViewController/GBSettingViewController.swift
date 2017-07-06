//
//  CBSettingViewController.swift
//  GraffitiBoard
//
//  Created by jeongkyu kim on 2017. 7. 6..
//  Copyright © 2017년 jeongkyu kim. All rights reserved.
//

import UIKit
import AFNetworking

class GBSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "LogoutCell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { (action) in
            
            FBInterface.shared.auth.logout(complete: { (finish) in
                
                if finish == false {
                    return
                }
                
                self.navigationController?.popViewController(animated: false)
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionController.addAction(logoutAction)
        actionController.addAction(cancelAction)
        
        self.present(actionController, animated: true, completion: nil)
    }
}

class GBLogoutTableViewCell : UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbnail.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        self.thumbnail.layer.borderWidth = 1
        self.thumbnail.layer.cornerRadius = self.thumbnail.frame.width / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let profile = FBInterface.shared.auth.currentProfileInfo() else {
            return
        }
        
        self.email.text = profile.email
        self.nameLabel.text = profile.name
        
        guard let url = profile.profileURL else {
            return
        }
        
        self.thumbnail.setImageWith(url)
    }
}
