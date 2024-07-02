//
//  AddAddressViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 21/09/2023.
//

import UIKit

class AddAddressViewController: UIViewController {

    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var cityTblV: UITableView!
    @IBOutlet weak var countryTblV: UITableView!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryTableView: UIView!
    @IBOutlet weak var pakistanRadioImg: UIImageView!
    @IBOutlet weak var internationalRadioImg: UIImageView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var officeBtn: UIButton!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var address1TF: UITextField!
    @IBOutlet weak var address2TF: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var fullnameTF: UITextField!
    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var countryImg: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var cityViewPakistan: UIView!
    @IBOutlet weak var cityViewInternational: UIView!
    @IBOutlet weak var backgroundHandleView: UIView!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var fullnameValidationImg: UIImageView!
    @IBOutlet weak var mobileNumberValidationImg: UIImageView!
    @IBOutlet weak var cityValidationView: UIView!
    @IBOutlet weak var addressValidationImg: UIImageView!
    @IBOutlet weak var address2ValidationImg: UIImageView!
    @IBOutlet weak var zipCodeValidationImg: UIImageView!
    @IBOutlet weak var cityValidationImg: UIImageView!
    @IBOutlet weak var mobileNumerHeadingLbl: UILabel!
    @IBOutlet weak var mobileNumerCodeLbl: UILabel!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollHeightinnerview: NSLayoutConstraint!

    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var addNewAddressi18: UILabel!
    @IBOutlet weak var pakistani18: UILabel!
    @IBOutlet weak var internationali18: UILabel!
    @IBOutlet weak var receiverFullNamei18: UILabel!
    @IBOutlet weak var whatsappNumberi18: UILabel!
    @IBOutlet weak var cityi18: UILabel!
    @IBOutlet weak var countryi18: UILabel!
    @IBOutlet weak var countryNamei18: UILabel!
    @IBOutlet weak var selectCityi18: UILabel!
    @IBOutlet weak var addressi18: UILabel!
    @IBOutlet weak var zipcodei18: UILabel!
    @IBOutlet weak var saveAddressBtn: UIButton!
    @IBOutlet weak var selectCountry18n: UILabel!


    

    var city: [CitiesResponse] = []
    var defaultAddress : DefaultAddress?
    var cityName = ""
    var cityCode = ""
    var fullname = ""
    var phone = ""
    var address = ""
    var addressLine_2 = ""
    var zipCode = ""
    var cityy = ""
    var addressID = ""
    var country = ""
    
    var addressType = "home"
    var localType = "local"
    
    var isComeChange = Bool()
    var isComeOrder = Bool()
    var cities : [String] = []

