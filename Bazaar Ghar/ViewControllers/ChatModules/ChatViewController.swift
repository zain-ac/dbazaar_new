import UIKit
import SocketIO
import IQKeyboardManagerSwift
import SwiftyJSON
import Alamofire
import MobileCoreServices
import UniformTypeIdentifiers

class ChatViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ChatTblV: UITableView!
    @IBOutlet weak var messageTF: UITextView!
    @IBOutlet weak var attachmentBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var namestore: UILabel!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    var msgArray = [String]()
    var manager:SocketManager?
    var socket: SocketIOClient?
    var PuserMainArray: PuserMainModel? = nil
    
    var messages: PMsg? = nil
    
    var latestMessages: [Pusermessage]? = nil
    var recieverId = ""
    var roomId = ""
    var sellerDetail : SellerDetail?
    var newChat : Bool?
    var NCroomId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
       
        ChatTblV.register(UINib(nibName: "sendCell", bundle: nil), forCellReuseIdentifier: "sendCell")
        ChatTblV.register(UINib(nibName: "recevCell", bundle: nil), forCellReuseIdentifier: "recevCell")
        ChatTblV.register(UINib(nibName: "receiverImageCell", bundle: nil), forCellReuseIdentifier: "receiverImageCell")
        ChatTblV.register(UINib(nibName: "SenderimageCell", bundle: nil), forCellReuseIdentifier: "SenderimageCell")
        
        
        ChatTblV.estimatedRowHeight = 60
        ChatTblV.rowHeight = UITableView.automaticDimension
//        if newChat == true {
//            namestore.text = sellerDetail?.brandName ?? ""
//        }else {
            namestore.text = messages?.idarray?.brandName ?? ""
