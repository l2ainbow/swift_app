import UIKit

public class MessageDisplayImpl
{
    private messageText: UILabel!
    
    init(label: UILabel){
      self.messageText = label
    }
    
    func display(message: String){
      self.messageText.text = message
    }
} 
