//
//  ToDosVC.swift
//  To Do App
//
//  Created by Mohanned Alsahaf on 15/01/1444 AH.
//

import UIKit
import CoreData

class ToDosVC: UIViewController {
    var todosArray:[Todo] = [
       
    ]
    
    
    @IBOutlet weak var todosTableView: UITableView!
    override func viewDidLoad() {
        self.todosArray = retriveTodo()
        
        super.viewDidLoad()
        //---LEARNING TRY AND CATCH (ERROR HANDLING)
//        var m = Math()
//        do{
//       var result = try m.divide(num: 20, num2: 0)
//        }catch{//catch error
//            let alert = UIAlertController(title: "Error", message: "Can't divide by 0", preferredStyle: UIAlertController.Style.alert)
//            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
//            alert.addAction(alertAction)
//            present(alert, animated: true)
//        }//END OF LEARNING ERROR HANDLING
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded), name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil)//Add New Todo notification
        
        todosTableView.dataSource = self
        todosTableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEditted), name: NSNotification.Name(rawValue: "EditTodo"), object: nil)//EDit Todo Notification
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoDeleted), name: NSNotification.Name(rawValue: "DeleteTodo"), object: nil)//Delete Todo Notification
        
    }
    
    @objc func currentTodoEditted(notification:Notification){
        
        let currtodo = notification.userInfo?["editedTodo"] as? Todo
        
        if let currenttodo = currtodo{
            if let index = notification.userInfo?["editedTodoindex"] as? Int{

                todosArray[index] = currenttodo
                todosTableView.reloadData()
              updateTodo(todo: currenttodo, index: index)//احدث البيانات
            }
        }
    }
    
    @objc func currentTodoDeleted(notification:Notification){
        let indexdelete = notification.userInfo?["Deletedindex"] as? Int
        if let index = indexdelete{
        todosArray.remove(at: index)
            todosTableView.reloadData()
            DeleteTodo(index: index)
        }
       
    }
    
    
    @objc func newTodoAdded(notification: Notification){
        
        let todo = notification.userInfo?["addedtodo"] as? Todo
        if let mytodo = todo {
        todosArray.append(mytodo)
            todosTableView.reloadData()
            storeTodo(todo: mytodo)
        }
    }
    
    func storeTodo(todo:Todo){// to store data in the phone
    

        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return} //ذا يعني اذا م نجح بناءه ف يرجع
        
        let manageContext = appdelegate.persistentContainer.viewContext //create context
        
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todos", in: manageContext) else { return  }//هنا اقرله اسم الانتيتي و الكونتيكس
        
        let todoObject = NSManagedObject.init(entity: todoEntity, insertInto: manageContext)
        
        todoObject.setValue(todo.title, forKey: "title")//وش اللي ابي احفظه و وين في اي اتربيوت
        todoObject.setValue(todo.details, forKey: "details")
        if let image = todo.image {
            let imageData = image.pngData()
            todoObject.setValue(imageData, forKey: "image")
        }
        do{
       try manageContext.save()
            print("-------------success----------")
        }catch{
            print("-----------Error-------------")
        }
        
    }
    
    
    func retriveTodo() ->[Todo]{//اجيب البيانات المخزنه
        var todos:[Todo] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")//طلب دخخول ل قاعده البيانات
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for manageTodo in result {
                var title = manageTodo.value(forKey: "title") as? String//قاعد اخذ القيم من الداتابيس
                var details = manageTodo.value(forKey: "details") as? String
                var todoImage:UIImage? = nil
                if let imageFromContext = manageTodo.value(forKey: "image") as? Data{
                     todoImage = UIImage(data: imageFromContext)
                    
                  
                }
                let todo = Todo(title: title ?? "", image: todoImage, details: details ?? "")
                
                todos.append(todo)
            }
            print("=============Succes=======")
        }catch{
            print("========Error=======")
        }
        
        return todos
        
    }
    
    func updateTodo(todo:Todo,index:Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            result[index].setValue(todo.details, forKey: "details")
            result[index].setValue(todo.title, forKey: "title")
            if let image = todo.image {
                let imageData = image.pngData()
                result[index].setValue(imageData, forKey: "image")
            }
            
                try context.save()
            
            print("=============Succes=======")
        }catch{
            print("========Error=======")
        }
    }
    
    func DeleteTodo(index:Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
           
            let todoToDelete = result[index]//عشان احذف
            context.delete(todoToDelete)// هذا يحذف لي
                try context.save()
            
            print("=============Succes=======")
        }catch{
            print("========Error=======")
        }
    }
}




extension ToDosVC:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todosCell = tableView.dequeueReusableCell(withIdentifier: "Todocell") as! TodoCell
           
        todosCell.todoTitle.text = todosArray[indexPath.row].title
        
        
        if (todosArray[indexPath.row].image != nil){
        todosCell.todoImageView.image = todosArray[indexPath.row].image
        }
        else{
            todosCell.todoImageView.image = nil
        }
        todosCell.todoImageView.layer.cornerRadius = todosCell.todoImageView.frame.height/2
        todosCell.todoTitle.textColor = UIColor.white
        todosCell.backgroundColor = UIColor.black
        
        return todosCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let todos = todosArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailsVC") as? TodoDetailsVC

        if let detvc = vc {
            detvc.todo = todos
            detvc.index = indexPath.row
            navigationController?.pushViewController(detvc, animated: true)
        }
        
    }
}
