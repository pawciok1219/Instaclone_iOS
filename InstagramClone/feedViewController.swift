//
//  feedViewController.swift
//  InstagramClone
//
//  Created by Paweł Kamieński on 27/12/2021.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseDatabase


class feedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    
    
    @IBOutlet weak var tableView: UITableView!

    var idArray = [String]()
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIDArray = [String]()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
        getDateFromFirestore()
        
        tableView.allowsMultipleSelectionDuringEditing = true
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! feedCell
        
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.cometLabel.text = userCommentArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
//        if likeArray.count < indexPath.row {
//            cell.likeLabel.text = String(likeArray[indexPath.row])
//        }
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.documentIdLabel.text = documentIDArray[indexPath.row]
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userEmailArray.count
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if Auth.auth().currentUser!.email! == userEmailArray[indexPath.row]{
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if Auth.auth().currentUser!.email! == userEmailArray[indexPath.row] {
            
            deletePost(with: idArray[indexPath.row])
            
            self.idArray[indexPath.row].removeAll()
            self.documentIDArray[indexPath.row].removeAll()
            self.userImageArray[indexPath.row].removeAll()
            self.userEmailArray[indexPath.row].removeAll()
//            self.likeArray.remove(at: indexPath.row)
            self.userCommentArray[indexPath.row].removeAll()
            
            self.tableView.reloadData()

        }
    }
            
                
//            Database.database().reference().child("Posts").child(postID).removeValue { (error, ref) in
//
//                if error != nil {
//                    print("Failed to delete message")
//                    return
//                }
//
//                self.documentIDArray[indexPath.row].removeAll()
//                self.userImageArray[indexPath.row].removeAll()
//                self.userEmailArray[indexPath.row].removeAll()
//                self.likeArray.remove(at: indexPath.row)
//                self.userCommentArray[indexPath.row].removeAll()
//
//                self.tableView.reloadData()
//
//            }
            
    
    func getDateFromFirestore()
    {
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                
                print(error?.localizedDescription)
            }
            
            if snapshot?.isEmpty != true && snapshot != nil
            {
                self.idArray.removeAll()
                self.userImageArray.removeAll()
                self.userEmailArray.removeAll()
                self.userCommentArray.removeAll()
                self.likeArray.removeAll()
                self.documentIDArray.removeAll()
                
                for document in snapshot!.documents
                {
                    let documentID = document.documentID
                    
                    if let id = document.get("id") as? String
                    {
                        self.idArray.append(id)
                    }
                    
                    if let postedBy = document.get("postedBy") as? String
                    {
                        self.userEmailArray.append(postedBy)
                    }
                    
                    if let postComment = document.get("postComment") as? String
                    {
                        self.userCommentArray.append(postComment)
                    }
                    
                    if let likes = document.get("likes") as? Int {
                        
                        self.likeArray.append(likes)
                    }
                    
                    if let imageUrl = document.get("imageUrl") as? String
                    {
                        self.userImageArray.append(imageUrl)
                    }
                    
                    self.documentIDArray.append(documentID)
                    
                }
                
                self.tableView.reloadData()
                
            }
        }
    }
    
    func deletePost(with id: String){
        let db = Firestore.firestore()
        
        db.collection("Posts").whereField("id", isEqualTo: id).getDocuments { (snap, err) in
            
            if err != nil {
                print("Error")
                return
            }
            
            for i in snap!.documents {
                DispatchQueue.main.async{
                    i.reference.delete()
                }
            }
            
        }
    }
    

}