    var countriesName: [String] = []
    var countriesFlag: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
         cities = [
            "Riyadh",
            "Jeddah",
            "Mecca (Makkah)",
            "Medina (Al Madinah)",
            "Dammam",
            "Khobar (Al Khobar)",
            "Ta'if",
            "Buraidah",
            "Tabuk",
            "Abha",
            "Khamis Mushait",
            "Hofuf (Al-Hofuf)",
            "Jubail (Jubail Industrial City)",
            "Yanbu (Yanbu Al Bahr)",
            "Hail",
            "Najran",
            "Al Qatif",
            "Arar",
            "Qassim (Buraydah)",
            "Al-Ahsa",
            "Al Kharj",
            "Sakaka",
            "Al Bahah",
            "Rafha",
            "Al Khafji",
            "Ad Dawadimi",
            "Dhahran",
            "Al Qunfudhah",
            "Al Wajh",
            "Tarout Island",
            "Turaif",
            "Umluj",
            "Turubah",
            "Al Majma'ah",
            "Duba",
            "Al Duwadimi",
            "Al Ghat",
            "Al Hareeq",
            "Al Jawf (Sakakah)",
            "Al Lith",
            "Al-Ula",
            "Baish",
            "Baljurashi",
            "Bisha",
            "Al-Bukayriyah",
            "Dawadmi",
            "Domat Al-Jandal",
            "Duba (Dubai)",
            "Fursan",
            "Haql",
            "Kharj",
            "Mahd Al Thahab",
            "Al Mikhwah",
            "Al Namas",
            "Al Nairyah",
            "Al Nouf",
            "Al Ola",
            "Al Omran",
            "Al Qarah",
            "Al Qunfidhah",
            "Al Qurayyat",
            "Al Safwa",
            "Al Sajir",
            "Al-Salmi",
            "Al Sawda",
            "Al Zabirah",
            "As Saffaniyah",
            "As Saffaniyah (Safaniya)",
            "Al Sairafi",
            "Al-`Ula",
            "Al `Uyaynah",
            "An Nimas",
            "Ash Shafa",
            "At Taif",
            "Ad Dilam",
            "Ad Darb",
            "Al Musawwarah",
            "Al Qurayn",
            "Al Jumum",
            "Al Midhnab",
            "Al Mithnab",
            "Al Muwayh",
            "Al Ula (Al-Ulah)",
            "Al Wajih",
            "Al Wurud",
            "Badr",
            "Balahmar",
            "Bani Malik",
            "Buqayq",
            "Al Buraik",
            "Duruma",
            "Ghat",
            "Hadda",
            "Haradh",
            "Hareeq",
            "Al Harjah",
            "Al Harth",
            "Al Jandal",
            "Al Jumum",
            "Al Kharj (Al Kharg)"
        ]


        cityTblV.delegate = self
        cityTblV.dataSource = self
        countryTblV.delegate = self
        countryTblV.dataSource = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        myStackView.addGestureRecognizer(tap)
        
