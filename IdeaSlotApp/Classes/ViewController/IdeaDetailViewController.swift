//
//  IdeaDetailViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/29.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
//import RealmSwift

class IdeaDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarTitle(title: "Idea Detail")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
