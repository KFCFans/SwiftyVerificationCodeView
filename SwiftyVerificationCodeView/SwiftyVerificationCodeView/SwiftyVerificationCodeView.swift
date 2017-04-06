//
//  SwiftyVerificationCodeView.swift
//  EULoginTemp
//
//  Created by lip on 17/4/6.
//  Copyright © 2017年 lip. All rights reserved.
//

import UIKit
/**
 滴滴验证码的逻辑
 不允许用户点击，顺序已经定死，可以用删除键回退，最后一个输完自动登陆
 */
class SwiftyVerificationCodeView: UIView {
    
    var firsttv:UITextField?
    var secondtv:UITextField?
    var thirdtv:UITextField?
    var forthtv:UITextField?

    
    /// 框框之间的间隔
    let margin:CGFloat = 10
    
    /// 框框的大小
    let width:CGFloat = 50
    
    /// 框框个数
    let numOfRect = 4

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

// MARK: - UI 相关方法
extension SwiftyVerificationCodeView{
    
    fileprivate func setupUI(){
        
        // 不允许用户直接操作验证码框
        self.isUserInteractionEnabled = false
        
     
        let leftmargin = (UIScreen.main.bounds.width - width * 4 - 3 * margin) / 2
        
        // 创建 4个 UITextFiedl
        firsttv = createTextField(frame: CGRect(x: leftmargin, y: 10, width: width, height: width))
        firsttv?.becomeFirstResponder()
        firsttv?.tag = 0
        secondtv =  createTextField(frame: CGRect(x: leftmargin + width + margin, y: 10, width: width, height: width))
        secondtv?.tag = 1
        thirdtv = createTextField(frame: CGRect(x: leftmargin + 2*width + 2*margin, y: 10, width: width, height: width))
        thirdtv?.tag = 2
        forthtv = createTextField(frame: CGRect(x: leftmargin + 3*width + 3*margin, y: 10, width: width, height: width))
        forthtv?.tag = 3
        
        firsttv?.becomeFirstResponder()
    }
    
    private func createTextField(frame:CGRect)->UITextField{
        
        let tv = SwiftyTextField(frame: frame)
        tv.borderStyle = .line
        tv.textAlignment = .center
        tv.font = UIFont.boldSystemFont(ofSize: 40)
        tv.delegate = self
        tv.deleteDelegate = self
        addSubview(tv)
        tv.keyboardType = .numberPad
        return tv
        
    }
    
}



extension SwiftyVerificationCodeView:UITextFieldDelegate,SwiftyTextFieldDeleteDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
        if !textField.hasText {
            
            textField.resignFirstResponder()
            switch textField.tag {
            case 0:
                firsttv?.text = string
                secondtv?.becomeFirstResponder()
                break
            case 1:
                secondtv?.text = string
                thirdtv?.becomeFirstResponder()
                break
            case 2:
                thirdtv?.text = string
                forthtv?.becomeFirstResponder()
                break
            case 3:
                forthtv?.text = string
            default:
                return false
            }
            
        }
            return false
        
    }
    
    /// 监听键盘删除键
    func didClickBackWard() {
        
        guard let secondtv = secondtv,let thirdtv = thirdtv,let forthtv = forthtv else {
            return
        }
        
        if secondtv.isFirstResponder {
            self.firsttv?.text = ""
            secondtv.resignFirstResponder()
            self.firsttv?.becomeFirstResponder()
        }else if thirdtv.isFirstResponder{
            self.secondtv?.text = ""
            thirdtv.resignFirstResponder()
            secondtv.becomeFirstResponder()
        }else if forthtv.isFirstResponder {
            self.thirdtv?.text = ""
            forthtv.resignFirstResponder()
            thirdtv.becomeFirstResponder()
        }
    }
    
    
}
