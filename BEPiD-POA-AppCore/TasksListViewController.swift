//
//  TasksListViewController.swift
//  BEPiD-POA-AppCore
//
//  Created by Henrique Valcanaia on 9/1/15.
//  Copyright (c) 2015 DarkShine. All rights reserved.
//

import UIKit

public let kDSTasksListFileName = "DSTasks"

class TasksListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks:[DSTask] = [DSTask]()
    var taskCreator:DSTaskController = DSTaskController()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadTasks()
    }
    
    //MARK: - Functions
    func loadTasks(){
        if let path = NSBundle.mainBundle().pathForResource(kDSTasksListFileName, ofType: "plist") {
            if let tasksArray = NSArray(contentsOfFile: path){
                for task in tasksArray as! [String]{
                    println(task)
                    let dsTask = DSTask(plistFileName: task)
                    tasks += [dsTask]
                }
                tableView.reloadData()
            }
        }
    }
    
}

//MARK: - UITableViewDelegate
extension TasksListViewController: UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let task = tasks[indexPath.row]
        if let path = NSBundle.mainBundle().pathForResource(task.file, ofType: "plist") {
            if let taskDict = NSDictionary(contentsOfFile: path){
                taskCreator.createTaskWithDictionary(taskDict, andParentViewController: self, willShowTask: true)
            }
        }
    }
    
}

//MARK: - UITableViewDataSource
extension TasksListViewController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "TaskCell")
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        return cell
    }
    
}