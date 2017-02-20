//
//  HeaderReusableView.swift
//  CollectionViewCats
//
//  Created by Joel Bell on 10/3/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {
    
    var headerLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        
        configureTimer()  //added here as it does not work in footer
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func configureView() {
        
        headerLabel = UILabel()
        headerLabel.font = UIFont.helveticaNeueCondensedBold(size: 26)
        headerLabel.text = "Cat Pic Puzzle"
        self.addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8).isActive = true
        
        
    }
    
    private func configureTimer() {
        
    }
    
}
