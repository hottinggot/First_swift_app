//
//  EditViewController.swift
//  Text me
//
//  Created by 서정 on 2021/01/18.
//

import UIKit

class EditViewController: UIViewController, UITextViewDelegate{

    var memo: MemoVO?
    var indexNum: Int?
    
    @IBOutlet var backBtn: UIButton!
    
    let outerView = UIView(frame: CGRect())
    let mainTextView = UITextView(frame: CGRect())
    let titleText = UITextField(frame: CGRect())
    let deleteButton = UIButton(frame: CGRect())
    let editButton = UIButton(frame: CGRect())
    let copyButton = UIButton(frame: CGRect())
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        //textview outer view
        view.addSubview(outerView)
        
        //constraint
        
        outerView.translatesAutoresizingMaskIntoConstraints = false
        outerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        outerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        outerView.heightAnchor.constraint(equalToConstant: view.frame.height*3/5).isActive = true
        outerView.widthAnchor.constraint(equalToConstant: view.frame.width*3/5).isActive = true
        
        outerView.layer.masksToBounds = false
        outerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        outerView.layer.shadowOpacity = 0.5
        outerView.layer.shadowRadius = 10
        outerView.layer.shadowColor = UIColor.lightGray.cgColor
        
        //textView
        
        outerView.addSubview(mainTextView)
        
        mainTextView.translatesAutoresizingMaskIntoConstraints = false
        mainTextView.centerXAnchor.constraint(equalTo: outerView.centerXAnchor).isActive = true
        mainTextView.centerYAnchor.constraint(equalTo: outerView.centerYAnchor).isActive = true
        mainTextView.heightAnchor.constraint(equalTo: outerView.heightAnchor).isActive = true
        mainTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        mainTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        mainTextView.layer.masksToBounds = true
        mainTextView.layer.cornerRadius = 10
        mainTextView.font = UIFont.systemFont(ofSize: 15)
        mainTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        //mainTextView.text = memo?.mainText
        

        
        //title
        
        view.addSubview(titleText)
        
        //titleText.text = "20210302"
        
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titleText.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = false
        titleText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = false
        titleText.topAnchor.constraint(equalTo: outerView.bottomAnchor, constant: 10).isActive = true
        titleText.font = UIFont.boldSystemFont(ofSize: 20)
        
        
        //delete button
        deleteButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        view.addSubview(deleteButton)
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: outerView.topAnchor, constant: -10).isActive = true
        deleteButton.layer.masksToBounds = true
        deleteButton.layer.cornerRadius = 8
        deleteButton.backgroundColor = UIColor(rgb: 0xCABFB7)
        deleteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        deleteButton.addTarget(self, action: #selector(onDeleteButtonTouched), for: .touchUpInside)
        
        
        //edit button
        editButton.setImage(UIImage(named: "edit"), for: .normal)
        editButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.addSubview(editButton)
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        editButton.bottomAnchor.constraint(equalTo: outerView.topAnchor, constant: -10).isActive = true
        editButton.layer.masksToBounds = true
        editButton.layer.cornerRadius = 8
        editButton.backgroundColor = UIColor(rgb: 0xCABFB7)
        editButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        editButton.addTarget(self, action: #selector(onEditButtonTouched), for: .touchUpInside)
        
    
        //copy button
        copyButton.setImage(UIImage(named: "copy"), for: .normal)
        copyButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
        view.addSubview(copyButton)
        
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -10).isActive = true
        copyButton.bottomAnchor.constraint(equalTo: outerView.topAnchor, constant: -10).isActive = true
        copyButton.layer.masksToBounds = true
        copyButton.layer.cornerRadius = 8
        copyButton.backgroundColor = UIColor(rgb: 0xCABFB7)
        copyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        copyButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        copyButton.addTarget(self, action: #selector(onCopyButtonTouched), for: .touchUpInside)

        if let memo = memo {
            titleText.text = memo.titleText
            mainTextView.text = memo.mainText
            
            //saveMemo
            if(memo.isNew == true) {
                
                DataManager.shared.saveMemo(memo: memo)
                
            }
        }

        //mainTextView.delegate = self
        mainTextView.isEditable = false
        mainTextView.dataDetectorTypes = .link

        makeDoneAtToolbar()

        
            let okayButton = UIButton(frame: CGRect())
            okayButton.addTarget(self, action: #selector(onOkayButtonTouched), for: .touchUpInside)
            view.addSubview(okayButton)
            
        okayButton.translatesAutoresizingMaskIntoConstraints = false
        okayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        okayButton.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 10).isActive = true
        okayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        okayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        okayButton.layer.cornerRadius = 8
        okayButton.setImage(UIImage(named: "check"), for: .normal)
        okayButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10                                                                                                                                                                                                      )
        okayButton.layer.masksToBounds = true
        okayButton.backgroundColor = UIColor(rgb: 0xCABFB7)
        
    }
    
//    override func willMove(toParent parent: UIViewController?) {
//        parent?.navigationItem.largeTitleDisplayMode = .always
//    }
//   
    private func makeDoneAtToolbar() {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissMyKeyboard))

        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()

        self.titleText.inputAccessoryView = toolbar
        self.mainTextView.inputAccessoryView = toolbar

    }
    
    @IBAction func touchBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @objc func dismissMyKeyboard() {
        view.endEditing(true)
        saveChanges()

    }
    

    @objc func onOkayButtonTouched() {
        //모든 스택 비우고 첫 화면으로.
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)

    }
    
    @objc func onEditButtonTouched () {
        self.mainTextView.isEditable = true
        self.mainTextView.becomeFirstResponder()
        
    }
    
    @objc func onCopyButtonTouched() {
        UIPasteboard.general.string = mainTextView.text
        //클립보드에 복사되었습니다. 알리기
        showToast(message: "클립보드에 복사되었습니다.")
    }
    
    @objc func onDeleteButtonTouched() {
        print("delete button touched")
        if let indexNum = indexNum {
            DataManager.shared.deleteMemo(indexNum: indexNum)
        }
        if(memo?.isNew == true) {
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        
    }
    

    private func saveChanges() {

        if let indexNum = indexNum {
            let target = DataManager.shared.memoList[indexNum]
            target.mainText = self.mainTextView.text
            target.titleText = self.titleText.text
            target.updateDate = Date()
            DataManager.shared.updateMemo()
            
            //저장되었습니다. 알리기
            showToast(message: "저장되었습니다.")

        }
    }
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height-100, width: 250, height: 35))
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in toastLabel.removeFromSuperview() })
        
    }

        
}
    


extension EditViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
