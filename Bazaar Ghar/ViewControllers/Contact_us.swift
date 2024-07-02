//
//  Contact_us.swift
//  Bazaar Ghar
//
//  Created by Developer on 22/09/2023.
//

import UIKit

class Contact_us: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var contactUsLbl: UILabel!
    @IBOutlet weak var callUsLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var projectBylbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.LanguageRender()
    }
    
    func LanguageRender() {
        
        contactUsLbl.text = "contactus".pLocalized(lang: LanguageManager.language)
        callUsLbl.text = "callus".pLocalized(lang: LanguageManager.language)
        projectBylbl.text = "projectby".pLocalized(lang: LanguageManager.language)

        
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }

    }

}
