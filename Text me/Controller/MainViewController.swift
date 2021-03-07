//
//  ViewController.swift
//  Text me
//
//  Created by 서정 on 2021/01/18.
//

import UIKit
import MobileCoreServices
import WebP
import ImageIO

class MainViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var cameraBtn: UIButton!
    struct ReuseIdentifier {
        static let cellIdentifier = "CollectionViewCell"
    }
    
    
    var token: NSObjectProtocol?
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let search = UISearchController(searchResultsController: nil)
    var filteredMemoList = [Memo]()
    
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }

    
    //Segueway
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        


            if let cell = sender as? UICollectionViewCell, let indexPath = self.collectionView.indexPath(for: cell){

                if let editVc = segue.destination as? EditViewController {
            
                    let target = DataManager.shared.memoList[indexPath.row]
                    editVc.indexNum = indexPath.row
                    
                    let m = MemoVO()
                    m.isNew = false
                    m.mainText = target.mainText
                    m.upadateDate = target.updateDate
                    m.titleText = target.titleText
                   
                    editVc.memo = m
                }
            }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllMemoList()
        collectionView.reloadData()
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        token =  NotificationCenter.default.addObserver(forName: EditViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main) {
            [weak self] (noti) in
            self?.collectionView.reloadData()
        }
        
        
        //search bar
        search.searchResultsUpdater = self  //search bar 내의 text 변경을 알림
        search.obscuresBackgroundDuringPresentation = false //현재 뷰의 흐려짐 방지
        search.searchBar.placeholder = "검색"
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = true

        
        definesPresentationContext = true   //saerch view 가 활성화 되어있는 동안 다른 뷰로 이동하면 search bar 닫히도록

        //navigation item
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        //collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 10
        collectionView.reloadData()
        
        //cameraBtn
        cameraBtn.layer.cornerRadius = 8
        cameraBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        cameraBtn.layer.shadowColor = UIColor.gray.cgColor
        cameraBtn.layer.shadowRadius = 5
        cameraBtn.layer.shadowOpacity = 0.9
        cameraBtn.layer.masksToBounds = false
//        let cameraBtn = UIButton(frame: CGRect())
//
//        view.addSubview(cameraBtn)
//        //view.sendSubviewToBack(cameraBtn)
//        //cameraBtn.sendSubviewToBack(cameraBtn)
//        cameraBtn.layer.backgroundColor = UIColor(red: 206, green: 206, blue: 210, alpha: 1).cgColor
//        cameraBtn.translatesAutoresizingMaskIntoConstraints = false
//        cameraBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
//        cameraBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
//        cameraBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        cameraBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        cameraBtn.layer.cornerRadius = 8
//        cameraBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
//        cameraBtn.layer.shadowColor = UIColor.gray.cgColor
//        cameraBtn.layer.shadowRadius = 5
//        cameraBtn.layer.shadowOpacity = 0.9
//        cameraBtn.layer.masksToBounds = false
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    private func getAllMemoList() {
        DataManager.shared.fetchMemo()
    }
    
    @IBAction func cameraBtnTouch(_ sender: UIButton) {
        guard let cameraVc = self.storyboard?.instantiateViewController(identifier: "customCameraView") as? CameraViewController else {
            return
        }
        present(cameraVc, animated: true, completion: nil)
    }
    
    
    var captureImage: UIImage!
    
    
    func alertMsg(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func searchBarIsEmpty() -> Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        let target = DataManager.shared.memoList;
        filteredMemoList = target.filter({(memo: Memo) -> Bool in
            return ((memo.titleText?.lowercased().contains(searchText.lowercased()) ?? false || memo.mainText?.lowercased().contains(searchText.lowercased()) ?? false))
        })
        
        collectionView.reloadData()
        
    }
    
    private func isFiltering() -> Bool {
        return search.isActive && !searchBarIsEmpty()
    }
 
    
}


extension MainViewController: UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(search.searchBar.text!)
        
    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(isFiltering()) {
            return filteredMemoList.count
        }
        return DataManager.shared.memoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.cellIdentifier, for: indexPath) as! CustomCollectionViewCell
        
        //collectionCell.isUserInteractionEnabled = true
        collectionCell.contentView.isUserInteractionEnabled = false
        
        //style
        collectionCell.collectionImage.layer.cornerRadius = 8
        collectionCell.collectionImage.layer.shadowOffset = CGSize(width: 1, height: 1)
        collectionCell.collectionImage.layer.shadowOpacity = 0.9
        collectionCell.collectionImage.layer.shadowRadius = 5
        collectionCell.collectionImage.layer.shadowColor = UIColor.gray.cgColor
        
        
        let target: [Memo]
        
        if(isFiltering()) {
            target = filteredMemoList
        } else {
            target = DataManager.shared.memoList
        }
        
        //collectionCell.titleLabel.text = target[indexPath.row].titleText
        if let imageName = target[indexPath.row].refImage {
//            let decoder = WebPDecoder()
//            var options = WebPDecoderOptions()
//            options.scaledWidth = Int(25)
//            options.scaledHeight = Int(25)
//            let cgimage = try! decoder.decode(image, options: options)
            
            collectionCell.collectionImage.image = ImageManager.shared.fetchImage(imageName: imageName, to: collectionCell.collectionImage.bounds.size)
        }

        return collectionCell

    }
    
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var columns: CGFloat
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            columns = 4
        } else {
            columns = 2
        }
        
        let spacing:CGFloat = 20
        let totalHorizontalSpacing = (columns+1)*spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing)/columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth*0.9)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
}


