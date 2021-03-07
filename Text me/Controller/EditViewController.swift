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
        
        view.addSubview(deleteButton)
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: outerView.topAnchor, constant: -10).isActive = true
        deleteButton.layer.masksToBounds = true
        deleteButton.layer.cornerRadius = 8
        deleteButton.backgroundColor = UIColor.brown
        deleteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        deleteButton.addTarget(self, action: #selector(onDeleteButtonTouched), for: .touchUpInside)
        
        
        //edit button
        
        view.addSubview(editButton)
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        editButton.bottomAnchor.constraint(equalTo: outerView.topAnchor, constant: -10).isActive = true
        editButton.layer.masksToBounds = true
        editButton.layer.cornerRadius = 8
        editButton.backgroundColor = UIColor.brown
        editButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        editButton.addTarget(self, action: #selector(onEditButtonTouched), for: .touchUpInside)
        
    
        //copy button
        
        view.addSubview(copyButton)
        
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -10).isActive = true
        copyButton.bottomAnchor.constraint(equalTo: outerView.topAnchor, constant: -10).isActive = true
        copyButton.layer.masksToBounds = true
        copyButton.layer.cornerRadius = 8
        copyButton.backgroundColor = UIColor.brown
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
        okayButton.layer.cornerRadius = okayButton.frame.width*0.5
        okayButton.layer.masksToBounds = true
        okayButton.backgroundColor = UIColor.brown
        
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

        }
    }
        
}
    


extension EditViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
}


//extension UITextView {
//
//  func underlined() {
//    let border = CALayer()
//    let width = CGFloat(1.0)
//    border.borderColor = UIColor.lightGray.cgColor
//    border.frame = CGRect(x: 0, y: self.frame.size.height - 5, width:  self.frame.size.width, height: 1)
//    border.borderWidth = width
//    self.layer.addSublayer(border)
//    self.layer.masksToBounds = true
//    let style = NSMutableParagraphStyle()
//    style.lineSpacing = 15
//    let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.foregroundColor : UIColor.darkGray, NSAttributedString.Key.font :  UIFont.systemFont(ofSize: 13)]
//    self.attributedText = NSAttributedString(string: self.text, attributes: attributes)
//  }
//
//}
