//
//  ViewController.swift
//  Clock-iOS
//
//  Created by Julien Cohard on 18/11/2021.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func openAddClock(_ sender: Any) {
        
        print("ok")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let clockVC = storyboard.instantiateViewController(identifier: "AddClockViewController") as! AddClockViewController
        self.navigationController?.pushViewController(clockVC, animated: true)
        
    }

}

