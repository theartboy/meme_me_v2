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


    @IBOutlet weak var memeImageView: UIImageView!
    


    override func viewDidLoad() {
        super.viewDidLoad()

        memeImageView.image = meme.memedImage
        
        //not sure if this is to spec but it makes the nav seem more "correct"
        tabBarController?.tabBar.isHidden = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editMeme))
    }
    
    @objc func editMeme() {
        let gmvc = self.storyboard?.instantiateViewController(withIdentifier: "GenerateMemeViewController") as! GenerateMemeViewController
        gmvc.meme = self.meme
//                        navigationController?.pushViewController(gmvc, animated: true)
        self.present(gmvc, animated: true, completion: nil)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