//        }
        messageTF.text = "Type something here..."
        if(latestMessages?.count ?? 0 > 0){
            self.ChatTblV.scrollToBottom()
        }
        self.connectSocket()
        messageTF.centerVertically()
        
        
    }
    
    @IBAction func sendbtnAction(_ sender: Any) {
       
        
//        if newChat == true {
//            let str =  messageTF.text ?? ""
//            let trimString = str.trimmingCharacters(in: .whitespaces)
//            if(trimString != "" && trimString != "Type something here..."){
//                var json = [String: Any]()
//                json["receiverId"] =   sellerDetail?.seller   // messages?.idarray?.sellerId ?? ""
//                json["roomId"] = NCroomId
//                json["message"] = messageTF.text ?? ""
//                json["senderId"] = AppDefault.currentUser?.id
//
//                self.messageTF.text  = "Type something here..."
//                self.messageTF.centerVertically()
//                socket?.emit("newChatMessage", json)
//
//                self.scrolltobottomTable()
//            }
//        }else {
            let str =  messageTF.text ?? ""
            let trimString = str.trimmingCharacters(in: .whitespaces)
            if(trimString != "" && trimString != "Type something here..."){
                var json = [String: Any]()
                json["receiverId"] = messages?.idarray?.sellerId ?? ""
                json["roomId"] = PuserMainArray?.roomId
                json["message"] = messageTF.text ?? ""
                json["senderId"] = AppDefault.currentUser?.id
                
                self.messageTF.text  = "Type something here..."
                self.messageTF.centerVertically()
                socket?.emit("newChatMessage", json)
                
                self.scrolltobottomTable()
                
            }
//        }
        
    }
        
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardObserver()

        
    }
    override func viewDidDisappear(_ animated: Bool) {
       
    }
    

    
    
    @IBAction func backbtn(_ sender: Any) {
        self.socket?.emit("leaveRoom", ["userId":AppDefault.currentUser?.id ?? ""])
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
      
    }
    func scrolltobottomTable(){
        
        
        self.socket?.on("newChatMessage") { datas, ack in
            if let rooms = datas[0] as? [String: Any]{
                
                let obj = Pusermessage(jsonData: JSON(rawValue: rooms)!)
                
                
                
                if self.latestMessages?.filter({$0.id == obj.id}).count ?? 0 > 0{
                    
                }else{
                    self.latestMessages?.append(obj)
                }
            
                
                
             
                self.view.endEditing(true)
                self.ChatTblV.reloadData()
                if(self.latestMessages?.count ?? 0 > 0){
                    self.ChatTblV.scrollToBottom()
                }
              
            }
        }
        
    }

    
    @IBAction func attachedMediaBtnTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
           imagePicker.sourceType = .photoLibrary
           imagePicker.delegate = self
           imagePicker.mediaTypes = [UTType.image.identifier, UTType.movie.identifier]
           present(imagePicker, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
                if mediaType == UTType.image.identifier {
                    if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                        // Do something with the selected image
                        UPLOD_PickSignature(token: AppDefault.accessToken, chatMedia: selectedImage, receiverId: self.recieverId, roomId: self.roomId, endpoint: "upload", type: "chatMedia", typeimg: "chatMedia", name: "chatMedia")
                    }
                } else if mediaType == UTType.movie.identifier {
                    if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                        // Handle the selected video URL
                        // For example, you can upload it or display it in a player
                        uploadVideo(token: AppDefault.accessToken, videoURL: videoURL, receiverId: self.recieverId, roomId: self.roomId, endpoint: "upload", name: "chatMedia")
                    }
                }
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
    
    func uploadVideo(token: String, videoURL: URL, receiverId: String, roomId: String, endpoint: String, name: String) {
        UIApplication.startActivityIndicator()

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Content-Type": "multipart/form-data"
        ]

        let url = AppConstants.API.baseURLChatNotification.absoluteString + endpoint

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                // Add video file
                do {
                    let videoData = try Data(contentsOf: videoURL)
                    multipartFormData.append(videoData, withName: name, fileName: "video.mp4", mimeType: "video/mp4")
                } catch {
                    print("Error converting video file to Data: \(error)")
                }
                
                // Add other parameters
                multipartFormData.append(receiverId.data(using: .utf8)!, withName: "receiverId")
                multipartFormData.append(roomId.data(using: .utf8)!, withName: "roomId")
        },
            to: url,
            method: .post,
            headers: headers,
            encodingCompletion: { result in
                switch result {
                case .success(let upload, _, _):
                    upload
                        .validate(statusCode: 200..<300)
                        .response { response in
                            if let error = response.error {
                                UIApplication.stopActivityIndicator()
                                // Handle error
                                self.view.makeToast(error.localizedDescription)
                            } else {
                                UIApplication.stopActivityIndicator()
                                // Upload successful, navigate to desired view controller
                                // let vc = Product_VC.getVC(.main)
                                // self.navigationController?.pushViewController(vc, animated: false)
                            }
                        }
                case .failure(let encodingError):
                    UIApplication.stopActivityIndicator()
                    // Handle encoding failure
                    print("Encoding error: \(encodingError.localizedDescription)")
                }
            }
        )
    }
    
    
    func UPLOD_PickSignature(token: String, chatMedia: UIImage, receiverId: String, roomId: String, endpoint: String, type: String, typeimg: String, name: String) {
        UIApplication.startActivityIndicator()

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Content-Type": "multipart/form-data"
        ]

        guard let imgData = chatMedia.jpegData(compressionQuality: 0.7) else {
            // Handle error if unable to convert image to data
            return
        }

        let url = AppConstants.API.baseURLChatNotification.absoluteString + endpoint

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                // Add image data
                multipartFormData.append(imgData, withName: name, fileName: typeimg, mimeType: "image/jpeg")
                
                // Add other parameters
                multipartFormData.append(receiverId.data(using: .utf8)!, withName: "receiverId")
                multipartFormData.append(roomId.data(using: .utf8)!, withName: "roomId")
        },
            to: url,
            method: .post,
            headers: headers,
            encodingCompletion: { result in
                switch result {
                case .success(let upload, _, _):
                    upload
                        .validate(statusCode: 200..<300)
                        .response { response in
                            if let error = response.error {
                                UIApplication.stopActivityIndicator()
                                // Handle error
                                self.view.makeToast(error.localizedDescription)
                            } else {
                                UIApplication.stopActivityIndicator()
                                // Upload successful, navigate to desired view controller
//                                let vc = Product_VC.getVC(.main)
//                                self.navigationController?.pushViewController(vc, animated: false)
                            }
                        }
                case .failure(let encodingError):
                    UIApplication.stopActivityIndicator()
                    // Handle encoding failure
                    print("Encoding error: \(encodingError.localizedDescription)")
                }
            }
        )
    }
    

}

