//
//  SettingsViewController.swift
//  meetup
//
//  Created by An Phan  on 3/30/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RangeSeekSlider
import LocationPickerViewController

class SettingsViewController: UIViewController, UITextFieldDelegate
{
    
    // MARK: - IBOutlet
//    @IBOutlet weak var segmentControl: UISegmentedControl!
//    @IBOutlet weak var distanceSwitch: UISwitch!
    @IBOutlet weak var distanceSlide: RangeSeekSlider!
    @IBOutlet weak var ageSlide: RangeSeekSlider!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var raceTextfield: UITextField!
    @IBOutlet weak var bodyTextfield: UITextField!
    
    // MARK: - Variable
    var minDistance: Int?
    var maxDistance: Int?
    var minAge: Int?
    var maxAge: Int?
   
    var bodyModel = [BodyModel]()
    var picker = UIPickerView()
    var model = [AllProfileModel]()
    var lat : Double?
    var long: Double?
    let locationPicker = LocationPicker()
    var modelRace = [RaceModel]()
    
    // MARK: - Private var/let
    private var tapGeture: UITapGestureRecognizer!
    private var swipeGeture: UISwipeGestureRecognizer!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareStyle()
        prepareNavigationBar()
        addTapGeture()
        addSwipeGeture()
        distanceSlide.delegate = self
        ageSlide.delegate = self
        self.sideMenuController()?.sideMenu?.delegate = self
        self.raceTextfield.delegate = self
        self.bodyTextfield.delegate = self
        self.locationTextField.delegate = self
        self.picker.delegate = self
        self.picker.backgroundColor = UIColor.white
        DispatchQueue.main.async {
            self.fetchSettingApi()
            self.fetchRace()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden  = true
    }
    
