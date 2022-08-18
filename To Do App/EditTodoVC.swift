//
//  EditTodoVC.swift
//  To Do App
//
//  Created by Mohanned Alsahaf on 16/01/1444 AH.
//

import UIKit

class EditTodoVC: UIViewController {

    @IBOutlet weak var editdetailsTextView: UITextView!
    @IBOutlet weak var edittodoTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func SaveEditTodoButton(_ sender: Any) {
        edittodoTextfield.text = ""
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailsVC")
        if let editvc = vc {
            navigationController?.pushViewController(editvc, animated: true)
        }
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
