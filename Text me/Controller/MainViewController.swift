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
    
    struct ReuseIdentifier {
        static let cellIdentifier = "CollectionViewCell"
    }
    
    
    @IBOutlet var cameraBtn: UIButton!
    
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
        
        if(segue.identifier == "ShowDetail") {
            
            
        
        if let cell = sender as? UICollectionViewCell, let indexPath = self.collectionView.indexPath(for: cell){

            if let editVc = segue.destination as? EditViewController {
                let detailMemo = MemoVO()
                let target = DataManager.shared.memoList[indexPath.row]
                detailMemo.isNew = false
                detailMemo.mainText = target.mainText
                detailMemo.subText = target.subText
                detailMemo.titleText = target.titleText
                detailMemo.upadateDate = target.updateDate
                if let imageName = target.refImage {
                    detailMemo.refImage = ImageManager.shared.fetchImage(imageName: imageName, to: detailMemo.refImage!.size)
                }   
                
                let indexNum = indexPath.row
                
                
                editVc.memo = detailMemo
                editVc.index = indexNum
            }
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
        
        //navigation item
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //search bar
        search.searchResultsUpdater = self  //search bar 내의 text 변경을 알림
        search.obscuresBackgroundDuringPresentation = false //현재 뷰의 흐려짐 방지
        search.searchBar.placeholder = "검색"
        self.navigationItem.searchController = search
        definesPresentationContext = true   //saerch view 가 활성화 되어있는 동안 다른 뷰로 이동하면 search bar 닫히도록

        
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

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFiltering()) {
            return filteredMemoList.count
        }
        return DataManager.shared.memoList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let target: [Memo]
        
        if(isFiltering()) {
            target = filteredMemoList
        } else {
            target = DataManager.shared.memoList
        }
        
        cell.cellTitle.text = target[indexPath.row].titleText
        cell.cellContents.text = target[indexPath.row].mainText
        
        if let imageName = target[indexPath.row].refImage {
//            let decoder = WebPDecoder()
//            var options = WebPDecoderOptions()
//            options.scaledWidth = Int(25)
//            options.scaledHeight = Int(25)
//            let cgimage = try! decoder.decode(image, options: options)
            
                
            cell.cellImage.image = ImageManager.shared.fetchImage(imageName: imageName, to: cell.cellImage.bounds.size)
          
            
            
        }

        return cell

    }
    
    //ios 11~
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in

            DataManager.shared.deleteMemo(indexNum: indexPath.row)
            DataManager.shared.memoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            success(true)

            })

        return UISwipeActionsConfiguration(actions:[deleteAction])

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
