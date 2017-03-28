//
//  ViewController.swift
//  gegagag
//
//  Created by 松江飛雄馬 on 2016/01/20.
//  Copyright © 2016年 松江飛雄馬. All rights reserved.
//

import UIKit

var todoItem = [String]()   // タイトル名
var todoImage = [String]()  // 各cellの画像
var todoTime = [String]()   // 指定時間
let imgArray: NSArray = ["enemy.png","enemy2.png","enemy3.png","enemy4.png",
    "enemy5.png","enemy6.png","enemy7.png"]


class AddToDo: UIViewController, UITextFieldDelegate,  UIPickerViewDelegate,UIPickerViewDataSource{
    // ----- フィールド -----
    let leftButton = UIBarButtonItem!()
    let width = UIScreenSize.screenWidth()
    let height = UIScreenSize.screenHeight()
    let SAVE_ACT = 1
    let SCREEN_TRANS = 2
    var image  = UIImage( named: "backs.png" )
    var save = UIButton( frame: CGRectMake( 0, 0, 200, 50 ) )
    var sampleImage = UIImage( named: "enemyMake_sean.png" )
    var yusha = UIImage( named: "yuusha.png" )
    var sampleView = UIImageView( frame: CGRectMake( 0,0, 50, 50 ) )
    var yushaView = UIImageView( frame: CGRectMake( 0, 0, 50, 50 ) )
    var thisTimer = UILabel( frame: CGRectMake( 0, 0, 50, 200 ) )
    private var myUIPicker: UIPickerView!
    private var myRightButton : UIBarButtonItem!
    private var myTextField: UITextField!
    private var preSelectedLb:UILabel!
    @IBOutlet weak var navigation: UINavigationBar!
    var tMonth : Int = 0
    var td : Int = 0
    var th: Int = 0
    var tMin : Int = 0
    var timer : Double = -1
    var ChoseTime : Int64!
    var backImageView : UIImageView!
    var myValues = [
        ["2016","2017"],
        ["01","02","03","04","05","06","07","08","09","10","11","12"],["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"],
        ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"],["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]]
    // -----    --------
    
    // ---  set up  -----
    override func viewDidLoad() {
        super.viewDidLoad()
        print("width : \( width ) height \( height )")
        let charaBack = UIImageView(frame:CGRectMake( 0, 0, CGFloat(width), 270 ) )
        charaBack.backgroundColor = UIColor.blueColor()
        charaBack.layer.position = CGPoint(x : CGFloat(width) / 2 , y: 200 )
        self.view.sendSubviewToBack( charaBack )
        self.view.addSubview( charaBack )
        sampleView.image = sampleImage
        yushaView.image = yusha
        thisTimer = UILabel(frame: CGRect( x: 0, y: 0, width: 200, height: 50 ))
        thisTimer.textAlignment = NSTextAlignment.Center
        thisTimer.font = UIFont.systemFontOfSize(CGFloat(20))
        thisTimer.textColor = UIColor.whiteColor()
        // 右ボタンを作成する.
        myRightButton = UIBarButtonItem( title: "RightBtn", style: .Plain, target: self, action: "onClickMyButton:" )
        myRightButton.tag = 2
        
        save.setTitle("Save", forState: UIControlState.Normal)
        save.tag = 1
        save.addTarget( self, action: "onClickMyButton:", forControlEvents: .TouchUpInside )
        save.setTitleColor( UIColor.whiteColor(), forState: UIControlState.Normal )
        save.titleLabel!.font = UIFont.systemFontOfSize( CGFloat( 20 ) )
        // UITextFieldを作成する.
        myTextField = UITextField( frame: CGRectMake( 0, 0, 200, 40 ) )
        // 表示する文字を代入する.
        myTextField.placeholder = "TITLE"
        
        // Delegateを設定する.
        myTextField.delegate = self
        
        // 枠を表示する.
        myTextField.borderStyle = UITextBorderStyle.RoundedRect
        myUIPicker = UIPickerView()
        // Delegateを設定する.
        myUIPicker.delegate = self
        
        // DataSourceを設定する.
        myUIPicker.dataSource = self
        
        
        //　--- オブジェクト配置 ----
        for i in 0 ... 3 {
            backImageView = UIImageView( frame:CGRectMake( 0, 0, CGFloat( width ), CGFloat( height ) / 6  ))
            backImageView.image = image
            backImageView.layer.position = CGPoint( x : CGFloat( width ) / 2 , y: CGFloat( CGFloat(height) - backImageView.frame.height / 2 ) - CGFloat(Int( height / 6 ) * i ) )
            if i == 0 {
                save.layer.position = CGPoint(x : CGFloat(width) / 2, y : backImageView.layer.position.y + 10 )
            }else if i == 3 {
                // UITextFieldの表示する位置を設定する.
                myTextField.layer.position = CGPoint( x : CGFloat( width ) / 2, y : backImageView.layer.position.y + 10 )
                sampleView.layer.position = CGPoint( x : CGFloat( width ) / 10 , y : backImageView.layer.position.y - sampleView.frame.height * 1.5  )
                yushaView.layer.position = CGPoint( x : (CGFloat( width ) / 10 ) * 9 , y : backImageView.layer.position.y - sampleView.frame.height * 1.5 )
            }else if i == 2 {
                // サイズを指定する.
                myUIPicker.frame = CGRectMake( 0, 0, CGFloat( width ) , backImageView.frame.height )
                myUIPicker.layer.position = CGPoint( x : CGFloat( width ) / 2, y : backImageView.layer.position.y + 10 )
            }else if i == 1 {
                thisTimer.layer.position = CGPoint(x : CGFloat( width ) / 2, y : backImageView.layer.position.y + 10 )
            }
            self.view.addSubview(backImageView)
        }
        
        
        // ナビゲーションバーの右に設置する.
        self.navigationItem.rightBarButtonItem = myRightButton
        // Viewに追加する.
        self.view.addSubview(myTextField)
        self.view.addSubview(save)
        self.view.addSubview(myUIPicker)
        self.view.addSubview(yushaView)
        self.view.addSubview(sampleView)
        self.view.addSubview(thisTimer)
    }
    
    // UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
    func textFieldShouldEndEditing( textField: UITextField ) -> Bool {
        print( "textFieldShouldEndEditing:" + textField.text! )
        
        return true
    }
    // pickerに表示する列数を返すデータソースメソッド.(実装必須)
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return myValues.count
    }
    
    // pickerに表示する行数を返すデータソースメソッド.(実装必須)
    func pickerView( pickerView: UIPickerView, numberOfRowsInComponent component: Int ) -> Int {
        
        let compo = myValues[component]
        return compo.count
    }
    
    /*
    pickerに表示する値を返すデリゲートメソッド.
    */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = myValues[component][row]
        return item
    }
    // ピッカーのフォントや色の設定
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = myValues[component][row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        return myTitle
    }
    // 列の幅
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        var pickerWidth : CGFloat!
        if component != 0 {
            pickerWidth = CGFloat( ( width - ( width / myValues.count ) ) / 6  )
        }else{
            pickerWidth = CGFloat( width / myValues.count)
        }
        return pickerWidth
    }
    
    // pickerが選択された際に呼ばれるデリゲートメソッド.
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let row1 = pickerView.selectedRowInComponent(0)
        let row2 = pickerView.selectedRowInComponent(1)
        let row3 = pickerView.selectedRowInComponent(2)
        let row4 = pickerView.selectedRowInComponent(3)
        let row5 = pickerView.selectedRowInComponent(4)
        let year = self.pickerView( pickerView, titleForRow: row1, forComponent: 0 )
        let month = self.pickerView( pickerView, titleForRow: row2, forComponent: 1 )
        let day = self.pickerView( pickerView, titleForRow: row3, forComponent: 2 )
        let hour = self.pickerView( pickerView, titleForRow: row4, forComponent: 3 )
        let minute = self.pickerView( pickerView, titleForRow: row5, forComponent: 4 )
        print("\( year!, month!, day!, hour!, minute! ) です")
        thisTimer.text = "\( year! )/\( month! )/\( day! ) \( hour! ):\( minute! )"
        
        // 選択した時間を秒に変換
        let _year  = ( Int64( year! )!  * 31536000 )
        let _month = ( Int64( month! )! * 2592000 )
        let _day = ( Int64( day! )!  * 86400 )
        let _hour = ( Int64( hour! )!  * 3600 )
        let _mini = ( Int64( minute! )!  * 60 )
        ChoseTime =  ( (_year) + (_month) + (_day) + (_hour) + (_mini) )
        print("chose time : \( ChoseTime )")
        
    }
    
    // 時間取得
    internal func onDidChangeDate(sender: UIDatePicker){
        let myDateFormatter: NSDateFormatter = NSDateFormatter()
        myDateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let mySelectedDate: NSString = myDateFormatter.stringFromDate(sender.date)
        thisTimer.text = mySelectedDate as String
    }
    
    // ボタンイベント.
    internal func onClickMyButton( sender: UIButton ){
        switch( sender.tag ){
        case SAVE_ACT:
            
            let now = NSDate()
            let myCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!//カレンダーを取得
            let myComponetns = myCalendar.components( [.Year, .Month, .Day,.Hour,.Minute,.Second],fromDate: now )//取得するコンポーネントを決める
            //
            // 選択した時間を秒に変換
            let _year  = ( Int64( myComponetns.year )  * 31536000 )
            let _month = ( Int64( myComponetns.month) * 2592000 )
            let _day = ( Int64( myComponetns.day )  * 86400 )
            let _hour = ( Int64( myComponetns.hour )  * 3600 )
            let _mini = ( Int64( myComponetns.minute )  * 60 )
            let _sec = ( 60 - Int64( myComponetns.second ) )
            let timeNow : Int64 =  ( (_year) + (_month) + (_day) + (_hour) + (_mini) + ( _sec ) )
            print("timeNow :  \(timeNow)")
            //
            //let timeNow : Int64 = ( Int64( myComponetns.year * 31536000 ) + Int64( myComponetns.month * 2592000 ) + Int64( myComponetns.day  * 86400 ) + Int64( myComponetns.hour  * 3600 ) + Int64( myComponetns.minute  * 60 ) + Int64( 60 - myComponetns.second ) )
            if ( ChoseTime != nil ) {
                
            }else{
                ChoseTime = 0
            }
            // アラートがなるまでの時間を計算
            timer =   Double(  ChoseTime!   -  timeNow  )
            print("timer : \( timer )")
            
            // alrte dialog
            if timer < 0 {
                let myAlert: UIAlertController = UIAlertController(title: "過去の時間は設定できません", message: "時間を入れなおしてください", preferredStyle: .Alert)
                let myOkAction = UIAlertAction(title: "OK", style: .Default) { action in
                    print("Action OK!!")
                }
                myAlert.addAction( myOkAction )
                presentViewController( myAlert, animated: true, completion: nil)
                return
            }
            if myTextField.text! == ""{
                let titleAlert: UIAlertController = UIAlertController(title: "タイトルがありあせん", message: "タイトルをいれてください", preferredStyle: .Alert)
                let myOkAction = UIAlertAction(title: "OK", style: .Default) { action in
                    print("Action OK!!")
                }
                titleAlert.addAction(myOkAction)
                presentViewController(titleAlert, animated: true, completion: nil)
                return
            }
            
            let saveAlert: UIAlertController = UIAlertController(title: "Save完了", message: "敵が作られた", preferredStyle: .Alert)
            let myOkAction = UIAlertAction(title: "OK", style: .Default) { action in
                print("save!!")
            }
            saveAlert.addAction( myOkAction )
            presentViewController(saveAlert, animated: true, completion: nil)
            
            let ran = ( Int )( arc4random_uniform( 7 ) )
            todoItem.insert( "\( myTextField.text! )", atIndex: 0 )
            todoImage.insert( imgArray[ran] as! String, atIndex: 0 )
            todoTime.insert( "\(thisTimer.text!)", atIndex: 0 )
            //
            let notif = UILocalNotification()
            // アラートがなるまでの時間を指定
            notif.fireDate = NSDate( timeIntervalSinceNow: timer )
            notif.timeZone = NSTimeZone.defaultTimeZone()
            notif.alertBody = " \(myTextField.text! )の時間です"
            notif.alertAction = "OK"
            notif.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notif)
            myTextField.text = ""
            // 保存
            NSUserDefaults.standardUserDefaults().setObject( todoItem, forKey: "todoLists" )
            NSUserDefaults.standardUserDefaults().setObject( todoImage, forKey: "todoImages" )
            NSUserDefaults.standardUserDefaults().setObject( todoTime, forKey: "todoTimes" )
            print("SAVE")
            
        case SCREEN_TRANS:
            self.view.backgroundColor = UIColor.redColor()
            let viewController = ViewController()
            // アニメーションを設定する.
            viewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
            //self.navigationController?.pushViewController(viewController, animated: true)
        default:
            print("error")
        }
    }
    
    // キーボード以外をタッチするとキーボードが下がる機能
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing( true )
    }
    
    // キーボードのreturnを押下すると、キーボードが下がる機能
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        myTextField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

