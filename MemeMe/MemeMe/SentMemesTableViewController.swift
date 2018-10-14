//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by John McCaffrey on 10/6/18.
//  Copyright © 2018 John McCaffrey. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
        
    var memeArrayLocation: Int = 0
    
    @IBOutlet weak var memeTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newMeme))
    }
    override func viewDidAppear(_ animated: Bool) {
        memeTable.reloadData()
        
        //NOTE: eliminate this if tabBar must always be visible
        tabBarController?.tabBar.isHidden = false
        memeTable.rowHeight = 100
    }
 
    @objc func newMeme(){
        let gmvc = self.storyboard?.instantiateViewController(withIdentifier: "GenerateMemeViewController") as! GenerateMemeViewController
        self.present(gmvc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeCell", for: indexPath) as! MemeTableViewCell
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
//        // Set the name and image
//        cell.textLabel?.text = meme.topText
//        cell.imageView?.image = meme.memedImage
//        cell.imageView?.contentMode = .scaleAspectFill
        
        cell.populateCell(meme: meme)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailController.meme = self.memes[(indexPath as NSIndexPath).row]
        memeDetailController.memeArrayLocation = (indexPath as NSIndexPath).row
        self.navigationController!.pushViewController(memeDetailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.remove(at:(indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
