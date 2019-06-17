//
//  historynameCell.swift
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/17.
//  Copyright © 2019 a. All rights reserved.
//

import UIKit

class historynameCell: UITableViewCell {
    
    lazy var nameLab: UILabel = {
        let lab = UILabel.init()
        lab.frame = CGRect.init(x: 10, y: 10, width: 100, height: 20)
        lab.textColor = UIColor.black
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    lazy var timeLab: UILabel = {
        let lab = UILabel.init()
        lab.frame = CGRect.init(x: 200, y: 10, width: 100, height: 20)
        lab.textColor = UIColor.black
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textAlignment = NSTextAlignment.right
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.nameLab)
        self.contentView.addSubview(self.timeLab)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
