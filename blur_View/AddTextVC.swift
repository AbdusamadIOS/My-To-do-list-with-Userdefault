//
//  AddTextVC.swift
//  blur_View
//
//  Created by Abdusamad Mamasoliyev on 02/05/23.
//

import UIKit

class AddTextVC: UIViewController {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var desTV: UITextView!
    @IBOutlet weak var choosebtn: UIButton!
    
    var closure:((Task) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        addBtn.layer.cornerRadius = 25
        choosebtn.layer.cornerRadius = 25
        choosebtn.backgroundColor = .systemGray5
    }

    @IBAction func ColorBtn(_ sender: UIButton) {
        
        let vc = ButtonColor(nibName: "ButtonColor", bundle: nil)
       
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        vc.closure = { color in
            
            self.choosebtn.backgroundColor = color
            

            
        }
        
        self.present(vc, animated: true)
    }
    
      @IBAction func addBtn(_ sender: Any) {
          
          
          let task = Task(title: titleTF.text ?? "Yangi vazifa",
                          description: desTV.text ?? "Malumot" ,
                          color: hexStringFromColor(color:  choosebtn.backgroundColor ?? .systemGray6))
        
         
          
          if let closure {
              closure(task)
          }
          dismiss(animated: true)
    }
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
