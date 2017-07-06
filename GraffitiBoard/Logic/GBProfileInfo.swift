//
//  GBProfileInfo.swift
//  GraffitiBoard
//
//  Created by jeongkyu kim on 2017. 7. 6..
//  Copyright © 2017년 jeongkyu kim. All rights reserved.
//

import Foundation

protocol GBProfileInfo {
    
    var name : String? { get }
    var email : String? { get }
    var profileURL : URL? { get }
}