        fullnameTF.text = fullname
        mobileNumberTF.text = phone
        address1TF.text = address
        address2TF.text = addressLine_2
        zipCodeTF.text = zipCode
        if cityy == "" {
            cityLbl.text = "Select City"
		}
        if country == "" {
            countryLbl.text = "Saudi Arabia"
        }else {
            countryLbl.text = country
        }
        if localType == "local" {
            scrollHeight.constant  = 650
         
            countryView.isHidden = true
            pakistanRadioImg.image = UIImage(named: "selectedRadioBlue")
            internationalRadioImg.image = UIImage(named: "radioBlue")
            cityViewPakistan.isHidden = false
            cityViewInternational.isHidden = true
            if cityy == "" {
                cityLbl.text = "Select City"
            }else {
                cityLbl.text = cityy
            }
            mobileNumerHeadingLbl.text = "mobilenmber".pLocalized(lang: LanguageManager.language) // whatsappnmber
//            mobileNumerCodeLbl.text = "+92"
            mobileNumerCodeLbl.text = "+966"
        }else {
            scrollHeight.constant = 750
           
            countryView.isHidden = false
            pakistanRadioImg.image = UIImage(named: "radioBlue")
            internationalRadioImg.image = UIImage(named: "selectedRadioBlue")
            cityViewPakistan.isHidden = true
            cityViewInternational.isHidden = false
            cityTF.text = cityy
            mobileNumerHeadingLbl.text = "whatsappnmber".pLocalized(lang: LanguageManager.language) // whatsappnmber
            mobileNumerCodeLbl.text = "+355"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LanguageRender()
        getcities()
        for code in NSLocale.isoCountryCodes {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countriesName.append(name)
        }
        
        let isoCodes = Locale.isoRegionCodes
        for isoCode in isoCodes {
            print(countryFlag(isoCode))
            countriesFlag.append(countryFlag(isoCode))
        }
        countryImg.font = UIFont.systemFont(ofSize: 30.0)
        countryImg.text = countryFlag("PK")
        
        if(isComeChange) {
            if let countryCode = countryCode(for: country, countryNames: countriesName, countryCodes: countriesFlag) {
                print("Country code for Canada: \(countryCode)")
                countryImg.text = countryCode
            } else {
               
            }
        }

    }
    
    
    func LanguageRender() {
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            
           }else{
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }
        addNewAddressi18.text = "addnewaddress".pLocalized(lang: LanguageManager.language)
        pakistani18.text = "saudi".pLocalized(lang: LanguageManager.language)
        internationali18.text = "international".pLocalized(lang: LanguageManager.language)
        receiverFullNamei18.text = "receiverfullname".pLocalized(lang: LanguageManager.language)
        cityi18.text = "city".pLocalized(lang: LanguageManager.language)
        addressi18.text = "address".pLocalized(lang: LanguageManager.language)
//        address1TF.text = "addressline1TF".pLocalized(lang: LanguageManager.language)
//        address2TF.text = "addressline2TF".pLocalized(lang: LanguageManager.language)
        zipcodei18.text = "zipcode".pLocalized(lang: LanguageManager.language)
        homeBtn.setTitle("home".pLocalized(lang: LanguageManager.language), for: .normal)
        officeBtn.setTitle("office".pLocalized(lang: LanguageManager.language), for: .normal)
        saveAddressBtn.setTitle("saveaddress".pLocalized(lang: LanguageManager.language), for: .normal)
        countryi18.text = "country".pLocalized(lang: LanguageManager.language)
        selectCountry18n.text = "selectacountry".pLocalized(lang: LanguageManager.language)

    }
    
    func validate() -> Bool {
        if fullnameTF.text == "" {
//            fullnameValidationImg.isHidden = false
            view.makeToast("fullName is required")

            return false
        }else{
            fullnameValidationImg.isHidden = true
        }
        if mobileNumberTF.text == "" {
//            mobileNumberValidationImg.isHidden = false
            view.makeToast("Mobile Numer is required")

            return false
        }else{
            mobileNumberValidationImg.isHidden = true
        }
        if mobileNumberTF.text?.count ?? 0 <= 8{
//            mobileNumberValidationImg.isHidden = false
            view.makeToast("Mobile Number must be at least 9 digits long")

            return false
        }else {
            mobileNumberValidationImg.isHidden = true
        }
        if localType == "local" {
            if cityLbl.text == "Select City" || cityLbl.text == "" {
                Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(hideView), userInfo: nil, repeats: false)
                view.makeToast("City Name Required")

//                cityValidationView.isHidden = false
                return false
            }else {
                cityValidationView.isHidden = true
            }
        }else {
            if cityTF.text == "Select City" || cityTF.text == "" {
//                cityValidationImg.isHidden = false
                view.makeToast("City Name Required")
                return false
            }else {
                cityValidationImg.isHidden = true
            }
        }

        if address1TF.text == ""{
//            addressValidationImg.isHidden = false
            view.makeToast("Address Required")
            return false
        }else {
            addressValidationImg.isHidden = true
        }
        if address1TF.text?.count ?? 0 <= 9{
//            addressValidationImg.isHidden = false
            view.makeToast("Adress length must be greater than 10 character")
            return false
        }else {
            addressValidationImg.isHidden = true
        }
