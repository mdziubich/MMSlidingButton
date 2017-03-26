//
//  ViewController.swift
//  MMSlidingButton
//
//  Created by Mohamed Maail on 6/7/16.
//  Copyright © 2016 Mohamed Maail. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SlideButtonDelegate {
    
    @IBOutlet weak var button: MMSlidingButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.button.delegate = self
    }
    
    @IBAction func resetClicked(_ sender: AnyObject) {
        self.button.reset()
    }
    
    
    //Slide Button Delegate
    func buttonStatus(_ status: String, sender: MMSlidingButton) {
        print(status)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