extension ChatViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return latestMessages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = latestMessages?[indexPath.row]
        self.recieverId = data?.receiverId ?? ""
        self.roomId = data?.roomId ?? ""
        if(data?.receiverId == AppDefault.currentUser?.id){
            if(data?.multimedia == nil){
                let cell = tableView.dequeueReusableCell(withIdentifier: "recevCell", for: indexPath) as! recevCell
                cell.lbltext.text = data?.message
//                cell.lbltime.text = data?.date
                if let formattedDate = Utility().convertDateString(data?.date ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "MMMM dd, yyyy hh:mm a") {
                    print(formattedDate) // Output: April 18, 2024 05:24 AM
                    cell.lbltime.text = formattedDate
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "receiverImageCell", for: indexPath) as! receiverImageCell
                cell.days.text = data?.date
                cell.mainImage.pLoadImage(url: data?.multimedia  ?? "")
                return cell
            }
            
            
            
            
        }else{
            
            
            if(data?.multimedia == nil){
                let cell = tableView.dequeueReusableCell(withIdentifier: "sendCell", for: indexPath) as! sendCell
                cell.lbltext.text = data?.message
//                cell.lbltime.text = data?.date
                if let formattedDate = Utility().convertDateString(data?.date ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", toFormat: "MMMM dd, yyyy hh:mm a") {
                    print(formattedDate) // Output: April 18, 2024 05:24 AM
                    cell.lbltime.text = formattedDate
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderimageCell", for: indexPath) as! SenderimageCell
                cell.days.text = data?.date
                cell.mainImage.pLoadImage(url: data?.multimedia  ?? "")
                return cell
            }
            
           
        }
       
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = latestMessages?[indexPath.row]
        if(data?.multimedia == nil){
            return UITableView.automaticDimension
        }else{
            return 170
        }
        
    }
}


extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type, indexPath: IndexPath) -> T {
        self.register(UINib(nibName: String(describing: T.self), bundle: .main), forCellReuseIdentifier: String(describing: T.self))
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
        return cell
    }
    
   
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    func removeEmptyView() {
        self.backgroundView = nil
    }
    
  
}
extension ChatViewController{
    
    
    
    func connectSocket() {
        
        self.socket?.on("newChatMessage") { datas, ack in
            if let rooms = datas[0] as? [String: Any]{
                
                let obj = Pusermessage(jsonData: JSON(rawValue: rooms)!)
                
                
                
                if self.latestMessages?.filter({$0.id == obj.id}).count ?? 0 > 0{
                    
                }else{
                    self.latestMessages?.append(obj)
                }
            
                
                
             
                self.view.endEditing(true)
                self.ChatTblV.reloadData()
                self.ChatTblV.scrollToBottom()
            }
        }
    }
}
extension ChatViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
         
         
        }
     
     
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
          let count = textView.text.count + (text.count - range.length)
     
         return true
     }
     
     func textViewDidBeginEditing(_ textView: UITextView) {
         if textView.text == "Type something here..." {
             textView.text = ""
         }
     }
    
    private func textFieldDidEndEditing(_ textField: UITextField) {
      if textField.text == "" {
          textField.text = "Type something here..."
          sendBtn.isHidden = true
        }else {
            sendBtn.isHidden = false
        }
        
        msgArray.append(textField.text ?? "")
        

    }
    
    
    
    
    
     
    
}
extension ChatViewController{
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChange(notification:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        if keyboardSize.height > 200  && inputViewBottom.constant < 100{
            let window = UIApplication.shared.keyWindow
            
            UIView.animate(withDuration: 0.1) {
                
                if let win = window {
                    self.inputViewBottom.constant = self.inputViewBottom.constant + keyboardSize.height -  win.safeAreaInsets.bottom
                }
                self.view.layoutIfNeeded()
              
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        if keyboardSize.height > 200  && inputViewBottom.constant > 100 {
            
            UIView.animate(withDuration: 0.1) {
                self.inputViewBottom.constant = 10
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardFrameChange(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        if keyboardSize.height > 200  && inputViewBottom.constant > 100 {
            let window = UIApplication.shared.keyWindow
            
            UIView.animate(withDuration: 0.1) {
                
                if let win = window {
                    self.inputViewBottom.constant = 10 + keyboardSize.height -  win.safeAreaInsets.bottom
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
