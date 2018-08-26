//
//  SettingsViewController.swift
//  Hello
//
//  Created by admin on 26/8/2561 BE.
//  Copyright © 2561 admin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    let privateSettingKey = "privateSetting"

    @IBOutlet weak var switchPrivate: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let privateSetting:Bool = UserDefaults().bool(forKey: self.privateSettingKey)
        let privateSetting: Bool = UserDefaults().getPrivate()
        self.switchPrivate.isOn = privateSetting
        
    }

    @IBAction func doTogglePrivate(_ sender: Any) {
//        UserDefaults().set(switchPrivate.isOn, forKey: self.privateSettingKey)
        UserDefaults().setPrivate(value: self.switchPrivate.isOn)
        
    }
}
