//
//  ViewController.swift
//  loaner
//
//  Created by Erick Sanchez on 8/15/18.
//  Copyright © 2018 LinnierGames. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ViewController: UIViewController {
    
    var ref: DatabaseReference?
    
    var items: [Item] = []
    
    func createNewItem() -> Item {
        return Item(itemTitle: "Untitled Item")
    }
    
    func add(saved item: Item) {
        items.insert(item, at: 0)
        collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
        
        guard let ref = self.ref else {
            print("unable to find database reference when adding item")
            return
        }
        
        let key = ref.child("items").childByAutoId().key
        let newItem = ["name": item.itemTitle,
            "notes": item.notes,
            "loanee": item.loanee?.contactInfo.identifier]
        ref.child("items").child(key!).setValue(newItem)
        uploadProfileImage(item.itemImage, key: key!, completion: ({ [weak self] url in
            self?.ref?.child("items").child(key!).updateChildValues(["imageUrl": url?.absoluteString])
        }))
    }
    
    func markItemAsReturned(at index: Int) {
        //TODO: archive returned items instead of deleting them
        deleteItem(at: index)
    }
    
    func deleteItem(at index: Int) {
        items.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show detailed item":
                guard let detailedItemVc = segue.destination as? ItemDetailedViewController else {
                    return print("storyboard not set up correctly")
                }
                
                guard
                    let collectionViewCell = sender as? UICollectionViewCell,
                    let indexPath = collectionView.indexPath(for: collectionViewCell) else {
                        return print("'show detailed item' was performed by a non-collection view cell")
                }
                
                let selectedItem = items[indexPath.row]
                detailedItemVc.item = selectedItem
            case "show new item":
                guard let itemEditorVc = segue.destination as? ItemEditorViewController else {
                    return print("storyboard not set up correctly")
                }
                
                let newItem = createNewItem()
                itemEditorVc.item = newItem
            default: break
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "unwind from back":
            break
        case "unwind from trash":
            guard
                let selectedIndexPaths = collectionView.indexPathsForSelectedItems,
                let selectedItemIndexPath = selectedIndexPaths.first else {
                    return
            }
            
            deleteItem(at: selectedItemIndexPath.row)
        case "unwind from mark as returned":
            guard
                let selectedIndexPaths = collectionView.indexPathsForSelectedItems,
                let selectedItemIndexPath = selectedIndexPaths.first else {
                    return
            }
            
            markItemAsReturned(at: selectedItemIndexPath.row)
        case "unwind from saving new item":
            guard let itemContactVc = segue.source as? ItemContactInfoViewController else {
                return print("storyboard not set up correctly")
            }
            
            add(saved: itemContactVc.item)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get database reference
        ref = Database.database().reference()
        
        //set up collection view layout to be half of the screen width and with some padding
        let flow = UICollectionViewFlowLayout()
        let screenSize = view.bounds.size
        let horizontalPadding: CGFloat = 8
        let verticalPadding: CGFloat = 12
        flow.itemSize = CGSize(width: screenSize.width / 2 - horizontalPadding * 2, height: screenSize.width / 2 - verticalPadding * 2)
        flow.sectionInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        collectionView.collectionViewLayout = flow
        
        guard let ref = self.ref else {
            print("unable to get database reference upon view loading")
            return
        }
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            self.items = []
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            print("postDict is:")
            print(postDict)
            let dbItems = postDict["items"] as? [String: AnyObject] ?? [:]
            for rest in dbItems {
                print("rest is:")
                print(rest)
                guard let restDict = rest.value as? [String: String ] else { continue }
                guard let name = restDict["name"],
                    let notes = restDict["notes"],
                    let url = restDict["imageUrl"],
                    let loanee = restDict["loanee"] else { return }
                
                let person = Loanee(name: loanee, profileImage: UIImage(named: "no profile image")!, contactNumber: "")
                var item = Item(itemTitle: name, notes: notes, itemImage: UIImage(named: "no item image")!, loanee: person)
                print(item.itemImage)
                // asynchronously get item image
                DispatchQueue.global(qos: .userInteractive).async {
                    print("getting the image data for \(item.itemTitle)")
                    let data = try? Data(contentsOf: URL(string: url)!)
                    DispatchQueue.main.async {
                        print("updating the image for \(item.itemTitle)")
                        let debugImage = UIImage(data: data!) ?? UIImage(named: "no item image")!
                        print(debugImage)
                        item.itemImage = UIImage(data: data!) ?? UIImage(named: "no item image")!
                    }
                }
                self.items.append(item)
            }
            self.collectionView.reloadData()
        })
    }
    
    func uploadProfileImage(_ image:UIImage, key: String, completion: @escaping ((_ url:URL?)->())) {
        let storageRef = Storage.storage().reference().child("items/\(key)")
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                
                storageRef.downloadURL { url, error in
                    completion(url)
                }
            } else {
                completion(nil)
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item cell", for: indexPath) as! ItemCollectionViewCell
        
        let item = items[indexPath.row]
        cell.configure(item)
        
        return cell
    }
}

