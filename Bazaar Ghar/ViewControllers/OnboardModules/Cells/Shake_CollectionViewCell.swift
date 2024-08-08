//
//  Shake_CollectionViewCell.swift
//  Bazaar Ghar
//
//  Created by Umair Ali on 25/07/2024.
//

import UIKit

class Shake_CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bgimg: UIImageView!
    
    @IBOutlet weak var nextbtn: UIButton!
    @IBOutlet weak var descriptiontxt: UILabel!
    @IBOutlet weak var lbl_first: UILabel!
    @IBOutlet weak var shakeview: UIView!
    @IBOutlet weak var view1: UIView!
      @IBOutlet weak var view2: UIView!
      @IBOutlet weak var view3: UIView!
      
      func updateColors(forIndex index: Int) {
          if index == 0 {
              view1.backgroundColor = (UIColor(hex: "#0EB1FB"))
              view2.backgroundColor = .systemGray
              view3.backgroundColor = .systemGray
          } else if index == 1 {
              view1.backgroundColor = .systemGray
              view2.backgroundColor = (UIColor(hex: "#0EB1FB"))
              view3.backgroundColor = .systemGray
          } else {
              view1.backgroundColor = .systemGray
              view2.backgroundColor = .systemGray
              view3.backgroundColor = (UIColor(hex: "#0EB1FB"))
          }
      }
}
