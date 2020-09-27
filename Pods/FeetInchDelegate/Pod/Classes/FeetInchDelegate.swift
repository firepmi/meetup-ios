
import UIKit

public class FeetInchDelegate : NSObject ,UITextFieldDelegate {
    
    public let expression: NSRegularExpression
    public let startingText: String = "' \""
    private var hasFeets: Bool = false
    
    override public init(){
        self.expression = try! NSRegularExpression(pattern: "^([0-9]?)' ((?:[0-9]|10|11)?)\"", options: NSRegularExpression.Options())
        super.init()
    }
   
    /**
    * Find the position of inches in a string
    */
    public func positionOfValuesInString(string:String) -> (feets:NSRange, inches:NSRange)? {
        let matches = self.expression.matches(in: string, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, string.count))
        guard matches.count == 1 else { return nil }
                
        let feetsPos = matches[0].range(at: 1)
        let inchesPos = matches[0].range(at: 2)
        
        return (feetsPos, inchesPos)
    }
    
    public func extractValuesFromString(string: String) -> (feets: Int?, inches: Int?) {
        guard let (feetRange, inchRange) = self.positionOfValuesInString(string: string) else { return (nil, nil) }
        let str = string as NSString
        let feets = Int(str.substring(with: feetRange))
        
        let inchString = str.substring(with: inchRange)
        let inches = Int(inchString)
        return (feets, inches)
    }
    
    /**
    * When started editing, check if it matches the regex. If not init proper text, move the cursor to feet position
    * Start observing if text did change
    */
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        let matches = self.expression.matches(in: textField.text!, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, textField.text!.count))
        if matches.count == 0 {
            textField.text = self.startingText
        }
        
        let (feets, _) = self.extractValuesFromString(string: textField.text!)
        self.hasFeets = feets != nil
        let offset = self.hasFeets ? 1 : 0
        let position:UITextPosition = textField.position(from: textField.beginningOfDocument, offset: offset)!
        textField.selectedTextRange = textField.textRange(from: position, to: position)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: UITextField.textDidChangeNotification, object: textField)
    }
    
    /**
    * If text field finished editing unsubscribe from notifications
    */
    public func textFieldDidEndEditing(_ textField: UITextField) {
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
    * If text was changed, check if user provided feet, then move the cursor to inches position
    */
    @objc public func textFieldDidChange(notification:NSNotification){
        let textField = notification.object! as! UITextField
        guard let (feetsPos, inchesPos) = self.positionOfValuesInString(string: textField.text!) else { return }
        
        if feetsPos.length > 0 && self.hasFeets == false {
            let offset = inchesPos.location + inchesPos.length
            let position:UITextPosition = textField.position(from: textField.beginningOfDocument, offset: offset)!
            textField.selectedTextRange = textField.textRange(from: position, to: position)
        }
        self.hasFeets = feetsPos.length > 0
    }
    
    /**
    * Check if characters pass regex test, and inches are between 0 and 11. (12 inches = 1 foot)
    */
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let text = textField.text! as NSString
        print(string)
        let newText = text.replacingCharacters(in: range, with: string) as String
        print(newText)
        let matches = self.expression.matches(in: newText, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, newText.count))
        let matchOk = matches.count == 1
        print(matchOk)
        print(newText.count, textField.text!.count)
        //if the newText stops to match the regex and is of lower length - user hitted backspace
        //go to proper position - user goes back to edit feet or inches
        if matchOk == false && newText.count < textField.text!.count  {
            //move cursor to a proper position
            guard let (feetRange, inchRange) = self.positionOfValuesInString(string: text as String) else { return matchOk }
            let desiredPositionRange = range.location < inchRange.location ? feetRange : inchRange
            let position:UITextPosition = textField.position(from: textField.beginningOfDocument, offset: desiredPositionRange.location + desiredPositionRange.length)!
            
            textField.selectedTextRange = textField.textRange(from: position, to: position)
        }
        
        return matchOk
    }
    
}
