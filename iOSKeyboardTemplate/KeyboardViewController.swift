//
//  KeyboardViewController.swift
//  iOSKeyboardTemplate
//
//  Created by Le'Foroz on 8/25/16.
//  Copyright © 2016 Ingrain.io. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }
    
    var shiftStatus = 1
    
    //for the QWERTY keyboard
    @IBOutlet weak var numbersRow1View: UIView!
    @IBOutlet weak var numbersRow2View: UIView!
    @IBOutlet weak var symbolsRow1View: UIView!
    @IBOutlet weak var symbolsRow2View: UIView!
    @IBOutlet weak var numbersSymbolsRow3View: UIView!
    
    @IBOutlet var letterButtonsArray: [UIButton]!
    @IBOutlet var switchModeRow3Button: UIButton!
    @IBOutlet var switchModeRow4Button: UIButton!
    @IBOutlet var shiftButton: UIButton!
    @IBOutlet var spaceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeKeyboard()
    }
    
    
    func initializeKeyboard() {
        
        //start with shift on
        shiftStatus = 1;
        
        //initialize space key double tap
        let spaceDoubleTap = UITapGestureRecognizer(target: self, action: #selector(spaceKeyDoubleTapped))
        
        spaceDoubleTap.numberOfTapsRequired = 2;
        spaceDoubleTap.delaysTouchesEnded = false
        
        spaceButton.addGestureRecognizer(spaceDoubleTap)
        
        //initialize shift key double and triple tap
        let shiftDoubleTap = UITapGestureRecognizer(target: self, action: #selector(shiftKeyDoubleTapped))
        let shiftTripleTap = UITapGestureRecognizer(target: self, action: #selector(shiftKeyPressed))
        
        shiftDoubleTap.numberOfTapsRequired = 2;
        shiftTripleTap.numberOfTapsRequired = 3;
        
        
        shiftDoubleTap.delaysTouchesEnded = false
        shiftTripleTap.delaysTouchesEnded = false
        
        shiftButton.addGestureRecognizer(shiftDoubleTap)
        shiftButton.addGestureRecognizer(shiftTripleTap)
        
    }
    
    
    @IBAction func globeKeyPressed(sender: AnyObject) {
        advanceToNextInputMode()
    }
    
    @IBAction func keyPressed(sender: AnyObject) {
        //inserts the pressed character into the text document
        let button = sender as! UIButton
        textDocumentProxy.insertText(button.titleLabel!.text!)
        
        //if shiftStatus is 1, reset it to 0 by pressing the shift key
        if (shiftStatus == 1) {
            shiftKeyPressed(shiftButton)
        }
    }
    
    @IBAction func backspaceKeyPressed(sender: AnyObject) {
        textDocumentProxy.deleteBackward()
    }
    
    @IBAction func spaceKeyPressed(sender: AnyObject) {
        textDocumentProxy.insertText(" ")
    }
    
    
    func spaceKeyDoubleTapped() {
        //double tapping the space key automatically inserts a period and a space
        //if necessary, activate the shift button
        textDocumentProxy.deleteBackward()
        textDocumentProxy.insertText(". ")
        
        if (shiftStatus == 0) {
            shiftKeyPressed(shiftButton)
        }
    }
    
    @IBAction func returnKeyPressed(sender: AnyObject) {
        textDocumentProxy.insertText("\n")
    }
    
    @IBAction func shiftKeyPressed(sender: AnyObject) {
        //if shift is on or in caps lock mode, turn it off. Otherwise, turn it on
        shiftStatus = shiftStatus > 0 ? 0 : 1;
        shiftKeys()
    }
    
    func shiftKeyDoubleTapped() {
        //set shift to caps lock and set all letters to uppercase
        shiftStatus = 2;
        
        shiftKeys()
    }
    
    func shiftKeys() {
        //if shift is off, set letters to lowercase, otherwise set them to uppercase
        if (shiftStatus == 0) {
            for letterButton in letterButtonsArray {
                letterButton.setTitle(letterButton.titleLabel!.text!.lowercaseString, forState: .Normal)
            }
        } else {
            for letterButton in letterButtonsArray {
                letterButton.setTitle(letterButton.titleLabel!.text!.uppercaseString, forState: .Normal)
            }
        }
        
        //adjust the shift button images to match shift mode
        let shiftButtonImageName = NSString(format: "shift_\(shiftStatus)")
        shiftButton.setImage(UIImage(named: shiftButtonImageName as String), forState: .Normal)
        
        let shiftButtonHLImageName = NSString(format: "shift_\(shiftStatus)HL")
        shiftButton.setImage(UIImage(named: shiftButtonHLImageName as String), forState: .Highlighted)
    }
    
    @IBAction func switchKeyboardMode(sender: AnyObject) {
        numbersRow1View.hidden = true;
        numbersRow2View.hidden = true;
        symbolsRow1View.hidden = true;
        symbolsRow2View.hidden = true;
        numbersSymbolsRow3View.hidden = true;
        
        //switches keyboard to ABC, 123, or #+= mode
        //case 1 = 123 mode, case 2 = #+= mode
        //default case = ABC mode
        
        switch (sender.tag) {
            
        case 1:
            numbersRow1View.hidden = false;
            numbersRow2View.hidden = false;
            numbersSymbolsRow3View.hidden = false;
            
            //change row 3 switch button image to #+= and row 4 switch button to ABC
            switchModeRow3Button.setImage(UIImage(named: "symbols"), forState: .Normal)
            switchModeRow3Button.setImage(UIImage(named: "symbolsHL"), forState: .Highlighted)
            switchModeRow3Button.tag = 2;
            switchModeRow4Button.setImage(UIImage(named: "abc"), forState: .Normal)
            switchModeRow4Button.setImage(UIImage(named: "abcHL"), forState: .Highlighted)
            switchModeRow4Button.tag = 0;
            break;
            
        case 2:
            symbolsRow1View.hidden = false;
            symbolsRow2View.hidden = false;
            numbersSymbolsRow3View.hidden = false;
            
            //change row 3 switch button image to 123
            switchModeRow3Button.setImage(UIImage(named: "numbers"), forState: .Normal)
            switchModeRow3Button.setImage(UIImage(named: "numbersHL"), forState: .Highlighted)
            switchModeRow3Button.tag = 1;
            break;
            
        default:
            //change the row 4 switch button image to 123
            switchModeRow4Button.setImage(UIImage(named: "numbers"), forState: .Normal)
            switchModeRow4Button.setImage(UIImage(named: "numbersHL"), forState: .Highlighted)
            switchModeRow4Button.tag = 1;
            break;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
}
