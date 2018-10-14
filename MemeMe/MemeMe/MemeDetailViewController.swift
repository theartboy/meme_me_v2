//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by John McCaffrey on 10/9/18.
//  Copyright © 2018 John McCaffrey. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    var meme: Meme!
    var memeArrayLocation: Int = 0

    @IBOutlet weak var memeImageView: UIImageView!
    


    override func viewDidLoad() {
        super.viewDidLoad()

        //not sure if this is to spec but it makes the nav seem more "correct"
        tabBarController?.tabBar.isHidden = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memeImageView.image = appDelegate.memes[memeArrayLocation].memedImage
    }
    
    @objc func editMeme() {
        let gmvc = self.storyboard?.instantiateViewController(withIdentifier: "GenerateMemeViewController") as! GenerateMemeViewController
        gmvc.meme = self.meme
        gmvc.memeArrayLocation = self.memeArrayLocation
        self.present(gmvc, animated: true, completion: nil)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
