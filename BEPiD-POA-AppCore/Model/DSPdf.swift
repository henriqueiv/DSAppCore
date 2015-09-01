//
//  DSPdf.swift
//  BEPiD-POA-AppCore
//
//  Created by Pietro Degrazia on 8/21/15.
//  Copyright (c) 2015 DarkShine. All rights reserved.
//

class DSPdf:PFObject, PFSubclassing{
    @NSManaged var user: PFUser!
    @NSManaged var file: PFFile!
    
    
    static func parseClassName() -> String {
        return "DSPdf"
    }
}
