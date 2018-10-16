//
//  DetailViewController.swift
//  APIAwakens
//
//  Created by EG1 on 10/1/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var selectedItemLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    @IBOutlet weak var value1: UILabel!
    @IBOutlet weak var value2: UILabel!
    @IBOutlet weak var value3: UILabel!
    @IBOutlet weak var value4: UILabel!
    @IBOutlet weak var value5: UILabel!
    @IBOutlet weak var exchangeRateValue: UITextField!
    @IBOutlet weak var smallestItemValue: UILabel!
    @IBOutlet weak var largestItemValue: UILabel!
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var creditButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var metricButton: UIButton!
    
    var category:Category?
    let client = Client()
    var characters:[Character]=[]
    var characterHeight:[Character]=[]
    var selectedCharacter:Character?
    var vehicles:[Vehicle]=[]
    var vehicleLength:[Vehicle]=[]
    var selectedVehicle:Vehicle?
    var starships:[Starship]=[]
    var starshipLength:[Starship]=[]
    var selectedStarship:Starship?

    @IBAction func exchangeRateValue(_ sender: UITextField) {
        //Display key pad when user clicks on text view
        exchangeRateValue.becomeFirstResponder()
        exchangeRateValue.keyboardType = .asciiCapableNumberPad
        addDoneButton()
    }
    
    @IBAction func usdButton(_ sender: UIButton) {
        if let category = category{
            switch category{
            case .vehicle:
            if let exchangeRate=self.exchangeRateValue.text{
                if let credit=selectedVehicle?.costInCredits{
                    if let credit=Double(credit){
                        convertToUSD(credit, exchangeRate)
                    }else{
                        self.value2.text = String(credit)
                    }
                }else{
                    if let credit=Double(vehicles[0].costInCredits){
                        convertToUSD(credit, exchangeRate)
                    }else{
                        self.value2.text = String(vehicles[0].costInCredits)
                    }
                }
            }
            case .starship:
            if let exchangeRate=self.exchangeRateValue.text{
                if let credit=selectedStarship?.costInCredits{
                    if let credit=Double(credit){
                        convertToUSD(credit, exchangeRate)
                    }else{
                        self.value2.text = String(credit)
                    }
                }else{
                    if let credit=Double(starships[0].costInCredits){
                        convertToUSD(credit, exchangeRate)
                    }else{
                        self.value2.text = String(starships[0].costInCredits)
                    }
                }
            }
            default:
                return
            }
        }
        creditButton.tintColor = .gray
        usdButton.tintColor = .orange
        exchangeRateLabel.isHidden = false
        exchangeRateValue.isHidden = false
    }
    
    @IBAction func creditButton(_ sender: UIButton) {
        if let category = category{
            switch category {
            case .vehicle:
                if let selectedVehicle = selectedVehicle{
                    let selectedVehicleCost = selectedVehicle.costInCredits
                    self.value2.text = selectedVehicleCost
                }else{
                    self.value2.text = vehicles[0].costInCredits
                }
            case .starship:
                if let selectedStarship = selectedStarship{
                    let selectedStarshipCost = selectedStarship.costInCredits
                    self.value2.text = selectedStarshipCost
                }else{
                    self.value2.text = starships[0].costInCredits
                }
            default:
                return
            }
        }
        creditButton.tintColor = .orange
        usdButton.tintColor = .gray
        exchangeRateLabel.isHidden = true
        exchangeRateValue.isHidden = true
    }
    
    @IBAction func englishButton(_ sender: UIButton) {
        if let category = category{
            switch category {
            case .character:
                if let selectedCharacter = selectedCharacter, let height=Double(selectedCharacter.height){
                    convertToInches(height)
                }else if let height=Double(self.characters[0].height){
                    convertToInches(height)
                }
            case .vehicle:
                if let selectedVehicle = selectedVehicle, let length=Double(selectedVehicle.length){
                    convertToFeet(length)
                }else if let length=Double(self.vehicles[0].length){
                    convertToFeet(length)
                }
            case .starship:
                if let selectedStarship = selectedStarship, let length=Double(selectedStarship.length){
                    convertToFeet(length)
                }else if let length=Double(self.starships[0].length){
                    convertToFeet(length)
                }
            }
        }
        metricButton.tintColor = .gray
        englishButton.tintColor = .orange
    }
    
    @IBAction func metricButton(_ sender: UIButton) {
        if let category = category{
            switch category {
            case .character:
                if let selectedCharacter = selectedCharacter{
                    let selectedCharacterHeight = selectedCharacter.height
                    self.value3.text = "\(selectedCharacterHeight) cm"
                }else{
                    let firstCharacterHeight = self.characters[0].height
                    self.value3.text = "\(firstCharacterHeight) cm"
                }
            case .vehicle:
                if let selectedVehicle = selectedVehicle{
                    let selectedVehicleLength = selectedVehicle.length
                    self.value3.text = "\(selectedVehicleLength) m"
                }else{
                    let firstVehicleLength = self.vehicles[0].length
                    self.value3.text = "\(firstVehicleLength) m"
                }
            case .starship:
                if let selectedStarship = selectedStarship{
                    let selectedStarshipLength = selectedStarship.length
                    self.value3.text = "\(selectedStarshipLength) m"
                }else{
                    let firstStarshipLength = self.starships[0].length
                    self.value3.text = "\(firstStarshipLength) m"
                }
            }
        }
        englishButton.tintColor = .gray
        metricButton.tintColor = .orange
    }
    
    @IBOutlet weak var itemPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialValues()
        if let category = category{
            switch category {
            case .character:
                self.navigationItem.title = Category.character.rawValue
                setLabelsAndButtons(for: .character)
                client.getCharacters() { [unowned self] characters, error in
                    if let characters = characters {
                        for result in characters.results{
                            self.client.getCharacterHome(result.homeworld){[unowned self] planet, error in
                                if let planet = planet {
                                    let character = Character(name: result.name, height: result.height, mass: result.mass, hairColor: result.hair_color, eyeColor: result.eye_color, birthYear: result.birth_year, homeWorld: planet.name)
                                    self.characters.append(character)
                                    self.characterHeight.append(character)
                                    
                                    self.selectedItemLabel.text = self.characters[0].name
                                    self.value1.text = self.characters[0].birthYear
                                    self.value2.text = self.characters[0].homeWorld
                                    self.value3.text = "\(self.characters[0].height) cm"
                                    self.value4.text = self.characters[0].eyeColor
                                    self.value5.text = self.characters[0].hairColor
                                    
                                    self.characterHeight.sort(by: { (firstCharacter, secondCharacter) -> Bool in
                                        let firstHeight = Int(firstCharacter.height)!
                                        let secondHeight = Int(secondCharacter.height)!
                                        return firstHeight < secondHeight
                                    })
                                    self.smallestItemValue.text = self.characterHeight[0].name
                                    self.largestItemValue.text = self.characterHeight[self.characterHeight.count-1].name
                                    
                                    self.enableButtons(for: .character)
                                    
                                    //Initialize picker
                                    self.itemPicker.delegate = self
                                    self.itemPicker.dataSource = self
                                }
                                if let error = error{
                                    let errorMessage = error.localizedDescription
                                    self.showAlert(message: errorMessage)
                                }
                            }
                        }
                    }
                    if let error = error{
                        let errorMessage = error.localizedDescription
                        self.showAlert(message: errorMessage)
                    }
                }
                break
            case .vehicle:
                self.navigationItem.title = Category.vehicle.rawValue
                setLabelsAndButtons(for: .vehicle)
                client.getVehicles() { [unowned self] vehicles, error in
                    if let vehicles = vehicles {
                        for result in vehicles.results{
                            let vehicle=Vehicle(name: result.name, model: result.model, manufacturer: result.manufacturer, costInCredits: result.cost_in_credits, length: result.length, crew: result.crew, vehicleClass: result.vehicle_class)
                            self.vehicles.append(vehicle)
                            self.vehicleLength.append(vehicle)
                            
                            self.selectedItemLabel.text = self.vehicles[0].name
                            self.value1.text = self.vehicles[0].model
                            self.value2.text = self.vehicles[0].costInCredits
                            self.value3.text = "\(self.vehicles[0].length) m"
                            self.value4.text = self.vehicles[0].vehicleClass
                            self.value5.text = self.vehicles[0].crew
                            
                            //Sort to pick the smallest and largest
                            self.vehicleLength.sort(by: { (firstVehicle, secondVehicle) -> Bool in
                                let firstLength = Double(firstVehicle.length)!
                                let secondLength = Double(secondVehicle.length)!
                                return firstLength < secondLength
                            })
                            self.smallestItemValue.text = self.vehicleLength[0].name
                            self.largestItemValue.text = self.vehicleLength[self.vehicleLength.count-1].name

                            self.enableButtons(for: .vehicle)
                            
                            //Initialize picker
                            self.itemPicker.delegate = self
                            self.itemPicker.dataSource = self
                        }
                    }
                    if let error = error{
                        let errorMessage = error.localizedDescription
                        self.showAlert(message: errorMessage)
                    }
                }
                break
            case .starship:
                self.navigationItem.title = Category.starship.rawValue
                setLabelsAndButtons(for: .starship)
                client.getStarships() { [unowned self] starships, error in
                    if let starships = starships {
                        for result in starships.results{
                            let starship=Starship(name: result.name, model: result.model, manufacturer: result.manufacturer, costInCredits: result.cost_in_credits, length: result.length, crew: result.crew, starshipClass: result.starship_class)
                            self.starships.append(starship)
                            self.starshipLength.append(starship)
                            
                            self.selectedItemLabel.text = self.starships[0].name
                            self.value1.text = self.starships[0].model
                            self.value2.text = self.starships[0].costInCredits
                            self.value3.text = "\(self.starships[0].length) m"
                            self.value4.text = self.starships[0].starshipClass
                            self.value5.text = self.starships[0].crew
                            
                            //Sort to pick the smallest and largest
                            self.starshipLength.sort(by: { (firstStarship, secondStarship) -> Bool in
                                let firstLength = Double(firstStarship.length)!
                                let secondLength = Double(secondStarship.length)!
                                return firstLength < secondLength
                            })
                            self.smallestItemValue.text = self.starshipLength[0].name
                            self.largestItemValue.text = self.starshipLength[self.starshipLength.count-1].name
                            
                            self.enableButtons(for: .starship)
                            
                            //Initialize picker
                            self.itemPicker.delegate = self
                            self.itemPicker.dataSource = self
                        }
                    }
                    if let error = error{
                        let errorMessage = error.localizedDescription
                        self.showAlert(message: errorMessage)
                    }
                }
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Number of column
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //Number of row
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let category = category{
            switch category {
            case .character:
                return self.characters.count
            case .vehicle:
                return self.vehicles.count
            case .starship:
                return self.starships.count
            }
        }
        return 0
    }
    //Item displayed on picker
    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let category = category{
            switch category {
            case .character:
                return self.characters[row].name
            case .vehicle:
                return self.vehicles[row].name
            case .starship:
                return self.starships[row].name
            }
        }
        return ""
    }
    //Item selected
    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let category = category{
            switch category {
            case .character:
                self.selectedItemLabel.text = self.characters[row].name
                self.value1.text = self.characters[row].birthYear
                self.value2.text = self.characters[row].homeWorld
                self.value3.text = "\(self.characters[row].height) cm"
                self.value4.text = self.characters[row].eyeColor
                self.value5.text = self.characters[row].hairColor
                
                self.selectedCharacter = self.characters[row]
                enableButtons(for: .character)
            case .vehicle:
                self.selectedItemLabel.text = self.vehicles[row].name
                self.value1.text = self.vehicles[row].manufacturer
                self.value2.text = self.vehicles[row].costInCredits
                self.value3.text = "\(self.vehicles[row].length) m"
                self.value4.text = self.vehicles[row].vehicleClass
                self.value5.text = self.vehicles[row].crew
                
                self.selectedVehicle = self.vehicles[row]
                enableButtons(for: .vehicle)
            case .starship:
                self.selectedItemLabel.text = self.starships[row].name
                self.value1.text = self.starships[row].manufacturer
                self.value2.text = self.starships[row].costInCredits
                self.value3.text = "\(self.starships[row].length) m"
                self.value4.text = self.starships[row].starshipClass
                self.value5.text = self.starships[row].crew
                
                self.selectedStarship = self.starships[row]
                enableButtons(for: .starship)
            }
        }
    }
    
    func addDoneButton(){
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked) )
        
        keyboardToolBar.setItems([flexibleSpace, doneButton], animated: true)
        
        exchangeRateValue.inputAccessoryView = keyboardToolBar
    }
    

    @objc func doneClicked() {
        view.endEditing(true)
        if let category = category{
            switch category{
            case .vehicle:
            if let exchangeRate=self.exchangeRateValue.text{
                if let credit=selectedVehicle?.costInCredits{
                    if let credit=Double(credit){
                        convertToUSD(credit, exchangeRate)
                    }else{
                        self.value2.text = String(credit)
                    }
                }else{
                    if let credit=Double(vehicles[0].costInCredits){
                        convertToUSD(credit, exchangeRate)
                    }else{
                        self.value2.text = String(vehicles[0].costInCredits)
                    }
                }
            }
            case .starship:
            if let exchangeRate=self.exchangeRateValue.text{
                if let credit=selectedStarship?.costInCredits{
                    if let credit=Double(credit){
                        convertToUSD(credit, exchangeRate)
                    }else{
                        self.value2.text = String(credit)
                    }
                }else{
                    if let credit=Double(starships[0].costInCredits){
                        convertToUSD(credit, exchangeRate)
                    }else{
                        self.value2.text = String(starships[0].costInCredits)
                    }
                }
            }
            default:
                return
            }
        }
        exchangeRateValue.resignFirstResponder()
    }
    
    func showAlert(message:String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func convertToUSD(_ credit:Double,_ exchangeRate:String){
        if let exchangeRate=Double(exchangeRate){
            if exchangeRate > 0.0{
                let costInUsd=credit/exchangeRate
                self.value2.text = String(format:"%.1f",costInUsd)
            }else{
                showAlert(message: Message.wrongNumber.rawValue)
            }
        }else{
            showAlert(message: Message.emptyField.rawValue)
        }
    }
    
    func convertToInches(_ height:Double){
        let heightInInch = height * 0.39
        self.value3.text = String("\(heightInInch) in")
    }
    
    func convertToFeet(_ length:Double){
        let lengthInFoot = length / 0.3048
        self.value3.text = String(format: "%.1f", lengthInFoot) + "ft"
    }
    
    func setLabelsAndButtons(for category:Category){
        switch category {
        case .character:
            label1.text = Label.born.rawValue
            label2.text = Label.home.rawValue
            label3.text = Label.height.rawValue
            label4.text = Label.eyes.rawValue
            label5.text = Label.hair.rawValue
            usdButton.isHidden = true
            creditButton.isHidden = true
            exchangeRateLabel.isHidden = true
            exchangeRateValue.isHidden = true
            self.creditButton.isEnabled = false
            self.usdButton.isEnabled = false
            self.englishButton.isEnabled = false
            self.metricButton.isEnabled = false
        case .vehicle,.starship:
            label1.text = Label.make.rawValue
            label2.text = Label.cost.rawValue
            label3.text = Label.length.rawValue
            label4.text = Label.vehicleClass.rawValue
            label5.text = Label.crew.rawValue
            usdButton.isHidden = false
            creditButton.isHidden = false
            exchangeRateLabel.isHidden = true
            exchangeRateValue.isHidden = true
            self.creditButton.isEnabled = false
            self.usdButton.isEnabled = false
            self.englishButton.isEnabled = false
            self.metricButton.isEnabled = false
        }
    }
    
    func enableButtons(for category:Category){
        switch category {
        case .character:
            self.englishButton.tintColor = .gray
            self.metricButton.tintColor = .orange
            self.creditButton.isEnabled = true
            self.usdButton.isEnabled = true
            self.englishButton.isEnabled = true
            self.metricButton.isEnabled = true
        case .vehicle,.starship:
            self.englishButton.tintColor = .gray
            self.metricButton.tintColor = .orange
            self.creditButton.tintColor = .orange
            self.usdButton.tintColor = .gray
            self.creditButton.isEnabled = true
            self.usdButton.isEnabled = true
            self.englishButton.isEnabled = true
            self.metricButton.isEnabled = true
        }
    }
    
    func setInitialValues(){
        selectedItemLabel.text = ""
        value1.text = ""
        value2.text = ""
        value3.text = ""
        value4.text = ""
        value5.text = ""
        smallestItemValue.text = ""
        largestItemValue.text = ""
    }
}
