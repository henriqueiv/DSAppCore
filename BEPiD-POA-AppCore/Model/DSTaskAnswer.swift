//
//  DSTaskAnswer.swift
//  BEPiD-POA-AppCore
//
//  Created by Henrique Valcanaia on 8/24/15.
//  Copyright (c) 2015 DarkShine. All rights reserved.
//

import UIKit

class DSTaskAnswer: PFObject, PFSubclassing {
    
    @NSManaged var taskName: String!
    @NSManaged var json: PFFile!
    
    static func parseClassName() -> String {
        return "TaskAnswer"
    }

}
