//
//  MainVC.swift
//  blur_View
//
//  Created by Abdusamad Mamasoliyev on 01/05/23.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks: [Task] = [
        Task(title: "Choyxonaga borish", description: "Sinfdoshlar bilan suhbat qilish", color: "FF0000"),
    ]
    
    
    var finishadTasks: [Task] = []
    var archivedTasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavBar()
        
        saveData(array: archivedTasks, nom: "archivedTasks")
       
        archivedTasks = getData(nom: "archivedTasks")
        finishadTasks = getData(nom: "finishadTasks")
        tasks = getData(nom: "tasks")
        
        tasks = getData(nom: "tasks")
        finishadTasks = getData(nom: "finishadTasks")
        archivedTasks = getData(nom: "archivedTasks")
    }
    
    func saveData(array: [Task], nom: String) {
       
        
        let encoder = JSONEncoder()
       
        if let encodedData = try? encoder.encode(array) {
            
            UserDefaults.standard.set(encodedData, forKey: nom)
            
        }
        
    }
    func getData( nom: String ) ->  [Task] {
        
        let decoder = JSONDecoder()
        
        if let userData = UserDefaults.standard.data(forKey: nom) {
            
            if let decodedData = try? decoder.decode([Task].self, from: userData) {
              return decodedData
            }
        }
        return []
    }
    
        
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MainVCCell", bundle: nil), forCellReuseIdentifier: "MainVCCell")
    }
    
    func setupNavBar() {
        
        navigationItem.title = "My To-Do List"

        // custom korinish yasab olish
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        
        // rang berish
        navigationBarAppearance.backgroundColor = .systemGreen
        // titleni sozlash
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]
        
        // yasab olingan korinishni hozirgi navigation ga berish
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        
        //
    }
    
    @IBAction func blurBtn(_ sender: UIButton) {
        
        
         
        let vc = AddTextVC(nibName: "AddTextVC", bundle: nil)
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        vc.closure = { task in
            self.tasks.append(task)
              
            self.tableView.reloadData()
            
            self.saveData(array: self.tasks, nom: "tasks")
        }
        
        self.present(vc, animated: true)
        
    }
    
    // MARK: UIcolor to Hex Color
    
    func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
     }

    func colorWithHexString(hexString: String) -> UIColor {
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()

        print(colorString)
        let alpha: CGFloat = 1.0
        let red: CGFloat = self.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = self.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        let blue: CGFloat = self.colorComponentFrom(colorString: colorString, start: 4, length: 2)

        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }

    func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {

        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt32 = 0

        guard Scanner(string: String(fullHexString)).scanHexInt32(&hexComponent) else {
            return 0
        }
        let hexFloat: CGFloat = CGFloat(hexComponent)
        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
        print(floatValue)
        return floatValue
    }
    
    
}
extension MainVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return tasks.count
        case 1:
            return finishadTasks.count
        default:
            return archivedTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainVCCell") as! MainVCCell
            
            cell.titleLbl.text = tasks[indexPath.row].title
            cell.desLbl.text = tasks [indexPath.row].description
            cell.cellColor.backgroundColor = colorWithHexString(hexString: tasks[indexPath.row].color)
            cell.containerView.backgroundColor = UIColor.systemGray6
            
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainVCCell") as! MainVCCell
            
            cell.titleLbl.text = finishadTasks[indexPath.row].title
            cell.desLbl.text = finishadTasks[indexPath.row].description
            cell.cellColor.backgroundColor = colorWithHexString(hexString: finishadTasks[indexPath.row].color)
            cell.containerView.backgroundColor = UIColor.systemGray5
            
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainVCCell") as! MainVCCell
            
            cell.titleLbl.text = archivedTasks[indexPath.row].title
            cell.desLbl.text = archivedTasks[indexPath.row].description
            cell.cellColor.backgroundColor = colorWithHexString(hexString: archivedTasks[indexPath.row].color)
            cell.containerView.backgroundColor = UIColor.systemGray4
            
            cell.selectionStyle = .none
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
        
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        UIContextMenuConfiguration(identifier: nil,
                                   previewProvider: nil) { _ in
            
            
            let delete = UIAction(title: "O'chirish",image: UIImage(systemName: "trash")?.withTintColor(.red , renderingMode: .alwaysOriginal)) { _ in
                print("delete")
                
                self.tasks.remove(at: indexPath.row)
                self.tableView.reloadData()
                
                self.saveData(array: self.tasks , nom: "tasks")
            }
            
            let finish = UIAction(title: "Finish task", image: UIImage(systemName: "checkmark.circle")?.withTintColor(.green, renderingMode: .alwaysOriginal)) { [self] _ in
                
                finishadTasks.append(tasks[indexPath.row])
                tasks.remove(at: indexPath.row)
                
                saveData(array: tasks , nom: "tasks")
                saveData(array: finishadTasks , nom: "finishadTasks")
                
                tableView.reloadData()
            }
            return UIMenu(children: [finish, delete])
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let deleteAction = UIContextualAction(style: .normal, title: "O'chirish") { _,_,_ in
            
            switch indexPath.section {
            case 0:
                self.tasks.remove(at: indexPath.row)
            case 1:
                self.finishadTasks.remove(at: indexPath.row)
            default:
                self.archivedTasks.remove(at: indexPath.row)
            }
            self.tableView.reloadData()
            
        }
        
        deleteAction.backgroundColor = UIColor.red
        
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipe
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let label = UILabel(frame: CGRect(x: (tableView.frame.width / 2) - 95,
                                          y: 10,
                                          width: 190,
                                          height: 40))
        label.textAlignment = .center
        label.textColor = .systemGreen
        
        label.backgroundColor = .systemGray5
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 20)
        
        switch section {
        case 0:
            label.text = "New Tasks"
        case 1:
            label.text = "Finished Tasks"
        default:
            label.text = "Archived Tasks"
        }
        
        let view = UIView()
        view.addSubview(label)
        
        switch section {
        case 0:
            if tasks.count == 0 {
                return nil
            }
        case 1:
            if finishadTasks.count == 0 {
                return nil
            }
        default:
            if archivedTasks.count == 0 {
                return nil
            }
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            if tasks.count == 0 {
                return 0.000000000001
            }
        case 1:
            if finishadTasks.count == 0 {
                return 0.000000000001
            }
        default:
            if archivedTasks.count == 0 {
                return 0.000000000001
            }
        }
        
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            let alert = UIAlertController(title: "New Taskdagi taskni ozgartirish", message: nil, preferredStyle: .actionSheet)
            
            let finish = UIAlertAction(title: "Finish", style: .default) { [self] _ in
                
                let finished = tasks.remove(at: indexPath.row)
                finishadTasks.append(finished)
                
                tableView.reloadData()
                
                self.saveData(array: self.finishadTasks, nom: "finishadTasks")
                
            }
            
            let archive = UIAlertAction(title: "Archive", style: .default) { [self] _ in
                
                let archived = tasks.remove(at: indexPath.row)
                archivedTasks.append(archived)
                
                tableView.reloadData()
                
                self.saveData(array: self.archivedTasks, nom: "archivedTasks")
            }
            
            let delete = UIAlertAction(title: "Delete", style: .destructive) { [self] _ in
                
                tasks.remove(at: indexPath.row)
                
                tableView.reloadData()
                
                self.saveData(array: tasks, nom: "tasks")
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(finish)
            alert.addAction(archive)
            alert.addAction(delete)
            alert.addAction(cancel)
            
            present(alert, animated: true)
        case 1:
            let alert = UIAlertController(title: "Finished Taskdagi taskni ozgartirish", message: nil, preferredStyle: .actionSheet)
            
            let finish = UIAlertAction(title: "Unfinish", style: .default) { [self] _ in
                
                let finished = finishadTasks.remove(at: indexPath.row)
                tasks.append(finished)
                
                tableView.reloadData()
                self.saveData(array: tasks , nom: "tasks")
            }
            
            let archive = UIAlertAction(title: "Archive", style: .default) { [self] _ in
                
                let archived = finishadTasks.remove(at: indexPath.row)
                archivedTasks.append(archived)
                
                tableView.reloadData()
                
                self.saveData(array: archivedTasks , nom: "archivedTasks")
            }
            
            let delete = UIAlertAction(title: "Delete", style: .destructive) { [self] _ in
                
                finishadTasks.remove(at: indexPath.row)
                saveData(array: finishadTasks, nom: "finishadTasks")
                tableView.reloadData()
                
                self.saveData(array: finishadTasks , nom: "finishadTasks")
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(finish)
            alert.addAction(archive)
            alert.addAction(delete)
            alert.addAction(cancel)
            
            present(alert, animated: true)
        default:
            let alert = UIAlertController(title: "Archived Taskdagi taskni ozgartirish", message: nil, preferredStyle: .actionSheet)
            
            let archive = UIAlertAction(title: "Unarchive", style: .default) { [self] _ in
                
                let archived = archivedTasks.remove(at: indexPath.row)
                tasks.append(archived)
                
                tableView.reloadData()
                
                self.saveData(array: tasks , nom: "tasks")
            }
            
            let delete = UIAlertAction(title: "Delete", style: .destructive) { [self] _ in
                
                archivedTasks.remove(at: indexPath.row)
                
                tableView.reloadData()
                self.saveData(array: archivedTasks , nom: "archivedTasks")
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(archive)
            alert.addAction(delete)
            alert.addAction(cancel)
            
            present(alert, animated: true)
        }
        
        
       
        //    }
        //
        //    func getData() {
        //
        //
        //        if let data = UserDefaults.standard.data(forKey: "tasks") {
        //
        //
        //        let decoder = JSONDecoder()
        //
        //
        //            if let array = try? decoder.decode([Task].self, from: data) {
        //
        //
        //                self.tasks = array
        //
        //
        //                self.tableView.reloadData()
        //            }
        //        }
        //    }
        //    func saveDataInPlist() {
        //
        //        let encoder = PropertyListEncoder()
        //
        //        if let data = try? encoder.encode(tasks) {
        //            do {
        //                try data.write(to: tasksFileAddress)
        //            } catch {
        //                print("Plist da malumot encode qilishda xatolik berdi")
        //            }
        //        }
        //
        //        tableView.reloadData()
        //    }
        //
        //    func getDataFromPlist() {
        //
        //        let decoder = PropertyListDecoder()
        //
        //        if let data = try? Data(contentsOf: tasksFileAddress) {
        //
        //            if let array = try? decoder.decode([Task].self, from: data) {
        //
        //                self.tasks = array
        //
        //                tableView.reloadData()
        //            }
        //        }
        //     
    }
}
