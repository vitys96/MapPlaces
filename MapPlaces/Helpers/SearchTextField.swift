//
//  SearchTextField.swift
//  MapPlaces
//
//  Created by TOOK on 28.12.2019.
//  Copyright © 2019 TOOK. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        self.layer.borderWidth = 0.3
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.placeholder = "Search places"
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.shadowOpacity = 0.9
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        //To apply padding
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
        self.clearButtonMode = .whileEditing
        
    }
    
}
