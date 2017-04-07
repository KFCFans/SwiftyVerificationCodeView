//
//  TestTextField.swift
//  EULoginTemp
//
//  Created by lip on 17/4/6.
//  Copyright © 2017年 lip. All rights reserved.
//

import UIKit


protocol SwiftyTextFieldDeleteDelegate {
    func didClickBackWard()
}

class SwiftyTextField: UITextField {
    
    var deleteDelegate:SwiftyTextFieldDeleteDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        deleteDelegate?.didClickBackWard()

    }

}
