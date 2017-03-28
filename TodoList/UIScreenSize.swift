import UIKit

struct UIScreenSize{
    static func bounds()->CGRect{
        return UIScreen.mainScreen().bounds;
    }
    // 画面サイズ
    static func screenWidth()->Int{
        print("Width : \(Int( UIScreen.mainScreen().bounds.size.width))")
        return Int( UIScreen.mainScreen().bounds.size.width);
    }
    static func screenHeight()->Int{
        print("height : \( Int(UIScreen.mainScreen().bounds.size.height) ) ")
        return Int(UIScreen.mainScreen().bounds.size.height);
    }
    // 画面アスペクト比(5s基準)
    static func widthContrast()->Double{
        let width : Double = Double( screenWidth() ) / 320.0
        return width
    }
    static func heightContrast()->Double{
        let height : Double = Double( screenWidth() ) / 568.0
        return height
    }
}