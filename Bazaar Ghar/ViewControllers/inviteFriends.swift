//
//  inviteFriends.swift
//  Bazaar Ghar
//
//  Created by Developer on 22/09/2023.
//

import UIKit

class inviteFriends_Vc: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var inviteFriendsLbl: UILabel!
    @IBOutlet weak var inviteShareRefferalMsgLbl: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var inviteFriendsBtn: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.LanguageRender()
    }
    
    func LanguageRender() {
        
        inviteFriendsLbl.text = "invitefriends".pLocalized(lang: LanguageManager.language)
        inviteShareRefferalMsgLbl.text = "inviteShareRefferalMsg".pLocalized(lang: LanguageManager.language)
        copyBtn.setTitle("copy".pLocalized(lang: LanguageManager.language), for: .normal)
        inviteFriendsBtn.setTitle("invitefriends".pLocalized(lang: LanguageManager.language), for: .normal)

        
        if LanguageManager.language == "ar"{
            backBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
           }else{
               backBtn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
           }

    }


}
