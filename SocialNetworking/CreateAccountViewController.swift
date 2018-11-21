//
//  CreateAccountViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/20/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import DatePicker

class CreateAccountViewController: MRKBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profilePicImgView: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    
    let textFieldArr = ["Display Name", "Name", "Email", "Password", "Phone Number", "Language", "Address", "City", "State", "Country", "Zipcode"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textFieldArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == textFieldArr.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "birthDateCell")!
            cell.tag = indexPath.row
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! TextFieldTableViewCell
            cell.tag = indexPath.row
            cell.textField.tag = indexPath.row + 100
            cell.textField.placeholder = textFieldArr[indexPath.row]
            return cell
        }
    }
    
    @IBAction func selectImg(_ sender: UIButton) {
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        //TODO: check for valid input
        let disNamecell = self.view.viewWithTag(100) as! UITextField
        let namecell = self.view.viewWithTag(101) as! UITextField
        let emailcell = self.view.viewWithTag(102) as! UITextField
        let pwdcell = self.view.viewWithTag(103) as! UITextField
        let pncell = self.view.viewWithTag(104) as! UITextField
        let lancell = self.view.viewWithTag(105) as! UITextField
        let addcell = self.view.viewWithTag(106) as! UITextField
        let citycell = self.view.viewWithTag(107) as! UITextField
        let statecell = self.view.viewWithTag(108) as! UITextField
        let countrycell = self.view.viewWithTag(109) as! UITextField
        let zipcell = self.view.viewWithTag(110) as! UITextField
        
        
        FirebaseHandler.shared.signUp(email: emailcell.text!, pwd: pwdcell.text!, name: namecell.text!, birthdate: "10/10/1993", address: addcell.text!, displayName: disNamecell.text!, phoneNum: pncell.text!, language: lancell.text!, city: citycell.text!, state: statecell.text!, zipcode: zipcell.text!, country: countrycell.text!){
            (err) in
            if err == nil{
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
