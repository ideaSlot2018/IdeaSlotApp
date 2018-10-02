//
//  LeftMenuViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/12.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit

enum LeftMenu :Int{
    case words = 0
    case category
    case ideas
    case slot
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftMenuViewController: UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Words", "Category", "Ideas", "Idea Slot"]
    var wordsListViewController: UIViewController!
    var categoryListViewController: UIViewController!
    var ideasListViewController: UIViewController!
    var ideasSlotViewController: UIViewController!
    var mainViewController: UIViewController!
//    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let wordsListViewController = storyboard.instantiateViewController(withIdentifier: "WordsList")as! WordsListViewController
        let categoryListViewController = storyboard.instantiateViewController(withIdentifier: "CategoryList")as! CategoryListViewController
        let ideasListViewController = storyboard.instantiateViewController(withIdentifier: "IdeasList")as! IdeasListViewController
        let ideasSlotViewController = storyboard.instantiateViewController(withIdentifier: "IdeasSlot")as! IdeasSlotViewController
        self.wordsListViewController = UINavigationController(rootViewController: wordsListViewController)
        self.categoryListViewController = UINavigationController(rootViewController: categoryListViewController)
        self.ideasListViewController = UINavigationController(rootViewController: ideasListViewController)
        self.ideasSlotViewController = UINavigationController(rootViewController: ideasSlotViewController)
        
        self.tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: BaseTableViewCell.identifier)
        //        self.imageHeaderView = ImageHeaderView.
        //        self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .words:
            self.slideMenuController()?.changeMainViewController(wordsListViewController, close: true)
        case .category:
            self.slideMenuController()?.changeMainViewController(categoryListViewController, close: true)
        case .ideas:
            self.slideMenuController()?.changeMainViewController(ideasListViewController, close: true)
        case .slot:
            self.slideMenuController()?.changeMainViewController(ideasSlotViewController, close: true)
        }
    }
}

extension LeftMenuViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row){
            switch menu{
            case .words, .category, .ideas, .slot:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row){
            self.changeViewController(menu)
        }
    }
}

extension LeftMenuViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .words, .category, .ideas, .slot:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }    
}
