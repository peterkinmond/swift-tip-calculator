//
//  SettingsViewController.swift
//  tips
//
//  Created by Peter Kinmond on 6/28/16.
//  Copyright © 2016 Peter Kinmond. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipDefaultControl: UISegmentedControl!
    let defaults = NSUserDefaults.standardUserDefaults()
    let tipIndexKey = "tipIndex"

    @IBAction func onValueChanged(sender: AnyObject) {
        defaults.setInteger(tipDefaultControl.selectedSegmentIndex, forKey: tipIndexKey)
        defaults.synchronize()
    }

    override func viewDidLoad() {
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tipDefaultIndex = defaults.integerForKey(tipIndexKey)
        tipDefaultControl.selectedSegmentIndex = tipDefaultIndex
    }
}
