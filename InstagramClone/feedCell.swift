import UIKit
import Firebase

class feedCell: UITableViewCell {
    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var cometLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    
    
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        var oldarray = [String]()
        
        let docRef = firestoreDatabase.collection("Posts").document(documentIdLabel.text!)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                oldarray = document.get("usersLikes") as! [String]
                
                print("in document",oldarray)
                
                if oldarray.contains(Auth.auth().currentUser!.email!) == false{
                    
                    if let likeCount = Int(self.likeLabel.text!){
                        
                        let likeStore = ["likes": likeCount + 1] as [String:Any]
                        
                        firestoreDatabase.collection("Posts").document(self.documentIdLabel.text!).setData(likeStore, merge: true)
                        
                        self.addUserLike()
                    }
                    
                }
                
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    
    func addUserLike(){
        let db = Firestore.firestore()
        
        let docRef = db.collection("Posts").document(documentIdLabel.text!)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var oldarray = document.get("usersLikes") as! [String]
                
                oldarray.append(Auth.auth().currentUser!.email!)
                print(oldarray)
                let newarray = ["usersLikes": oldarray]
                db.collection("Posts").document(self.documentIdLabel.text!).setData(newarray, merge: true)
            } else {
                print("Document does not exist")
            }
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
