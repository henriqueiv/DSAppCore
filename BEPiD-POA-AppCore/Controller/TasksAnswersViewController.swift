//
//  TasksAnswersViewController.swift
//  BEPiD-POA-AppCore
//
//  Created by Henrique Valcanaia on 9/1/15.
//  Copyright (c) 2015 DarkShine. All rights reserved.
//

import UIKit

class TasksAnswersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskAnswers:[DSTaskAnswer] = [DSTaskAnswer]()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadTaskAnswers()
    }
    
    func loadTaskAnswers(){
        if let query = DSTaskAnswer.query(){
            query.findObjectsInBackgroundWithBlock({ (objects:[AnyObject]?, error:NSError?) -> Void in
                if let objs = objects as? [DSTaskAnswer]{
                    self.taskAnswers = objs
                    self.tableView.reloadData()
                }else{
                    println(error?.localizedDescription)
                }
            })
        }
    }
    
}

// MARK: - UITableViewDelegate
extension TasksAnswersViewController: UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension TasksAnswersViewController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskAnswers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kReuseIdentifier = "TaskAnswerCell"
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kReuseIdentifier)
        let taskAnswer = self.taskAnswers[indexPath.row]
        cell.textLabel?.text = taskAnswer.taskName
        
        // Performing in main queue for testing
        let file = taskAnswer.json
        let data = file.getData()
        var err:NSErrorPointer = NSErrorPointer()
        if let str = NSString(data: data!, encoding: NSASCIIStringEncoding){
//            println(str)
            cell.detailTextLabel?.text = String(str)
        }
        return cell
    }
    
}