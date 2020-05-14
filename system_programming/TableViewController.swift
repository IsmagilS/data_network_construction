//
//  TableViewController.swift
//  system_programming
//
//  Created by Исмагил Сайфутдинов on 10.05.2020.
//  Copyright © 2020 Исмагил Сайфутдинов. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var needsToShowCables = false
    var needsToShowRouters = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var answer = 0
        if needsToShowCables {
            answer = graph.cables.count
        }
        else if needsToShowRouters {
            answer = graph.routers.count
        }
        return answer
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        if needsToShowCables {
            cell.firstLabel.text = "Capacity: " + String(graph.cables[indexPath.row].capacity)
            cell.firstLabel.sizeToFit()
            cell.secondLabel.text = "Price: " + String(graph.cables[indexPath.row].price)
            cell.secondLabel.sizeToFit()
        } else if needsToShowRouters {
            cell.firstLabel.text = "Capacity: " + String(graph.routers[indexPath.row].capacity)
            cell.firstLabel.sizeToFit()
            cell.secondLabel.text = "Price: " + String(graph.routers[indexPath.row].price)
            cell.secondLabel.sizeToFit()
        }
        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
