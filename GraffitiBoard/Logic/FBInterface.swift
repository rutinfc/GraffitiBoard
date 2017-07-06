//
//  FBInterface.swift
//  GraffitiBoard
//
//  Created by jeongkyu kim on 2017. 7. 5..
//  Copyright © 2017년 jeongkyu kim. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

class FBInterface {
    
    static let shared = FBInterface()
    let auth : FBAuthfication = FBAuthfication()
    
    static func initialize() {
        FirebaseApp.configure()
        FBInterface.shared.auth.load()
    }
}

extension Notification.Name {
    static let didChangeAuthStatus = NSNotification.Name("didChangeAuthStatus")
}

class FBAuthfication : NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
    
    func load() {
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        GIDSignIn.sharedInstance().delegate = self
        
    }
    
    func isLogin() -> Bool {
        
        if Firebase.Auth.auth().currentUser != nil {
            return true
        }
        
        return false
    }
    
    func currentProfileInfo() -> GBProfileInfo? {
        
        guard let user = Firebase.Auth.auth().currentUser else {
            return nil
        }
        
        return FBUserInfo(user: user)
    }
    
    func handURL(url:URL, options:[UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        let source = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
    
        return GIDSignIn.sharedInstance().handle(url, sourceApplication:source, annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            NotificationCenter.default.post(name: Notification.Name.didChangeAuthStatus, object: error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential : AuthCredential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        guard let user = Firebase.Auth.auth().currentUser  else {
            
            Firebase.Auth.auth().signIn(with: credential, completion: { (user, error) in
                NotificationCenter.default.post(name: Notification.Name.didChangeAuthStatus, object: user?.email)
            })
            
            return
        }
        
        user.link(with: credential, completion: { (user, error) in
            NotificationCenter.default.post(name: Notification.Name.didChangeAuthStatus, object: user?.email)
        })
    }
    
    func logout(complete:@escaping (_ finish:Bool)->Void) {
        
        guard let user = Firebase.Auth.auth().currentUser else {
            complete(false)
            return
        }
        
        do {
            try Firebase.Auth.auth().signOut()
        } catch {
            complete(false)
            return
        }
        
        guard let povider = user.providerData.first else {
            complete(false)
            return
        }
        
        Firebase.Auth.auth().currentUser?.unlink(fromProvider: povider.providerID, completion: { (user, error) in
            
            if error != nil {
                complete(false)
                return
            }
            complete(true)
        })
    }
}

class FBUserInfo : NSObject, GBProfileInfo {
    
    fileprivate let user : Firebase.User
    
    fileprivate init(user:Firebase.User) {
        self.user = user
        super.init()
    }
    
    var name : String? {
        get { return self.user.displayName }
    }
    
    var email : String? {
        get {
            return self.user.email
        }
    }
    
    var profileURL : URL? {
        get {
            return self.user.photoURL
        }
    }
}
