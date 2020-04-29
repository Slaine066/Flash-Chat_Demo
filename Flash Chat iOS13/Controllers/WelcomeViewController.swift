import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Tyiping Effect Title
        // Possible either with the code below, or using CLTypingLabel Library (CocoaPods).
        //
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "⚡️FlashChat"

        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
}
