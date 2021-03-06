//
//  ViewController.swift
//  HideKeyboardButton
//
//  Created by 童进 on 15/9/21.
//  Copyright © 2015年 qefee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var hideKeyboardButton: UIButton?
    let hideKeyboardButtonWidth:CGFloat = 40
    let hideKeyboardButtonHeight:CGFloat = 30
    
    var keyboardAnimationDuration: Double = 0
    var keyboardAnimationCurve: UInt = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // add keyboard observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name:UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidHide:"), name:UIKeyboardDidHideNotification, object: nil)
    }
    
    deinit {
        // remove keyboard observer
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    keyboardDidShow
    
    - parameter notification: notification
    */
    func keyboardDidShow(notification: NSNotification) {
        
        let info  = notification.userInfo!
        
        keyboardAnimationDuration = info[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        keyboardAnimationCurve = UInt(info[UIKeyboardAnimationCurveUserInfoKey]!.intValue)
        
        let frame = getKeyboardFrame(notification)
        
        if frame.h == 0 {
            return
        }
        
        var button: UIButton!
        if let btn = hideKeyboardButton {
            btn.removeFromSuperview()
        }
        
        button = UIButton(frame: CGRectMake(frame.w - hideKeyboardButtonWidth, frame.y - hideKeyboardButtonHeight, hideKeyboardButtonWidth, hideKeyboardButtonHeight))
        button.setTitle("hide", forState: UIControlState.Normal)
        button.backgroundColor = UIColor(red: 173.0/255.0, green: 181.0/255.0, blue: 189.0/255.0, alpha: 1)
        button.addTarget(self, action: "onHideKeyboardButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        button.alpha = 0
        
        hideKeyboardButton = button
        
        let origCenter = button.center
        let newCenter = CGPointMake(origCenter.x, origCenter.y + hideKeyboardButtonHeight)
        
        button.center = newCenter
        
        self.view.addSubview(button)
        
        UIView.animateWithDuration(keyboardAnimationDuration, delay: 0, options: UIViewAnimationOptions(rawValue: keyboardAnimationCurve), animations: { () -> Void in
            button.alpha = 0.75
            button.center = origCenter
            }) { (finish) -> Void in
                print("animate state = \(finish)")
        }
    }
    
    /**
    getKeyboardFrame
    
    - parameter notification: notification
    
    - returns: frame
    */
    private func getKeyboardFrame(notification: NSNotification) -> (x:CGFloat,y:CGFloat,w:CGFloat,h:CGFloat) {
        let info  = notification.userInfo!
        
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        
        let x = keyboardFrame.origin.x
        let y = keyboardFrame.origin.y
        let w = keyboardFrame.width
        let h = keyboardFrame.height
        
        return (x,y,w,h)
    }
    
    var hidingKeyboardFlag: Bool = false
    
    /**
    onHideKeyboardButtonClick
    
    - parameter sender: sender
    */
    func onHideKeyboardButtonClick(sender: UIButton) {
        
        hidingKeyboardFlag = true
        
        if let btn = hideKeyboardButton {
            UIView.animateWithDuration(keyboardAnimationDuration, delay: 0, options: UIViewAnimationOptions(rawValue: keyboardAnimationCurve), animations: { () -> Void in
                btn.alpha = 0
                btn.center = CGPointMake(btn.center.x, UIScreen.mainScreen().applicationFrame.height - self.hideKeyboardButtonHeight/2)
                }) { (finish) -> Void in
                    btn.removeFromSuperview()
                    print("animate state = \(finish)")
            }
        }
        self.view.endEditing(false)
    }
    
    /**
    keyboardDidHide
    
    - parameter notification: notification
    */
    func keyboardDidHide(notification: NSNotification) {
        
    }
    
    /**
    keyboardWillShow
    
    - parameter notification: notification
    */
    func keyboardWillShow(notification: NSNotification) {
        
    }
    
    /**
    keyboardWillHide
    
    - parameter notification: notification
    */
    func keyboardWillHide(notification: NSNotification) {
        
        if hidingKeyboardFlag {
            hidingKeyboardFlag = false
            return
        }
        
        if let btn = hideKeyboardButton {
            btn.alpha = 0
            btn.removeFromSuperview()
        }
    }
}
