//
//  IdeasSlotViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/27.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown
import PopupWindow

class IdeaDto: Object {
    var ideaName: String? = nil
    var categoryName: String? = ""
    var operator1: String? = "Plus"
    var details: String? = nil
    var words = [Words](repeating: Words(), count: 2)
}

class IdeasSlotViewController: UIViewController {

    var ideaSlotPickerView = IdeaSlotPickerView(){
        didSet{
            ideaSlotPickerView.frame = CGRect(x: 0, y: 100, width: IdeaSlotPickerView.Const.width, height: IdeaSlotPickerView.Const.height)
            ideaSlotPickerView.dropdown.dataSource = categoryManager.arrayCategoryList(listFlg: 1)
            ideaSlotPickerView.slotFlg = 1
        }
    }
    var ideaSlotPickerView2 = IdeaSlotPickerView(){
        didSet{
            ideaSlotPickerView2.frame = CGRect(x: self.view.frame.width - IdeaSlotPickerView.Const.width, y: 100, width: IdeaSlotPickerView.Const.width, height: IdeaSlotPickerView.Const.height)
            ideaSlotPickerView2.dropdown.dataSource = categoryManager.arrayCategoryList(listFlg: 1)
            ideaSlotPickerView2.slotFlg = 2
        }
    }
    var operatorButton = UIButton(){
        didSet{
            operatorButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    var shuffleButton = UIButton()
    var pickupButton = UIButton()
    
    var wordEntities:Results<Words>? = nil
    var operatorName:[String] = ["Plus", "Minus", "Multiply", "Divide"]
    var ideaDto:IdeaDto? = IdeaDto()
    let dropdown = DropDown()
    let wordManager = WordManager()
    let categoryManager = CategoryManager()
    let ideaManager = IdeaManager()

    /**
     viewDidLoad
     **/
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle()
        setNavigationBarItem()
        
        //picker 1
        //***********************************************************************//
        ideaSlotPickerView = UINib(nibName: "IdeaSlotPickerView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! IdeaSlotPickerView
        ideaSlotPickerView.categoryButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            self!.ideaSlotPickerView = me.setPickerViewData(view: self!.ideaSlotPickerView, setFlg: 1)
        }
        ideaSlotPickerView.playButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            me.playSlotPicker(view: self!.ideaSlotPickerView)
        }

        //picker 2
        //***********************************************************************//
        ideaSlotPickerView2 = UINib(nibName: "IdeaSlotPickerView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! IdeaSlotPickerView
        ideaSlotPickerView2.categoryButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            self!.ideaSlotPickerView2 = me.setPickerViewData(view: self!.ideaSlotPickerView2, setFlg: 1)
        }
        ideaSlotPickerView2.playButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            me.playSlotPicker(view: self!.ideaSlotPickerView2)
        }

