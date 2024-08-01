//
//  VideoCommentViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 01/08/2024.
//

import UIKit

class VideoCommentViewController: UIViewController {
    @IBOutlet weak var commentTblV: UITableView!

    var commentArray = ["helooo","hdalsjdhkajlsdhkasjdhkasghdkasuhdkagisukdguaksdgkasugdkgkuagsdkuagsdkguaskudgaksdgukasgudkasugd","hi","wahat happend"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commentTblV.estimatedRowHeight = 50
          self.commentTblV.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.commentTblV.estimatedRowHeight = 50
          self.commentTblV.rowHeight = UITableView.automaticDimension
    }
    override func viewWillDisappear(_ animated: Bool) {
        let imageDataDict:[String: String] = ["val": "close"]
        NotificationCenter.default.post(name: Notification.Name("showviews"), object: nil,userInfo: imageDataDict)
    }


}

extension VideoCommentViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.commentTblV.dequeueReusableCell(withIdentifier: "VideoCommentTableViewCell") as! VideoCommentTableViewCell
        let data = commentArray[indexPath.row]
        cell.commentLbl.text = data
        return cell
    }
    
   
    
}
