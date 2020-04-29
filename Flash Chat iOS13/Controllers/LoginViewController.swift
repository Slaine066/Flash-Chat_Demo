import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!

    @IBAction func loginPressed(_ sender: UIButton) {
        
        //
        // Authentication: Sign-In Existing Users
        //
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else { return }
                if let err = error {
                    print(err)
                } else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self) // Navigate to the ChatViewController
                }
            }
        }
    }
    
}
