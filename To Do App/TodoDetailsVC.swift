//
//  TodoDetailsVC.swift
//  To Do App
//
//  Created by Mohanned Alsahaf on 15/01/1444 AH.
//

import UIKit

class TodoDetailsVC: UIViewController {
 
    var index:Int?
    var todo:Todo!
    @IBOutlet weak var tododetailsdesc: UILabel!
    @IBOutlet weak var tododetalstitle: UILabel!
    @IBOutlet weak var tododetailsimageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tododetalstitle.text = todo.title
        tododetailsdesc.text = todo.details
        tododetailsimageview.image = todo.image
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEditted), name: NSNotification.Name(rawValue: "EditTodo"), object: nil)
        
    }
    @objc func currentTodoEditted(notification:Notification){
        if let currenttodo = notification.userInfo?["editedTodo"] as? Todo{
            self.todo = currenttodo
            tododetalstitle.text = todo.title
            tododetailsdesc.text = todo.details
            tododetailsimageview.image = todo.image
        }
    }

    @IBAction func editButtonClicked(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "newtodovc") as? NewTodoVC
        
        if let editvc = vc {
            editvc.editedtodo = todo
            editvc.editedTodoindex = index!
            editvc.headdertodo.title = "Edit Note"
            editvc.add = false
            navigationController?.pushViewController(editvc, animated: true)
           
        }
        
    }
    
    
    
    @IBAction func DeleteTodoButton(_ sender: Any) {
       
        let checkalert = UIAlertController(title: "Done", message: "Note has been deleted succefully", preferredStyle: UIAlertController.Style.alert)
           
       
        
        let closebutton = UIAlertController(title: "ALERT", message: "Are you sure ?", preferredStyle: UIAlertController.Style.alert)
        let actionback = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel,handler: nil )
        
        let actionsure = UIAlertAction(title: "Sure", style: UIAlertAction.Style.destructive) { action in
         
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeleteTodo"), object: nil, userInfo: ["Deletedindex" : self.index])
            let approveaction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { delete in
                self.navigationController?.popViewController(animated: true)
            }
            checkalert.addAction(approveaction)
            self.present(checkalert, animated: true)
         
            
        }
        
        closebutton.addAction(actionsure)
        closebutton.addAction(actionback)
     
        self.present(closebutton, animated: true)
        
    }
    
}
