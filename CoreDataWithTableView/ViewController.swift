//
//  ViewController.swift
//  CoreDataWithTableView
//
//  Created by Nikunj Prajapati on 22/12/19.
//  Copyright © 2019 Nikunj Prajapati. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //variable and contants
    var name:[NSManagedObject] = []
    
    var people:[NSManagedObject] = []
    
    var managedObj:NSManagedObject!
    var manageContext:NSManagedObjectContext!
    
    var managedObjList:[NSManagedObject]!
    
  
   
    
    var manage2Context:NSManagedObjectContext!
    
  
    @IBOutlet weak var tableView: UITableView!
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MyTableViewCell
        cell?.namelbl.text = person.value(forKey: "name") as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle==UITableViewCell.EditingStyle.delete
        {
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
            context.delete(self.people[indexPath.row])
            
            do
            {
                try context.save()
                self.people.removeAll()
                self.ReadData()
                self.tableView.reloadData()
            }
            catch
            {
              print("error")
            }
            
        }
        else{
            print("Something wrong")
        }
             
    }
    
    func ReadData()
    {
        self.managedObjList = [NSManagedObject]()
        
        let fetchReq = NSFetchRequest<NSManagedObject>.init(entityName: "Person")
        
        do
        {
            self.managedObjList = try self.manageContext.fetch(fetchReq)
            self.viewWillAppear(true)
        }
        catch let err as NSError
        {
            print(err.localizedDescription)
        }
    }
   
    @IBAction func addButton(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "New Name", message: "Add a name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            [unowned self] action in
            guard let textName = alert.textFields?.first,
                let nameTosolve = textName.text
                else{return}
            self.save(name: nameTosolve)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    func save(name: String)
    {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate
            else
            {
                return
            }
        let manageContext = appdelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: manageContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: manageContext)
        
        person.setValue(name, forKey: "name")
        
        do
        {
            try manageContext.save()
            people.append(person)
            print("Data successfully saved")
        }
        catch let error as NSError
        {
            print("Failed to Save the Data \(error),\(error.userInfo)")
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.manageContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        ReadData()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        //these steps are to show the as usual data which we are added
        //step 1
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        let manageContext = appdelegate.persistentContainer.viewContext
        
        //step 2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //step 3
        do
        {
            people = try manageContext.fetch(fetchRequest)
        }
        catch let error as NSError
        {
            print("Data is not Saved \(error),\(error.userInfo)")
        }
    }
}