//        if address2TF.text == ""{
////            addressValidationImg.isHidden = false
//            view.makeToast("Address Line 2 Required")
//            return false
//        }else {
//            addressValidationImg.isHidden = true
//        }
//        if address2TF.text?.count ?? 0 <= 9{
////            address2ValidationImg.isHidden = false
//            view.makeToast("Adress length must be greater than 10 character")
//            return false
//        }else {
//            address2ValidationImg.isHidden = true
//        }
        if zipCodeTF.text == "" {
//            zipCodeValidationImg.isHidden = false
            view.makeToast("zip code required")

            return false
        }else {
            zipCodeValidationImg.isHidden = true
        }
        if zipCodeTF.text?.count ?? 0 <= 5{
//            zipCodeValidationImg.isHidden = false
            view.makeToast("zip code/ postal code must be greater then five character")
            return false
        }else {
            zipCodeValidationImg.isHidden = true
        }
        
        return true
    }
    
    @objc func hideView() {
        cityValidationView.isHidden = true
    }
    
    func countryCode(for countryName: String, countryNames: [String], countryCodes: [String]) -> String? {
        // Ensure both arrays have the same count
        guard countryNames.count == countryCodes.count else {
            print("Mismatched arrays - country names and country codes.")
            return nil
        }
        
        // Iterate through the country names array and find the index of the specified country name
        if let index = countryNames.firstIndex(of: countryName) {
            // Use the index to retrieve the corresponding country code from the country codes array
            return countryCodes[index]
        } else {
            print("Country not found.")
            return nil
        }
    }
    
    func countryFlag(_ countryCode: String) -> String {
        let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value
                let flag = countryCode
            .uppercased()
            .unicodeScalars
            .compactMap({ UnicodeScalar(flagBase + $0.value)?.description })
            .joined()
            
        return flag
    }
    
    private func getcities(){
        APIServices.citiesResponse(){[weak self] data in
            switch data{
            case .success(let res):
                    self?.city = res
                
                self?.cityTblV.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func addAddress(fullname:String,phone:String,province:String,city:String,city_code:String,address:String,addressType:String,localType:String,zipCode:String,addressLine_2:String,country:String){
        APIServices.addAddress(fullname: fullname, phone: phone, province: province, city: city, city_code: city_code, address: address, addressType: addressType, localType: localType, zipCode: zipCode, addressLine_2: addressLine_2, country: country){[weak self] data in
            switch data{
            case .success(let res):
                    self?.defaultAddress = res
                self?.defaultAdress(addressId: res.id ?? "", cartId: AppDefault.cartId ?? "")
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        }
    }
    
    private func updateAddress(addressId:String,fullname:String,phone:String,province:String,city:String,city_code:String,address:String,addressType:String,localType:String,zipCode:String,addressLine_2:String,country:String){
        APIServices.updateAddress(addressId:addressId,fullname: fullname, phone: phone, province: province, city: city, city_code: city_code, address: address, addressType: addressType, localType: localType, zipCode: zipCode, addressLine_2: addressLine_2, country: country){[weak self] data in
            switch data{
            case .success(let res):
                if self?.isComeOrder == true{
                    self?.defaultAddress = res
                }
            self?.defaultAdress(addressId: res.id ?? "", cartId: AppDefault.cartId ?? "")
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        }
    }
    
    private func defaultAdress(addressId:String,cartId:String){
        APIServices.defaultAdrress(addressId: addressId, cartId: cartId, completion: {[weak self] data in
            switch data{
            case .success(let res):
                print(res)
                AppDefault.currentUser?.defaultAddress = self?.defaultAddress
                self?.navigationController?.popViewController(animated: true)
                if(res == "OK"){
                    self?.view.makeToast("Set Default Address Successfully")
                }else{
                    self?.view.makeToast(res)
                }
                
             case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
    }

    
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        cityView.isHidden = true

    }
    @IBAction func cityBtnTapped(_ sender: Any) {
        cityView.isHidden = false
    }
    @IBAction func countryCrossbtntapped(_ sender: Any) {
        countryTableView.isHidden = true
        backgroundHandleView.isHidden = true

    }
    @IBAction func countryBtnTapped(_ sender: Any) {
        countryTableView.isHidden = false
        backgroundHandleView.isHidden = false
        backgroundHandleView.backgroundColor = UIColor.black
        backgroundHandleView.isOpaque = false
        backgroundHandleView.alpha = 0.5

    }
    @IBAction func pakistanBtnTapped(_ sender: Any) {
        countryView.isHidden = true
        pakistanRadioImg.image = UIImage(named: "selectedRadioBlue")
        internationalRadioImg.image = UIImage(named: "radioBlue")
        localType = "local"
        cityViewPakistan.isHidden = false
        cityViewInternational.isHidden = true
       
            scrollHeight.constant  = 650
         
            countryView.isHidden = true
            pakistanRadioImg.image = UIImage(named: "selectedRadioBlue")
            internationalRadioImg.image = UIImage(named: "radioBlue")
            cityViewPakistan.isHidden = false
            cityViewInternational.isHidden = true
            if cityy == "" {
                cityLbl.text = "selctcity".pLocalized(lang: LanguageManager.language)
            }else {
                cityLbl.text = cityy
            }
            mobileNumerHeadingLbl.text = "mobilenmber".pLocalized(lang: LanguageManager.language) // whatsappnmber
//            mobileNumerCodeLbl.text = "+92"
            mobileNumerCodeLbl.text = "+966"
     
    }
    @IBAction func internationalBtnTapped(_ sender: Any) {
        countryView.isHidden = false
        pakistanRadioImg.image = UIImage(named: "radioBlue")
        internationalRadioImg.image = UIImage(named: "selectedRadioBlue")
        localType = "international"
        cityViewPakistan.isHidden = true
        cityViewInternational.isHidden = false
    
            scrollHeight.constant = 750
           
            countryView.isHidden = false
            pakistanRadioImg.image = UIImage(named: "radioBlue")
            internationalRadioImg.image = UIImage(named: "selectedRadioBlue")
            cityViewPakistan.isHidden = true
            cityViewInternational.isHidden = false
            cityTF.text = cityy
            mobileNumerHeadingLbl.text = "whatsappnmber".pLocalized(lang: LanguageManager.language) // whatsappnmber
            mobileNumerCodeLbl.text = "+355"
        
    }
    
    @IBAction func homeBtnTapped(_ sender: Any) {
        homeBtn.borderColor = UIColor(hexString: "#0075E3")
        officeBtn.borderColor = UIColor.systemGray2
        addressType = "home"

    }
    
    @IBAction func officeBtnTapped(_ sender: Any) {
        homeBtn.borderColor = UIColor.systemGray2
        officeBtn.borderColor = UIColor(hexString: "#0075E3")
        addressType = "office"

    }
 
    @IBAction func saveAddressBtnTapped(_ sender: Any) {
        
        if(validate()) {
            if(isComeChange) {
                updateAddress(addressId: addressID,fullname: fullnameTF.text ?? "", phone: "\(mobileNumberTF.text ?? "")", province: "Punjab", city: cityy , city_code: "+966", address: address1TF.text ?? "", addressType: addressType, localType: localType, zipCode: zipCodeTF.text ?? "", addressLine_2: address2TF.text ?? "", country: countryLbl.text ?? "")
            }else {
                addAddress(fullname: fullnameTF.text ?? "", phone: "+966\(mobileNumberTF.text ?? "")", province: "Punjab", city: cityy , city_code: "+966", address: address1TF.text ?? "", addressType: addressType, localType: localType, zipCode: zipCodeTF.text ?? "", addressLine_2: address2TF.text ?? "", country: countryLbl.text ?? "")

            }

        } else {}
    }
}

extension AddAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == countryTblV {
            return countriesName.count
        }else {
            return cities.count

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == countryTblV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
            cell.countryImgLbl.font = UIFont.systemFont(ofSize: 40.0)

            cell.countryImgLbl.text = countriesFlag[indexPath.row]
            cell.countryNameLbl.text = countriesName[indexPath.row]
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
            let data = cities[indexPath.row]
            cell.textLabel?.text = data

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == countryTblV {
            let selectedCountry = countriesFlag[indexPath.row]
            let selectedCountryName = countriesName[indexPath.row]
            countryImg.text = selectedCountry
            countryLbl.text = selectedCountryName
            countryTableView.isHidden = true
            backgroundHandleView.isHidden = true

        }else {
            let selectedValue = cities[indexPath.row]
            cityName = selectedValue
            cityLbl.text = selectedValue
            cityy = selectedValue
            cityCode = selectedValue
            cityView.isHidden = true
        }
    }
    
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
}

extension AddAddressViewController: UITextFieldDelegate {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
   }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                    replacementString string: String) -> Bool {
        if textField == zipCodeTF {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= 6
        }else if textField == mobileNumberTF{
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= 10
        }else {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= 128
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == cityTF {
            cityy = cityTF.text ?? ""
        }
    }
}
