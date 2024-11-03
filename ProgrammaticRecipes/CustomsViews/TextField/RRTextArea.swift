//
//  RRTextArea.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 03/11/24.
//

import UIKit

class RRTextArea: UITextView {
    
    private let placeholderText: String
    
    init(placeholder: String) {
        self.placeholderText = placeholder
        super.init(frame: .zero, textContainer: nil)
        self.text = placeholderText
        configureTextView()
        
        // Add observer to handle placeholder text
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextView() {
        translatesAutoresizingMaskIntoConstraints = false
        self.textColor = .lightGray
        self.font = UIFont.systemFont(ofSize: 18)
        isScrollEnabled = true
        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
    

    @objc private func textDidChange() {
        // Remove placeholder when user starts typing
        if text.isEmpty {
            text = placeholderText
            textColor = .lightGray
        } else if textColor == .lightGray {
            text = ""
            textColor = .black
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

