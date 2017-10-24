import UIKit

public class MessageDisplayImpl : MessageDisplay
{
    private var messageText : UILabel
    
    init(label: UILabel){
      self.messageText = label
    }
    
    public func display(message: String){
      self.messageText.text = message
    }
} 
