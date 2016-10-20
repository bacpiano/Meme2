//
//  MemeDetailVC.swift
//  Meme2.0
//
//  Created by Adrian Borcea on 22/09/2016.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {

    var memeImage : UIImage = UIImage()
    
    @IBOutlet weak var memeView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

       memeView.image = memeImage
    }
}
