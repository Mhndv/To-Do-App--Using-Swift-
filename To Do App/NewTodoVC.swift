//
//  NewTodoVC.swift
//  To Do App
//
//  Created by Mohanned Alsahaf on 16/01/1444 AH.
//

import UIKit

class NewTodoVC: UIViewController, UIAlertViewDelegate{
    var add = true
    var editedtodo:Todo?
    var editedTodoindex:Int?
    @IBOutlet weak var headdertodo: UINavigationItem!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var titleTextFeild: UITextField!
    
    @IBOutlet weak var todoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        if let todo = editedtodo {
            titleTextFeild.text = todo.title
            detailsTextView.text = todo.details
            todoImageView.image = todo.image
            
        }
        
        
    }
    
    
    @IBAction func ChangeButtonClicked(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
        
        
        
        
    }
    
    
    
    

    @IBAction func addButtonClicked(_ sender: Any) {
        
        if add == true {
            let addtodo = Todo(title: titleTextFeild.text!, image: todoImageView.image, details: detailsTextView.text)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil,userInfo: ["addedtodo":addtodo])
            
            
            
            let button2Alert: UIAlertController = UIAlertController(title: "Done", message: "Note Created Succesfully", preferredStyle: UIAlertController.Style.alert)
            let closeAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { actions in
                self.tabBarController?.selectedIndex = 0
                
                self.titleTextFeild.text = ""
                self.detailsTextView.text = ""
                self.todoImageView.image = nil
            })
            
            self.present(button2Alert, animated: true, completion: nil)
            button2Alert.addAction(closeAction)
          
         
            
        }
        else {// if the page open from edit note not for adding new note
            //edit the current note
   
            let editTodo = Todo(title: titleTextFeild.text!, image: todoImageView.image, details: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EditTodo"), object: nil,userInfo: ["editedTodo":editTodo,"editedTodoindex":editedTodoindex])
            
            let closebutton = UIAlertController(title: "Done", message: "Note Been Editted Succefully", preferredStyle: UIAlertController.Style.alert)
            let actionclose = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { action in
                self.navigationController?.popViewController(animated: true)
                
            }
            closebutton.addAction(actionclose)
            self.present(closebutton, animated: true)
            
            
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


extension NewTodoVC:UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
         dismiss(animated: true)
        todoImageView.image = image
        
        
        
    }
    
}
