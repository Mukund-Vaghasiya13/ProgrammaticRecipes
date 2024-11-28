import UIKit

class RRTextArea: UITextView, UITextViewDelegate {
    
    let placeholderText: String
    
    init(placeholder: String) {
        self.placeholderText = placeholder
        super.init(frame: .zero, textContainer: nil)
        configureTextView()
        addPlaceholder()
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextView() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 18)
        isScrollEnabled = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = 5
        textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    private func addPlaceholder() {
        self.text = placeholderText
        self.textColor = .lightGray
    }
  
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Clear the placeholder text when the user starts editing
        if textView.text == placeholderText && textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black // Set to the actual text color
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // Show the placeholder if the text view is empty
        if textView.text.isEmpty {
            addPlaceholder()
        }
    }
}
