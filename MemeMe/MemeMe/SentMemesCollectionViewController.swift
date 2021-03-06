//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by John McCaffrey on 10/6/18.
//  Copyright © 2018 John McCaffrey. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
 
    var memeArrayLocation: Int = 0

    @IBOutlet weak var memeCollection: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        var dimension: CGFloat = 0.0
        
        if UIDevice.current.orientation.isPortrait {
            dimension = (view.frame.size.width - (2 * space)) / 3.0
        } else {
            dimension = (view.frame.size.height - (2 * space)) / 5.0
        }

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newMeme))
    }

    @objc func newMeme(){
        let gmvc = self.storyboard?.instantiateViewController(withIdentifier: "GenerateMemeViewController") as! GenerateMemeViewController
        self.present(gmvc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        memeCollection.reloadData()
        
        //eliminate this if tabBar must always be visible
        tabBarController?.tabBar.isHidden = false
    }
    
    
    
    //MARK: Collection methods
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        ///
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.populateCell(meme: meme)
        // Set the name and image
//        cell.memeImageView?.image = meme.memedImage
//        cell.memeImageView?.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailController.meme = self.memes[(indexPath as NSIndexPath).row]
        memeDetailController.memeArrayLocation = (indexPath as NSIndexPath).row
       self.navigationController!.pushViewController(memeDetailController, animated: true)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
