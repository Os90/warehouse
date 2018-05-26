//
//  LoginViewController.swift
//  Warehouse
//
//  Created by Osman Ashraf on 04.05.18.
//  Copyright © 2018 osman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.performSegue(withIdentifier: "sucess", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
