//
//  Term&Conditions.swift
//  Bazaar Ghar
//
//  Created by Developer on 20/09/2023.
//

import UIKit

class TermConditions: UIViewController {
    @IBOutlet weak var termsconditiontable: UITableView!
    @IBOutlet weak var headerLbl: UILabel!

  var header = [String]()
  var faqsheader = [String]()
    var txt = [String]()
    var faqstxt = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
       
        if((self.tabBarController?.tabBar.isHidden) != nil){
            appDelegate.isbutton = true
        }else{
            appDelegate.isbutton = false
        }
        NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        
        faqsheader = ["How can I login/sign up inot MYSouq?","Can I login into MYSouq from multiple devices?","What should I do if in case I don‘t get the OTP or verification code when signing up?","What is MYSouq Customer Support helpline number?","MYSouq App not working. What should I do?","There are brands on Bazaar Ghar website. Are they authentic and have genuine products?","Why am I seeing different prices for the same product?","How much delivery cost I’ve to pay on my packages?","What is average delivery timeline?","Do you ship internationally?","What payment options are available at MYSouq?","How to place an order on MYSouq?","Can I place an order via WhatsApp?","How to add or remove items in the cart?","How would I know if my order has been confirmed?","How to check the status of my order?","I ordered multiple items but I have received only one item so far. What needs to be done?","How can I return a product?","Can I cancel my order?"]
        
        
        faqstxt = ["You can login or sign up using your phone number here (link). Click on “Send Code”, you will receive an OTP code from MYSouq on SMS. Enter that code and click on “Verify”.\r\n","Yes, you can login from multiple devices.\r\n","If in case you are facing issue in getting the OTP or verification code while signing in, You can sign up and login via email or contact our customer support team (0301-1166879).\r\n","Customer Support Helpline: 0301-1166879 \r\nWorking hours: 9am to 9pm \r\n","Please follow these steps: \r\n1.Go to Settings.\r\n2.Go to Apps Management.\r\n3.Look for “MYSouq” app.\r\n4.Go to storage.\r\n5.Clean Cache.\r\n6.Open app again.\r\n","Yes, all of them are genuine. And if there is any replica on the website, the seller is responsible to clearly mentioned it in description.\r\n","We have many sellers working with us, it is possible that they are selling same product with different prices, you can order depending upon the quality of product and product reviews.\r\n","Delivery charges depends on the package weight, volume and depending upon the destination.\r\n","The average delivery time within Pakistan is 3-4 working days.\r\n","Yes, we do. We have a range of international customers and we deliver them our quality products. If you are an international buyer, please drop a WhatsApp message on 00923011166879, and our team will contact you. \r\nNote: “Order via WhatsaApp” option is available with every product.\r\n","Currently, we are offering the COD (Cash on Delivery) only. International buyers have to pay in advance.\r\n","Login with your phone number or email. \r\nClick on “Add to cart” button. \r\nGo to “cart” page by clicking on button. \r\nClick on “Proceed to checkout”. \r\nAdd your address by clicking on “Add New Address” button. \r\nAfter adding address, click on “Continue to shipping”. \r\nSelect your payment method and click on “Checkout”. \r\nSelect your payment method and click on “Checkout”. \r\nNote: International buyers have to order via WhatsApp (0092 301 1166879).\r\n","Yes, you can place an order via WhatsApp on 0301-1166879. Note: International buyers have to order via WhatsApp 00923011166879.\r\n","To add a product in cart, click on “Add to cart” button.\r\nTo remove item from cart, click on cart icon then click on cross icon (x) to remove product.\r\n", "Our fulfillment department will call you within few hours after order placement to confirm your order.\r\n","You can check status of your order by calling our customer support helpline (0301-1166879)\r\n", "Items bought from different sellers are often shipped separately to ensure no delay in the fulfillment of your order.\r\n","MYSouq aims to provide an excellent customer commitment and customer experience. So, if you are not happy with any product, you have 6-days’ time to return that product. The amount of your product will be transferred to your bank account as soon as you handover the product for return.\r\nNote: Customers must not have to use that product.\r\nPlease contact helpline: 0301-1166879\r\n","Customer may cancel the order before it has been shipped to it.\r\nIf the Customer cancels the order before the status of “It’s Shipped”, any such shipment and liability associated with the same shall remain the sellers responsibility to pay the shipping charges.\r\nCustomer can refund where the Customer has pre-paid for the Product and he/she cancels the order before it has been shipped.\r\nCustomer can reject / return the order because of the following reasons:\r\n• If the product is broken or damaged.\r\n• If the product is not what the customer has ordered.\r\n• The Customer changes his/her mind or no longer needs the product [applicable for certain categories only (subject to confirmation from seller)]\r\n• If there is a mistake by customer e.g customer wants to order a single piece but accidently ordered 4 to 5 pieces. (Depends on sellers, if they allow or not).\r\n•The product includes the original tags, user manual, warranty cards, freebies and accessories.\r\nNote: Customized & Electronic products are not return / refundable until or unless the product is broken or damaged or product is not what the customer has ordered. In such cases customer must have to contact customer support helpline and customer must not have to use the product.\r\n"]
      
        
        header = ["Welcome to MYSouq.com!","Cookies","License","Hyperlinking to our Content","iFrames","Content Liability","Your Privacy","Reservation of Rights","Removal of links from our website","Disclaimer"]
        
