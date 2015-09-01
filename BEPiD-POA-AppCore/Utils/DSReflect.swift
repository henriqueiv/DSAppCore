//
//  DSReflect.swift
//  BEPiD-POA-AppCore
//
//  Created by Henrique Valcanaia on 8/21/15.
//  Copyright (c) 2015 DarkShine. All rights reserved.
//

import UIKit

class DSReflect: NSObject {
    
    func properties() -> [String] {
        let m = reflect(self)
        var s = [String]()
        for i in 0..<m.count{
            let (name,_)  = m[i]
            if name == "super"{continue}
            s.append(name)
        }
        return s
    }
    
}
