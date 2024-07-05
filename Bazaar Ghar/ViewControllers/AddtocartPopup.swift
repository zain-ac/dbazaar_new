//
//  AddtocartPopup.swift
//  Bazaar Ghar
//
//  Created by Zany on 05/07/2024.
//

import UIKit

class AddtocartPopup: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func GotoCartBtn(_ sender: Any) {
        let vc = CartViewController
            .getVC(.main)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func continueShopping(_ sender: Any) {
        self.dismiss(animated: true)
        
    }
    /*
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
