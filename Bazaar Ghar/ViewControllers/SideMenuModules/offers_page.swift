//
//  offers_page.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 13/08/2024.
//

import UIKit

class offers_page: UIViewController {
    @IBOutlet weak var headerBackgroudView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Utility().setGradientBackground(view: headerBackgroudView, colors: ["#0EB1FB", "#0EB1FB", "#544AED"])

        // Do any additional setup after loading the view.
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