    // MARK: - Private Variable
    private func addTapGeture() {
        tapGeture = UITapGestureRecognizer(target: self, action: #selector(mainViewTapped))
        tapGeture.isEnabled = false
        view.addGestureRecognizer(tapGeture)
    }
    
    private func addSwipeGeture() {
        swipeGeture = UISwipeGestureRecognizer(target: self, action: #selector(mainViewTapped))
        swipeGeture.isEnabled = false
        swipeGeture.direction = .right
        view.addGestureRecognizer(swipeGeture)
    }
    
    private func prepareNavigationBar() {
        // Added right bar button
        let moreBarButtonItem = UIBarButtonItem(image: UIImage(named: "more-icon"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(moreBarButtonAction))
        navigationItem.rightBarButtonItem = moreBarButtonItem
    }
    
    private func prepareStyle() {
        //Segment controll
//        segmentControl.layer.cornerRadius = 0.0
//        segmentControl.layer.borderWidth = 1.5
//        segmentControl.layer.borderColor = UIColor.redColor().cgColor
//        segmentControl.layer.masksToBounds = true
//        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.sfProTextMedium(size: 14)], for: .normal)
//        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.sfProTextMedium(size: 14)], for: .selected)
        //Distance switch
//        distanceSwitch.set(width: 36, height: 20)
//        distanceSwitch.onTintColor = UIColor.redColor()
        //Search button
        searchButton.bordered(withColor: UIColor.borderColor(), width: 1, radius: 7)
    }

    //MARK: - @Objc Method
    @objc func mainViewTapped(swipe: UISwipeGestureRecognizer) {
        hideSideMenuView()
    }
    
    @objc func moreBarButtonAction() {
        swipeGeture.isEnabled = true
        toggleSideMenuView()
    }
    
    // MARK: - IBAction
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
    
    @IBAction func distenceValueChanged(_ sender: UISwitch) {
    
    }
    
    @IBAction func SearchAction(_ sender: UIButton) {
        guard locationTextField.text != ""else{
            self.showalert(msg: "Please Enter Location")
            return
        }
        guard raceTextfield.text != ""else{
            self.showalert(msg: "Please Enter Race")
            return
        }
//        guard bodyTextfield.text != ""else{
//            self.showalert(msg: "Please Enter Body_Type")
//            return
//        }
        self.searchNowApi()
    }
    
    //MARK:- Api
    func searchNowApi(){
        let param : Parameters = ["userID" : standard.string(forKey: "userId") ?? "",
//                                  "LookingFor": "\(segmentControl.selectedSegmentIndex)",
                                  "LocationName": locationTextField.text ?? "",
                                  "LocationLatitude": "\(lat ?? 0.0)",
                                  "LocationLongitude": "\(long ?? 0.0)",
                                  "MaxDistance": "\(self.maxDistance ?? 100)",     //
                                  "MinDistance": "\(self.minDistance ?? 10)",       //
                                  "MinAge" : "\(self.minAge ?? 10)",           //
                                  "MaxAge" : "\(self.maxAge ?? 100)",          //
                                  "RaceType": raceTextfield.text ?? "" ,
                                  "BodyType": ((bodyTextfield.text ?? "") != "None") ? (bodyTextfield.text ?? "") : "",
                                 /* "ShowUserDistance" : (self.distanceSwitch.isOn) ? "1" : "0"*/]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "SearchFilter", param: param, header: [:], success: { (json) in
            print(json)
            self.view.stopProgresshub()
            if json["status"].intValue == 1{
                if let items = json["data"].array{
                    self.model = items.map({AllProfileModel.init(json: $0)})
                }
                guard self.model.count != 0 else{
                    self.showalert(msg: "No Profiles in this area are available at the Moment")
                    return
                }
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
                let destVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                destVC.model = self.model
//                destVC.showDistance = (self.distanceSwitch.isOn) ? true : false
                if let vc = self.sideMenuController()?.sideMenu?.menuViewController as? MenuViewController{
                    vc.selectedMenuItem = 0
                    vc.tableView.reloadData()
                }
                self.sideMenuController()?.setContentViewController(destVC)
                self.navigationController?.pushViewController(destVC, animated: true)
            }
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    
    func fetchSettingApi(){
        let param: Parameters = ["userID": standard.string(forKey: "userId") ?? ""] //
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitApi(url: apiURL + "UsersSetting", param: param, header: [:], success: { (json) in
            print(json)
            if json["status"].intValue == 1{
                DispatchQueue.main.async {
                    self.loadData(json: json)
                }
            }
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    
    func fetchRace(){
        let param: Parameters = [:]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToGetApi(url: apiURL + "fetchRaces", param: param, header: [:], success: { (json) in
            print(json)
            if let items = json["data"].array{
                self.modelRace = items.map({RaceModel.init(json: $0)})
            }
            self.fetchBody()
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
    }
    
    func fetchBody(){
        let param: Parameters = [:]
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToGetApi(url: apiURL + "fetchBodyTypes", param: param, header: [:], success: { (json) in
            print(json)
            if let items = json["data"].array{
                self.bodyModel = items.map({BodyModel.init(json: $0)})
            }
            self.view.stopProgresshub()
        }) { (error) in
            print(error)
            self.view.stopProgresshub()
        }
        
    }
    
    
    //MARK:- Additional Functions
    func loadData(json: JSON){
        self.bodyTextfield.text = json["data"]["BodyType"].stringValue
        self.raceTextfield.text = json["data"]["RaceType"].stringValue
//        self.segmentControl.selectedSegmentIndex = (json["data"]["LookingFor"].stringValue == "male") ? 0 : 1
//        self.distanceSwitch.isOn = (json["data"]["ShowUserDistance"].intValue == 1) ? true : false
        self.ageSlide.selectedMinValue = CGFloat(json["data"]["MinAge"].doubleValue)
        self.ageSlide.selectedMaxValue = CGFloat(json["data"]["MaxAge"].doubleValue)
        self.distanceSlide.selectedMaxValue = CGFloat(json["data"]["MaxDistance"].doubleValue)
        self.distanceSlide.selectedMinValue = CGFloat(json["data"]["MinDistance"].doubleValue)
        self.minDistance = (json["data"]["MinDistance"].intValue)
        self.maxDistance = (json["data"]["MaxDistance"].intValue)
        self.distanceLabel.text = "\(json["data"]["MinDistance"].intValue)" + "-" + "\(json["data"]["MaxDistance"].intValue)" + " Miles"
        self.ageLabel.text = "\(json["data"]["MinAge"].intValue)" + "-" + "\(json["data"]["MaxAge"].intValue)" + " years"
        self.minAge = json["data"]["MinAge"].intValue
        self.maxAge = json["data"]["MaxAge"].intValue
        self.locationTextField.text = json["data"]["LocationName"].stringValue
    }
    
    //MARK:- textfield Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == bodyTextfield{
            textField.inputView = picker
            picker.tag = 0
            textField.text = self.bodyModel[0].bodyTypeNames ?? ""
        }
        else if textField == raceTextfield{
            textField.inputView = picker
            picker.tag = 1
            textField.text = modelRace[0].raceName ?? ""
        }
        else if textField == locationTextField{
            guard standard.bool(forKey: "paymentStatus") else{
                self.showalert(msg: "Please upgrade the app first.")
                return
            }
            self.showAutoCompleteVC()
            textField.resignFirstResponder()
        }
    }
    
    func showAutoCompleteVC(){
        locationPicker.delegate = self
        locationPicker.mapView.isHidden = true
        locationPicker.searchBar.text = ""
        self.present(locationPicker, animated: true, completion: nil)
    }
}

//MARK: - LocationPickerDelegates-
extension SettingsViewController : LocationPickerDelegate{
    func locationDidSelect(locationItem: LocationItem) {
        print("didSelect")
        print(locationItem.addressDictionary ?? [:])
//        print(locationItem.coordinate)
        self.long = locationItem.coordinate?.latitude
        self.long = locationItem.coordinate?.longitude
        let dict = JSON(locationItem.addressDictionary ?? [:]).dictionaryValue
        self.locationTextField.text = (dict["Name"]?.stringValue ?? "") + "," + (dict["City"]?.stringValue ?? "")
        self.locationPicker.dismiss(animated: true) {
            print("Dismissed")
        }
    }
}

//MARK: - PickerViewDelegates and PickerViewDataSources -
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (picker.tag == 0) ? bodyModel.count : modelRace.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (picker.tag == 0) {
          bodyTextfield.text = bodyModel[row].bodyTypeNames ?? ""
        } else{
          raceTextfield.text = modelRace[row].raceName ?? ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (picker.tag == 0) ? (bodyModel[row].bodyTypeNames ?? "") : (modelRace[row].raceName ?? "")
    }
}

//MARK: - RangeSeeksSliderDelegates -
extension SettingsViewController: RangeSeekSliderDelegate{
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider == distanceSlide{
            self.distanceLabel.text = "\(Int(minValue))" + "-" + "\(Int(maxValue))" + " Miles"
            self.minDistance = Int(minValue)
            self.maxDistance = Int(maxValue)
        }else{
          self.ageLabel.text = "\(Int(minValue))" + "-" + "\(Int(maxValue))" + " years"
            self.minAge = Int(minValue)
            self.maxAge = Int(maxValue)
        }
    }
}

//MARK: - ENSideMenuDelegates-
extension SettingsViewController: ENSideMenuDelegate {
    func sideMenuWillOpen() {
        tapGeture.isEnabled = true
        swipeGeture.isEnabled = true
        UIView.animate(withDuration: 0.2) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func sideMenuWillClose() {
        tapGeture.isEnabled = false
        swipeGeture.isEnabled = false
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return swipeGeture.isEnabled
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
}

