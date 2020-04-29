import UIKit
import Firebase

class ChatViewController: UIViewController {

    // Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = K.appName // Set the title to a human-readable string that describes the view. If the view controller has a valid navigation item or tab-bar item, assigning a value to this property updates the title text of those objects.
        navigationItem.hidesBackButton = true // Hide the "Back" button
        
        tableView.dataSource = self
        //tableView.delegate = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    
    // Actions
    @IBAction func sendPressed(_ sender: UIButton) {
        // CloudFirestore: Write Data
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email { // How to get the currently Signed-In User
            if messageBody != "" {
                db.collection(K.FStore.collectionName).addDocument(data: [
                    K.FStore.senderField: messageSender,
                    K.FStore.bodyField: messageBody,
                    K.FStore.dateField: Date().timeIntervalSince1970
                ]) { (error) in
                    if let err = error {
                        print("There was an issue saving data into Firestore: \(err)")
                    } else {
                        DispatchQueue.main.async {
                            self.messageTextfield.text = "" // Empty the textfield after pressing Send button
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    
    // Functions
    func loadMessages() {
        
        // CouldFirestore: Read Data
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in // The SnapShotListener triggers the closure below everytime there is a change in the collection it's listening to.
            
            self.messages = [] // Empty the messages array to avoid duplicate data
            
            if let err = error {
                print("There was an issue retreaving data from Firestore: \(err)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        if let messageSender = doc.data()[K.FStore.senderField] as? String, let messageBody = doc.data()[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0) // There is only 1 section
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}


//MARK: - TableView DataSource
extension ChatViewController: UITableViewDataSource { // Protocol responsible to populate the TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell // Forced Downcast
        cell.messageLabel.text = message.body
        
        // Message sent from the Signed-In User
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.messageLabel.textColor = UIColor(named: K.BrandColors.purple)
        } else { // Message sent from an other User
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lighBlue)
            cell.messageLabel.textColor = UIColor(named: K.BrandColors.blue)
        }
        return cell
    }
}


//extension ChatViewController: UITableViewDelegate { // Protocol responsible to interact with the TableView (useless in this case)
//
//}
