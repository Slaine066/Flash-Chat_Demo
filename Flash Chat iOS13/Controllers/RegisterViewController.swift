import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        //
        // Authentication: Sign-Up New Users
        //
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let err = error { // Watch out for errors (password must be atleast 6 characters long)
                    print(err.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: K.registerSegue , sender: self) // Navigate to the ChatViewController
                }
                
            }
        }
    }
}
