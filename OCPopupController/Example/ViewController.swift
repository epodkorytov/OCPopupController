//
//  ViewController.swift
//  Example
//
//  Created by Evgene Podkorytov on 02.02.17.
//  Copyright © 2017 OverC. All rights reserved.
//

import UIKit
import OCPopupController

class ViewController: UIViewController {

    @IBOutlet weak var btnShowEmpty: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnShowEmptyTap(_ sender: Any) {
        OCPopupView.sharedInstance.show()
    }

}

