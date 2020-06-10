//
//  DetailViewController.swift
//  Meme
//
//  Created by Simon Wells on 2020/6/2.
//  Copyright © 2020 Simon Wells. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memedImage
        
        
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "edit", style: .plain, target: self, action: #selector(SentMemeTableViewController.setEditing))
    }
    
    
    /*
    @objc func setEditing() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
 */
    }
    
