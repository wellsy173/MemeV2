//
//  sentMemeTableViewController.swift
//  Meme
//
//  Created by Simon Wells on 2020/6/2.
//  Copyright © 2020 Simon Wells. All rights reserved.
//

import Foundation
import UIKit

//Mark: - ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate

class SentMemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var details: UIButton!
    @IBOutlet weak var createMeme: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    // MARK: Properties
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
        tableView.reloadData()
        tableView.rowHeight = 100
    }
    
    
    
    
    //MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count //check memes//
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexpath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        cell.imageView?.image = memes[indexpath.row].memedImage
        
        
        return cell
    }
    
    func tableView(_ tableview: UITableView, didSelectRowAt indexpath: IndexPath) {
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.meme = self.memes[(indexpath as NSIndexPath).row]
        
        
        self.navigationController!.pushViewController(detailController, animated: true)
        
        
    }
    
}