        //operator button
        //***********************************************************************//
        dropdown.anchorView = operatorButton
        dropdown.dataSource = operatorName
        dropdown.selectionAction = {(index, item) in
            self.operatorButton.setImage(UIImage(named: "Operator-\(self.operatorName[index])"), for: .normal)
            self.ideaDto!.operator1 = item
        }
        operatorButton.frame = CGRect(x: self.view.frame.size.width / 2 - 15, y: 235, width: 30, height: 30)
        operatorButton.setImage(UIImage(named: "Operator-Plus"), for: .normal)
        operatorButton.addTarget(self, action: #selector(showOperator), for: .touchUpInside)
        

        //shuffle button
        //***********************************************************************//
        shuffleButton.setTitle("All Shuffle", for: .normal)
        shuffleButton.frame = CGRect(x: 100, y: 425, width: 200, height: 40)
        shuffleButton.backgroundColor = UIColor.AppColor.buttonColor
        shuffleButton.addTarget(self, action: #selector(shuffleButtonAction), for: .touchUpInside)
        shuffleButton.layer.masksToBounds = true
        shuffleButton.layer.cornerRadius = 5.0
        
        //pickup button
        //***********************************************************************//
        pickupButton.setTitle("Pick Up", for: .normal)
        pickupButton.frame = CGRect(x: 100, y: 500, width: 200, height: 40)
        pickupButton.backgroundColor = UIColor.AppColor.buttonColor
        pickupButton.addTarget(self, action: #selector(setRegisterForm), for: .touchUpInside)
        pickupButton.layer.masksToBounds = true
        pickupButton.layer.cornerRadius = 5.0
        pickupButton.isEnabled = false

        //addSubView
        //***********************************************************************//
        self.view.addSubview(operatorButton)
        self.view.addSubview(ideaSlotPickerView)
        self.view.addSubview(ideaSlotPickerView2)
        self.view.addSubview(shuffleButton)
        self.view.addSubview(pickupButton)
    }
    
    /**
     viewWillAppear
     **/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wordEntities = wordManager.getResultsWords(filterName: nil, filterItem: nil, sort: "updateDate", ascending: false)
        
        //picker 1
        //***********************************************************************//
        ideaSlotPickerView = setPickerViewData(view: ideaSlotPickerView, setFlg: 0)
        ideaSlotPickerView.pickerViewRows = ideaSlotPickerView.wordNameList!.count * 10
        ideaSlotPickerView.pickerViewMiddle = ideaSlotPickerView.pickerViewRows / 2
        ideaSlotPickerView.wordsPickerView.selectRow(ideaSlotPickerView.pickerViewMiddle, inComponent: 0, animated: false)

        //picker 2
        //***********************************************************************//
        ideaSlotPickerView2 = setPickerViewData(view: ideaSlotPickerView2, setFlg: 0)
        ideaSlotPickerView2.pickerViewRows = ideaSlotPickerView2.wordNameList!.count * 10
        ideaSlotPickerView2.pickerViewMiddle = ideaSlotPickerView2.pickerViewRows / 2
        ideaSlotPickerView2.wordsPickerView.selectRow(ideaSlotPickerView2.pickerViewMiddle, inComponent: 0, animated: false)
        
        setIdeaData(view: ideaSlotPickerView)
        setIdeaData(view: ideaSlotPickerView2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //change operator
    @objc func showOperator() {
        dropdown.show()
    }
    
    //play all shuffle
    @objc func shuffleButtonAction(){
        playSlotPicker(view: ideaSlotPickerView)
        playSlotPicker(view: ideaSlotPickerView2)
    }
    
    //show register form
    @objc func setRegisterForm() {
        let ideaRegisterFormViewController = IdeaRegisterFormViewController()
        self.ideaDto?.categoryName = "No Category"
        ideaRegisterFormViewController.ideaDto = ideaDto
        PopupWindowManager.shared.changeKeyWindow(rootViewController: ideaRegisterFormViewController)
    }
    
    //create word's name list
    func arrayWordList(wordList: Array<Words>) -> Array<String> {
        var wordNameList:[String] = []

        for word in wordList{
            wordNameList.append(word.word!)
        }
        return wordNameList
    }
    
    //create filtered words list
    func filteredWordList(category:Category?) -> Array<Words>? {
        var wordList:Array<Words> = Array(wordEntities!)
        if category != nil && category?.categoryId != 0 {
            wordList = Array(category!.words)
        }
        return wordList
    }
    
    //set pickerview's property
    func setPickerViewData(view: IdeaSlotPickerView,setFlg:Int) -> IdeaSlotPickerView{
        switch setFlg {
        case 0: //all
            view.category = categoryManager.findCategoryItem(categoryName: "")
            view.wordList = self.filteredWordList(category: nil)
            view.wordNameList = self.arrayWordList(wordList: view.wordList!)

        case 1: //selected category
            view.category = categoryManager.findCategoryItem(categoryName: view.categoryName!)
            view.wordList = self.filteredWordList(category: view.category)
            view.wordNameList = self.arrayWordList(wordList: view.wordList!)
            view.wordsPickerView.reloadAllComponents()
            view.wordsPickerView.selectRow(view.randomNumber(size: view.pickerViewRows), inComponent: 0, animated: false)
        default:
            break
        }
        return view
    }

    //slot animation and get picker's text
    func playSlotPicker(view: IdeaSlotPickerView){
        
        if view.wordNameList!.count > 0 {
            view.wordsPickerView.selectRow(view.randomNumber(size: view.pickerViewRows), inComponent: 0, animated: true)
        }
        
        //set picker's text
        setIdeaData(view: view)
        
        if pickupButton.isEnabled == false{
            pickupButton.isEnabled = true
        }
    }
    
    //set idea's data
    func setIdeaData(view: IdeaSlotPickerView){
        let rowWord = view.wordList![view.wordsPickerView.selectedRow(inComponent: 0) % view.wordNameList!.count]
        //set idea's data
        switch view.slotFlg {
        case 1:
            ideaDto?.words.remove(at: 0)
            ideaDto?.words.insert(rowWord, at: 0)
        case 2:
            ideaDto?.words.remove(at: 1)
            ideaDto?.words.insert(rowWord, at: 1)
        default:
            break
        }
    }
    
}
