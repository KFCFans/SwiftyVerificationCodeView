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

protocol SwiftyVerificationCodeViewDelegate {
    func verificationCodeDidFinishedInput(code:String)
}
class SwiftyVerificationCodeView: UIView {
    
    /// 代理回调
    var delegate:SwiftyVerificationCodeViewDelegate?
    
    /// 一堆框框的数组
    var textfieldarray = [UITextField]()

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
        
        // 创建 n个 UITextFiedl
        for i in 0..<numOfRect{
            
            let rect = CGRect(x: leftmargin + CGFloat(i)*width + CGFloat(i)*margin, y: 10, width: width, height: width)
            let tv = createTextField(frame: rect)
            tv.tag = i
            textfieldarray.append(tv)
            
        }
        
        // 防止搞事
        if numOfRect < 1 {
            return
        }
        
        textfieldarray.first?.becomeFirstResponder()
        
    }
    
    private func createTextField(frame:CGRect)->UITextField{
        
        let tv = SwiftyTextField(frame: frame)
        tv.borderStyle = .line
        tv.textAlignment = .center
        tv.font = UIFont.boldSystemFont(ofSize: 40)
        tv.textColor = UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
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
                textfieldarray[0].text = string
                textfieldarray[1].becomeFirstResponder()
                break
            case 1:
                textfieldarray[1].text = string
                textfieldarray[2].becomeFirstResponder()
                break
            case 2:
                textfieldarray[2].text = string
                textfieldarray[3].becomeFirstResponder()
                break
            case 3:
                textfieldarray[3].text = string
                // 拼接结果
                var code = ""
                for tv in textfieldarray{
                    code += tv.text ?? ""
                }
                delegate?.verificationCodeDidFinishedInput(code: code)
                
            default:
                return false
            }
            
        }
            return false
        
    }
    
    /// 监听键盘删除键
    func didClickBackWard() {
        
        for i in 1..<numOfRect{
            
            if !textfieldarray[i].isFirstResponder {
                continue
            }
            textfieldarray[i].resignFirstResponder()
            textfieldarray[i-1].becomeFirstResponder()
            textfieldarray[i-1].text = ""
            
        }
    }
    
    
}
