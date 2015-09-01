//
//  DSTaskCreator
//  RKRett
//
//  Created by Henrique Valcanaia on 8/20/15.
//  Copyright (c) 2015 DarkShine. All rights reserved.
////
//

public var DSTaskCreator:((NSDictionary) -> (ORKOrderedTask)) = { dictionary in
    
    var steps = [ORKStep]()
    if let questions = dictionary.objectForKey("questions") as? NSArray{
        for question in questions{
            if let dicQuestion = question as? NSDictionary{
                let step = DSStepCreator.createQuestionStepUsingDictionary(dicQuestion)
                steps += [step]
            }else{
                println("error unwrapping question to NSDictionary")
            }
        }
    }
    
    let identifier = dictionary.objectForKey("taskId") as! String
    
    return ORKOrderedTask(identifier: identifier, steps: steps)
}
