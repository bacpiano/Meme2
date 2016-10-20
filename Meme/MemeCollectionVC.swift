//
//  MemeCollectionVC.swift
//  Meme2.0
//
//  Created by Adrian Borcea on 19/09/2016.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "Cell"

class MemeCollectionVC: UICollectionViewController {

    var memes = [MeMe]()
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    
    override func viewWillLayoutSubviews() {
        let space : CGFloat = 5.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        
        flowLayout.itemSize = CGSize (width:dimension, height:dimension)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
    }



    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        let imageView = cell.viewWithTag(10) as! UIImageView
        
        let meme = memes[indexPath.row] as MeMe
        
        imageView.image = meme.memedImage
       
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let meme = memes[indexPath.row] as MeMe
        
        let vc:MemeDetailVC = storyboard?.instantiateViewController(withIdentifier:"MemeDetailVC") as! MemeDetailVC
        
        vc.memeImage = meme.memedImage
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
