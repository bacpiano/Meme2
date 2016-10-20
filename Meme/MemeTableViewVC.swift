//
//  MemeTableViewVC.swift
//  Meme2.0
//
//  Created by Adrian Borcea on 19/09/2016.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

import UIKit

class MemeTableViewVC: UITableViewController {

     var memes = [MeMe]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let imageView = cell.viewWithTag(10) as! UIImageView

        let label = cell.viewWithTag(20) as! UILabel
        
        let meme = memes[indexPath.row] as MeMe
        
        imageView.image = meme.memedImage
        label.text = meme.topText + "..." + meme.bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let meme = memes[indexPath.row] as MeMe
        
        let vc:MemeDetailVC = storyboard?.instantiateViewController(withIdentifier:"MemeDetailVC") as! MemeDetailVC
        
        vc.memeImage = meme.memedImage
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editBtnPressed(_ sender: AnyObject) {
        
        if tableView.isEditing {
            
            tableView.setEditing(false, animated: true)
        }else{
            
             tableView.setEditing(true, animated: true)
        }
    }

    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            memes = appDelegate.memes
            
            tableView.deleteRows(at: [indexPath], with: .fade)
           
        }
    }
    

}