        txt = ["These terms and conditions outline the rules and regulations for the use of Bazaar Ghar's Website, located at https://MYSouq.com \r\n\r\nBy accessing this website we assume you accept these terms and conditions. Do not continue to use MYSouq.com if you do not agree to take all of the terms and conditions stated on this page.\r\n\r\nThe following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: \"Client\", \"You\" and \"Your\" refers to you, the person log on this website and compliant to the Company’s terms and conditions. \"The Company\", \"Ourselves\", \"We\", \"Our\" and \"Us\", refers to our Company. \"Party\", \"Parties\", or \"Us\", refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same. \r\n",
               
               "We employ the use of cookies. By accessing MYSouq.com, you agreed to use cookies in agreement with the Bazaar Ghar&aposs Privacy Policy.Most interactive websites use cookies to let us retrieve the user’s details for each visit. Cookies are used by our website to enable the functionality of certain areas to make it easier for people visiting our website. Some of our affiliate/advertising partners may also use cookies.\r\n",
               
               
               "Unless otherwise stated, Bazaar Ghar and/or its licensors own the intellectual property rights for all material on MYSouq.com. All intellectual property rights are reserved. You may access this from MYSouq.com for your own personal use subjected to restrictions set in these terms and conditions. \r\n\r\nYou must not: \r\n• Republish material from MYSouq.com. \r\n• Sell, rent or sub-license material from MYSouq.com  \r\n• Reproduce, duplicate or copy material from MYSouq.com \r\n• Redistribute content from MYSouq.com \r\nThis information is taken from the sellers only to verify them. \r\n \r\n Parts of this website offer an opportunity for users to post and exchange opinions and information in certain areas of the website. Bazaar Ghar does not filter, edit, publish or review Comments prior to their presence on the website. Comments do not reflect the views and opinions of Bazaar Ghar,its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, Bazaar Ghar shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website. Bazaar Ghar reserves the right to monitor all Comments and to remove any Comments which can be considered inappropriate, offensive or causes breach of these Terms and Conditions.\r\n \r\nYou warrant and represent that: \r\n• You are entitled to post the Comments on our website and have all necessary licenses and consents to do so \r\n• The Comments do not invade any intellectual property right, including without limitation copyright, patent or trademark of any third party \r\n• The Comments do not contain any defamatory, libelous, offensive, indecent or otherwise unlawful material which is an invasion of privacy \r\n• The Comments will not be used to solicit or promote business or custom or present commercial activities or unlawful activity. \r\n \r\nYou hereby grant Bazaar Ghar a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats or media. \r\n","The following organizations may link to our Website without prior written approval:\r\n • Government agencies \r\n • Search engines\r\n • News organizations \r\n • Online directory distributors may link to our Website in the same manner as they hyperlink to the Websites of other listed businesses\r\n • System wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site.\r\n These organizations may link to our home page, to publications or to other Website information so long as the link:\r\n(a) is not in any way deceptive\r\n(b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products and/or services\r\n(c) fits within the context of the linking party’s site.\r\n \r\nWe may consider and approve other link requests from the following types of organizations:\r\n• commonly-known consumer and/or business information sources\r\n• dot.com community sites\r\n• associations or other groups representing charities\r\n• online directory distributors\r\n• internet portals\r\n• accounting, law and consulting firms\r\n• andeducational institutions and trade associations.\r\n\r\n We will approve link requests from these organizations if we decide that:\r\n(a) the link would not make us look unfavorably to ourselves or to our accredited businesses\r\n(b) the organization does not have any negative records with us\r\n(c) the benefit to us from the visibility of the hyperlink compensates the absence of Bazaar Ghar\r\n(d) the link is in the context of general resource information.\r\n\r\nThese organizations may link to our home page so long as the link:\r\n(a) is not in any way deceptive\r\n(b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products or services \r\n(c) fits within the context of the linking party’s site.\r\n\r\n If you are one of the organizations listed in paragraph 2 above and are interested in linking to our website, you must inform us by sending an e-mail to Bazaar Ghar. Please include your name, your organization name, contact information as well as the URL of your site, a list of any URLs from which you intend to link to our Website, and a list of the URLs on our site to which you would like to link. Wait 2-3 weeks for a response.\r\n Approved organizations may hyperlink to our Website as follows:\r\n• By use of our corporate name\r\n• By use of the uniform resource locator being linked to\r\n• By use of any other description of our Website being linked to that makes sense within the context and format of content on the linking party’s site.\r\n\r\nNo use of Bazaar Ghar's logo or other artwork will be allowed for linking absent a trademark license agreement.\r\n","Without prior approval and written permission, you may not create frames around our Webpages that alter in any way the visual presentation or appearance of our Website.\r\n","We shall not be hold responsible for any content that appears on your Website. You agree to protect and defend us against all claims that is rising on your Website. No link(s) should appear on any Website that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.\r\n","Please read Privacy Policy.\r\n","We reserve the right to request that you remove all links or any particular link to our Website. You approve to immediately remove all links to our Website upon request. We also reserve the right to amen these terms and conditions and it’s linking policy at any time. By continuously linking to our Website, you agree to be bound to and follow these linking terms and conditions.\r\n","If you find any link on our Website that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you\r\ndirectly.\r\nWe do not ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the website remains available or that the material on the website is kept up to date.\r\n","To the maximum extent permitted by applicable law\r\n\r\nwe exclude all representations, warranties and conditions relating to our website and the use of this website. Nothing in this disclaimer will:\r\n• limit exclude our or your liability for death or personal injury; limit or exclude our or your liability for fraud or fraudulent misrepresentation\r\n• limit any of our or your liabilities in any way that is not permitted under applicable law\r\n•exclude any of our or your liabilities that may not be excluded under applicable law. The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer:\r\n(a) are subject to the preceding paragraph;\r\n(b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort and for breach of statutory duty. As long as the website and the information and services on the website are provided free of charge, we will not be liable for any loss or damage of any nature.\r\n",
               "The following organizations may link to our Website without prior written approval:\r\n • Government agencies \r\n • Search engines\r\n • News organizations \r\n • Online directory distributors may link to our Website in the same manner as they hyperlink to the Websites of other listed businesses\r\n • System wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site.\r\n These organizations may link to our home page, to publications or to other Website information so long as the link:\r\n(a) is not in any way deceptive\r\n(b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products and/or services\r\n(c) fits within the context of the linking party’s site.\r\n \r\nWe may consider and approve other link requests from the following types of organizations:\r\n• commonly-known consumer and/or business information sources\r\n• dot.com community sites\r\n• associations or other groups representing charities\r\n• online directory distributors\r\n• internet portals\r\n• accounting, law and consulting firms\r\n• andeducational institutions and trade associations.\r\n\r\n We will approve link requests from these organizations if we decide that:\r\n(a) the link would not make us look unfavorably to ourselves or to our accredited businesses\r\n(b) the organization does not have any negative records with us\r\n(c) the benefit to us from the visibility of the hyperlink compensates the absence of Bazaar Ghar\r\n(d) the link is in the context of general resource information.\r\n\r\nThese organizations may link to our home page so long as the link:\r\n(a) is not in any way deceptive\r\n(b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products or services \r\n(c) fits within the context of the linking party’s site.\r\n\r\n If you are one of the organizations listed in paragraph 2 above and are interested in linking to our website, you must inform us by sending an e-mail to Bazaar Ghar. Please include your name, your organization name, contact information as well as the URL of your site, a list of any URLs from which you intend to link to our Website, and a list of the URLs on our site to which you would like to link. Wait 2-3 weeks for a response.\r\n Approved organizations may hyperlink to our Website as follows:\r\n• By use of our corporate name\r\n• By use of the uniform resource locator being linked to\r\n• By use of any other description of our Website being linked to that makes sense within the context and format of content on the linking party’s site.\r\n\r\nNo use of Bazaar Ghar's logo or other artwork will be allowed for linking absent a trademark license agreement.\r\n","Without prior approval and written permission, you may not create frames around our Webpages that alter in any way the visual presentation or appearance of our Website.\r\n","We shall not be hold responsible for any content that appears on your Website. You agree to protect and defend us against all claims that is rising on your Website. No link(s) should appear on any Website that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.\r\n","Please read Privacy Policy.\r\n","We reserve the right to request that you remove all links or any particular link to our Website. You approve to immediately remove all links to our Website upon request. We also reserve the right to amen these terms and conditions and it’s linking policy at any time. By continuously linking to our Website, you agree to be bound to and follow these linking terms and conditions.\r\n","If you find any link on our Website that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you\r\ndirectly.\r\nWe do not ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the website remains available or that the material on the website is kept up to date.\r\n","To the maximum extent permitted by applicable law\r\n\r\nwe exclude all representations, warranties and conditions relating to our website and the use of this website. Nothing in this disclaimer will:\r\n• limit exclude our or your liability for death or personal injury; limit or exclude our or your liability for fraud or fraudulent misrepresentation\r\n• limit any of our or your liabilities in any way that is not permitted under applicable law\r\n•exclude any of our or your liabilities that may not be excluded under applicable law. The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer:\r\n(a) are subject to the preceding paragraph;\r\n(b) govern all liabilities arising under the disclaimer,\r\n including liabilities arising in contract, in tort and for breach of statutory duty. As long as the website and the information and services on the website are provided free of charge, we will not be liable for any loss or damage of any nature."]
        self.termsconditiontable.estimatedRowHeight = 80
        self.termsconditiontable.rowHeight = UITableView.automaticDimension
        
        termsconditiontable.dataSource = self
        termsconditiontable.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(AppDefault.iscomefaqs){
            headerLbl.text = "FAQs"
        }else {
            headerLbl.text = "Terms and Conditions"
        }
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        appDelegate.isbutton = false
    NotificationCenter.default.post(name: Notification.Name("ishideen"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }

}
extension TermConditions:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(AppDefault.iscomefaqs){
            return faqsheader.count
        }else{
            return header.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "termsAndcondition_CELL", for: indexPath) as! termsAndcondition_CELL
        if(AppDefault.iscomefaqs){
            cell.header.text =  faqsheader[indexPath.row]
            cell.txt.text =  faqstxt[indexPath.row]
        }else{
            cell.header.text =  header [indexPath.row]
            cell.txt.text =  txt[indexPath.row]
        }
        

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
