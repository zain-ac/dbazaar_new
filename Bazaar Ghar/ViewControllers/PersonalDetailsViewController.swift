//
//  PersonalDetailsViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 26/09/2023.
//

import UIKit

class PersonalDetailsViewController: UIViewController {
    @IBOutlet weak var personalDetailslbl: UILabel!
    @IBOutlet weak var fullnamelbl: UILabel!
    @IBOutlet weak var fullnamefeildlbl: UITextField!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var emailfeildlbl: UITextField!
    @IBOutlet weak var savechnageslbl: UIButton!
    
    @IBOutlet weak var fullname: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    var fullName: String?
    var Email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        personalDetailslbl.text = "personaldetails".pLocalized(lang: LanguageManager.language)
        fullnamelbl.text = "fullname".pLocalized(lang: LanguageManager.language)
        fullnamefeildlbl.placeholder = "fullnamefeild".pLocalized(lang: LanguageManager.language)
        emaillbl.text = "email".pLocalized(lang: LanguageManager.language)
        emailfeildlbl.placeholder = "enteremail".pLocalized(lang: LanguageManager.language)
        savechnageslbl.setTitle("savechanges".pLocalized(lang: LanguageManager.language), for: .normal)
        
        fullname.text = fullName
        if Email == "Add Email" {
            email.text = ""
        }else {
            email.text = Email
        }
       
        
        // Do any additional setup after loading the view.
    }
    @IBAction func savechangesbtn(_ sender: Any) {
        savechanges(fullname: fullname.text ?? "", email: email.text ?? "", userid: AppDefault.currentUser?.id ?? "")
    }
    func savechanges(fullname: String,email:String,userid:String){
        APIServices.personaldetail(fullname: fullname, email: email, userid: userid, completion:{ [weak self] data in
            switch data{
            case .success(let res):
                AppDefault.currentUser = res
                self?.view.makeToast("Address Update successfully")
                
                self?.navigationController?.popViewController(animated: false)
            case .failure(let error):
                print(error)
                self?.view.makeToast(error)
            }
        })
     }

    
    
}
