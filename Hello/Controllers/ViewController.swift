//
//  ViewController.swift
//  Hello
//
//  Created by admin on 20/8/2561 BE.
//  Copyright © 2561 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    var isLightTheme = true
    
    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var txtName: UITextField!
    
    @IBAction func clickButton(_ sender: Any) {
        self.lblHello.text = "Hello \(self.txtName.text!)"
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        view.backgroundColor = UIColor.black
        for eachView in view.subviews{
            eachView.backgroundColor = UIColor.black
            if let lable = eachView as? UILabel{
                lable.textColor = UIColor.white
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHello.text = "Hello World! after view loaded"
        print("changed")
        
        var a = 10
        a = a + 1
        print(a)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

