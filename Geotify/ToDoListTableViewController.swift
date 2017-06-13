//
//  ToDoListTableViewController.swift
//  Geotify
//
//  Created by Jordan Stephenson on 6/8/17.
//  Copyright © 2017 Ken Toh. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ToDoListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

  @IBOutlet weak var tableView: UITableView!
  var geotifications: [Geotification] = []

  var postData = [String]()





  
    override func viewDidLoad() {
      super.viewDidLoad()
      Database.database().reference().child("LocationToDos").observe(DataEventType.childAdded, with: {( snapshot) in
        
        let toDoMessages = (snapshot.value as! NSDictionary)["Message"] as! String
        self.postData.append(toDoMessages)
        print ("This is inside ViewdidLoad", self.postData)
  
      })
      tableView.delegate = self
      tableView.dataSource = self
      tableView.reloadData()
  }
  override func viewDidAppear(_ animated: Bool) {
    tableView.reloadData()
  }




 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TODOCELL")
      
        cell.textLabel?.text = self.postData[indexPath.row]
        return (cell)
    }
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCellEditingStyle.delete {
      var ref: DatabaseReference!
      ref = Database.database().reference().child("LocationToDos")

    
     
      postData.remove(at: indexPath.row)
      let myRef = ref.childByAutoId().child("Message")
      print(myRef)
//      myRef.removeValue()
      tableView.reloadData()
    }
  }
  

  

  
  

}

