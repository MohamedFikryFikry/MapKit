//
//  ViewController.swift
//  myLocation
//
//  Created by mohamed on 12/25/19.
//  Copyright © 2019 mohamed. All rights reserved.
//

import UIKit
import CoreLocation
class MainVc: UIViewController {

    @IBOutlet weak var GOBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func go(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "MapVC")as! MapVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}



extension MainVc : MyDelegate
{
    func SendMapData(Data: String) {
        GOBtn.setTitle(Data, for: .normal)
        
    }
    
    
}
