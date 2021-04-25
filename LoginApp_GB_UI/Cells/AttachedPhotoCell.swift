//
//  AttachedPhotoCell.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 22.04.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import UIKit
import Kingfisher

class AttachedPhotoCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    
    func configure(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        photoImageView.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.kf.cancelDownloadTask()
        photoImageView.image = nil
    }

}
