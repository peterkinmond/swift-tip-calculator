//
//  ViewController.swift
//  tips
//
//  Created by Peter Kinmond on 6/28/16.
//  Copyright © 2016 Peter Kinmond. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipTextLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalTextLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    let tipPercentages = [0.18, 0.20, 0.22]
    let defaults = NSUserDefaults.standardUserDefaults()
    let billAmountKey = "billAmount"
    let billSaveTimeKey = "billSaveTime"
    let tipIndexKey = "tipIndex"
    var billAmountEmpty = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        billField.becomeFirstResponder()

        let notificationCenter = NSNotificationCenter.defaultCenter()

        notificationCenter.addObserver(self,
                                       selector: #selector(ViewController.applicationWillTerminateNotification),
                                       name: UIApplicationWillTerminateNotification,
                                       object: nil)

        loadInitialSettings()
        updateLook()

        let paddingView = UIView(frame: CGRectMake(0, 0, 30, 0))
        billField.rightView = paddingView
        billField.rightViewMode = .Always

    }

    func applicationWillTerminateNotification() {
        // Save bill amount before app shuts down
        defaults.setObject(billField.text, forKey: billAmountKey)
        defaults.setDouble(NSDate().timeIntervalSince1970, forKey: billSaveTimeKey)
    }

    func loadInitialSettings() {
        // Load bill amount if less than 10mins between app restarts
        let now = NSDate().timeIntervalSince1970
        let billSaveTime = defaults.doubleForKey(billSaveTimeKey)

        if now - billSaveTime < 600 {
            let billAmount = defaults.stringForKey(billAmountKey)
            billField.text = billAmount!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tipDefaultIndex = defaults.integerForKey(tipIndexKey)
        tipControl.selectedSegmentIndex = tipDefaultIndex
        updateTipAndTotal()
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        updateTipAndTotal()
        if billAmountEmpty != (billField.text == "") {
            billAmountEmpty = (billField.text == "")
            updateLook()
        }
    }

    func updateTipAndTotal() {
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        let billAmount = NSString(string: billField.text!).doubleValue
        let tip = billAmount * tipPercentage
        let total = billAmount + tip

        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }

    func updateLook() {
        let newAlpha = billField.text == "" ? 0 : 1
        let tipsAnimationSpeed = 1.0
        let billFieldSize = billField.text == "" ? 290 : 80
        let billFieldAnimationSpeed = 0.25

        UIView.animateWithDuration(tipsAnimationSpeed, animations: {
            self.tipTextLabel.alpha = CGFloat(newAlpha)
            self.tipLabel.alpha = CGFloat(newAlpha)
            self.totalTextLabel.alpha = CGFloat(newAlpha)
            self.totalLabel.alpha = CGFloat(newAlpha)
            self.tipControl.alpha = CGFloat(newAlpha)

        })

        UIView.animateWithDuration(billFieldAnimationSpeed, animations: {
            var frameRect = self.billField.frame
            frameRect.size.height = CGFloat(billFieldSize)
            self.billField.frame = frameRect
        })
    }


    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}
