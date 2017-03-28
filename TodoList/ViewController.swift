import UIKit
// Gloabal
let swingAnim : [String] = ["yusyaS", "red2S","yusya3S", "yusya4S"]
let walkAnim : [String] = ["yusya_walk", "yusya2_s", "yusya3S_walk", "yusya4_s"]
let damageAnim : [String] = ["flash","flash_r", "flash3_s", "flash_w"]
let WAIT_ANIM = 1
let BUTTLE_ANIM = 2
var moveState = 0
var myLebel : Int = 1
var todoCount : Int = 0
var itemArray = [String]()
var _ex : Float = 0
//

class ViewController: UIViewController,UITableViewDelegate {
    // ---- Fiald -----
    @IBOutlet weak var bikkuri: UIImageView!
    @IBOutlet weak var lebel: UILabel!
    @IBOutlet weak var player: UIImageView!
    @IBOutlet weak var exBar: UIProgressView!
    @IBOutlet weak var todolistTable:UITableView!
    @IBOutlet weak var ItemBox: UIButton!
    @IBOutlet weak var boss_time: UILabel!
    @IBOutlet weak var underView: UIView!
    @IBOutlet weak var bossTime: UILabel!
   
        // Player change images Array
    var styleArray : NSArray = ["yuusha.png","yusya2.png","yusya3.png","yusya4.png",
        "enemy5.png","enemy6.png","enemy7.png"]
    var nameArray : [String] = ["ゆうしゃ","あかいゆうしゃ","カンダタ","でんせつのゆうしゃ","ヘラ","どっぺる","ぴったん"]
    var contentsArray : [String] = ["てきが持っている仲間の魂\nをとりかえすため旅に出た\nゆうしゃ。\n","いかりで我をわすれてあば\nれまわっていたら自身が\n真っ赤になっていた","あくりょく：２００ｋｇ\nたいじゅう：１５０ｋｇ\nさいきんふとりすぎなのがなやみ","ぶきやに”そんな装備で大丈夫か？”といわれたが”大丈夫だ”とことわりやられたでんせつのゆうしゃ","まおうのつぎにつよいあくま。\nゆうしゃにたべものをもらい、なかまになった","だれかの影がいつの間にかじりつしてうごきはじめたことにより生まれたあくま。\nかげがないといきていけない。","ふくすうのぶろっくがあわさってできたあくま。\n"]
    // Compornents
    var imageViews = [UIImageView]()
    var itemViews = [UIButton]()
    var blackBack : UIImageView!
    var image = UIImageView(frame: CGRectMake( 0, 0, 100, 100 ) )
    var textlabel : UILabel = UILabel(frame: CGRectMake( 0, 0, 250, 30 ) )
    var contentsLabel : UITextView = UITextView(frame: CGRectMake( 0, 0, 160, 130 ) )
    //var selectedImage: UIImage?
    var itemView : UIView!
    var todoCounts : UILabel = UILabel(frame:CGRectMake( 0, 0 , 150, 50 ))
    //　Boss Clock
    var now = NSDate()
    var bossDay : Int = 6
    var bossHour : Int = 23
    var bossMinitsu : Int = 59
    var bossSec : Int = 60
    // Save Clock
    var saveDay : Int!
    var saveHour : Int!
    var saveMinitsu : Int!
    var saveScecound : Int!
    var saveMonth : Int!
    //
    let width = UIScreenSize.screenWidth()
    let height = UIScreenSize.screenHeight()
    let Count_Interval : NSTimeInterval = 1;
    let Main_Interval : NSTimeInterval = 0.5;
    var boxOpen : Bool = false
    var boxAnim : Bool = false
    var state = WAIT_ANIM
    var count : Int = 0
    var enemyCount : Int = 0
    var nameState : Int = 0
    var timeCounter : Int = 0
    var animd : Bool = false
    var item_drop : UInt32 = 1
    var item_hit : UInt32 = 0
    // ------    -------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ss : \(UIScreenSize.widthContrast()) sh : \(UIScreenSize.heightContrast())")
        bossTimeResult()
        var timer = NSTimer()
        timer = NSTimer.scheduledTimerWithTimeInterval( Count_Interval, target: self, selector: "onUpdate:", userInfo: nil, repeats: true )
        timer.fire()
        //----      -----
        
        todoCounts.text  = "\( todoCount )" + "個"
        todoCounts.textAlignment = NSTextAlignment.Center
        
        lebel.text =  "\( myLebel )" + "F"
        exBar.progressTintColor = UIColor.greenColor()
        exBar.trackTintColor = UIColor.whiteColor()
        
        // Viewの作成
        itemView = UIView( frame: CGRectMake( 0, 0, self.view.frame.width, 400 ) )
        itemView.backgroundColor = UIColor.blackColor()
        //itemView.alpha = 0.1
        itemView.layer.masksToBounds = true
        itemView.layer.position = CGPointMake( self.view.frame.width / 2, self.view.frame.height / 2 - 20 )
        itemView.hidden = true
        blackBack = UIImageView( frame:CGRectMake( 0, 0, self.itemView.frame.width, self.itemView.frame.height ) )
        blackBack.image = UIImage( named : "itemBack.png" )
        self.itemView.addSubview( blackBack )
        self.view.addSubview( todoCounts )
        
        // tableView BackGround color
        let imageView = UIImageView( frame : CGRectMake( 0, 0, self.todolistTable.frame.width, self.todolistTable.frame.height ) )
        imageView.image = UIImage( named: "back_Todo.png" )
        imageView.alpha = 1.0
        self.todolistTable.backgroundView = imageView
        self.todolistTable.separatorColor = UIColor.clearColor()

        // ---- 保存したものを取り出す ----
        if NSUserDefaults.standardUserDefaults().objectForKey("todoImages") != nil {
            todoImage = NSUserDefaults.standardUserDefaults().objectForKey("todoImages") as! [String]
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("todoLists") != nil {
            todoItem = NSUserDefaults.standardUserDefaults().objectForKey("todoLists") as! [String]
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("todoTimes") != nil {
            todoTime = NSUserDefaults.standardUserDefaults().objectForKey("todoTimes") as! [String]
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("_ex") != nil {
            _ex = NSUserDefaults.standardUserDefaults().objectForKey("_ex") as! Float
            exBar.progress = _ex
            exBar.setProgress(_ex, animated: true)
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("todoCount") != nil {
            todoCount = NSUserDefaults.standardUserDefaults().objectForKey("todoCount") as! Int
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("myLebel") != nil {
            myLebel = NSUserDefaults.standardUserDefaults().objectForKey("myLebel") as! Int
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey("moveState") != nil {
            moveState = NSUserDefaults.standardUserDefaults().objectForKey("moveState") as! Int
        }

        // -- アイテムボックス --
        if NSUserDefaults.standardUserDefaults().objectForKey("itemArray") != nil {
            itemArray = NSUserDefaults.standardUserDefaults().objectForKey("itemArray") as! [String]
            print("itemArray : \(itemArray)")
            // item
            for i in 0 ..< itemArray.count{
                let itemImg = UIImage(named: "\(itemArray[i])")
                let itemImgView = UIButton(frame:CGRectMake( 0, 0, 30, 30 ) )
                itemImgView.setImage(itemImg, forState: .Normal )
                itemViews.append(itemImgView)
                itemViews[i].layer.position = CGPoint(x: CGFloat(itemImgView.frame.width/2 + 15) + CGFloat(i * 40), y: self.itemView.frame.height/2 + 10 )
                itemViews[i].userInteractionEnabled = true
                // tag 設定
                if itemArray[i] == "yuusha.png"{
                    itemViews[i].tag =  1
                }else if itemArray[i] == "yusya2.png"{
                    itemViews[i].tag =  2
                }else if itemArray[i] == "yusya3.png"{
                    itemViews[i].tag =  3
                }else if itemArray[i] == "yusya4.png"{
                    itemViews[i].tag =  4
                }else if itemArray[i] == "enemy5.png"{
                    itemViews[i].tag =  5
                }else if itemArray[i] == "enemy6.png"{
                    itemViews[i].tag =  6
                }else if itemArray[i] == "enemy7.png"{
                    itemViews[i].tag =  7
                }
                itemViews[i].addTarget(self, action: "selectDress:", forControlEvents: .TouchUpInside)
                
                itemView.insertSubview(itemViews[i], aboveSubview: blackBack)
            }
        }

        // -----        -----
        
        // アイテムイメージ
        image.layer.position = CGPoint( x : self.itemView.frame.width / 2 + 80, y : self.itemView.frame.height / 2 + 120  )
        image.image = UIImage( named : "yuusha.png" )
        self.itemView.addSubview( image )
        // アイテムボックスにあるアイテムの名前
        textlabel.text = nameArray[ nameState ]
        textlabel.layer.position = CGPoint( x : 150, y : 50 )
        textlabel.textColor = UIColor.whiteColor()
        self.itemView.addSubview( textlabel )
        contentsLabel.text = contentsArray[ 0 ]
        contentsLabel.layer.position = CGPoint( x : 100, y : self.itemView.frame.height / 2 + 120 )
        contentsLabel.backgroundColor = UIColor.clearColor()
        contentsLabel.textColor = UIColor.whiteColor()
        contentsLabel.font = UIFont.systemFontOfSize( 12 )
        contentsLabel.textAlignment = NSTextAlignment.Left
        self.itemView.addSubview( contentsLabel )
        //
        // -- Main update. --
        NSTimer.scheduledTimerWithTimeInterval( Main_Interval, target: self, selector: "update:", userInfo: nil, repeats: true )
        // アイテムボックスボタン
        ItemBox.addTarget( self, action: "openItemBox:", forControlEvents: .TouchUpInside )
        // itemViewをviewに追加.
        self.view.addSubview( itemView )
    }
    
    // アイテムボックス内にあるスタイルを選んだ場合
    internal func selectDress( sender : UIButton ){
        if sender.tag == 1 {
            moveState = 0
        }else if sender.tag == 2{
            moveState = 1
        }else if sender.tag == 3{
            moveState = 2
        }else if sender.tag == 4{
            moveState = 3
        }
        nameState = sender.tag - 1
        // moveStateを保存
        NSUserDefaults.standardUserDefaults().setObject( moveState, forKey: "moveState" )
        image.image = sender.imageView!.image!
        textlabel.text = nameArray[ nameState ]
        contentsLabel.text = contentsArray[ nameState ]
    }
    
    // ---- Timer Count ----
    func onUpdate(timer : NSTimer){
        bossSec-- //残り時間＝現在時刻ー現在時刻に１時間足した時刻
        if bossSec <= 0{
            bossSec = 60
            bossMinitsu--
        }
        if bossMinitsu <= 0 {
            bossHour--
            bossMinitsu = 60
        }
        if bossHour <= 0{
            bossDay--
            bossHour = 12
        }
        if bossDay < 0{
            bossDay = 7
        }
        //print("ボスタイマー　：　\(bossDay) 日　\(bossHour)時 \(bossMinitsu)分 \(bossSec)秒")
        bossTime.text = "\(bossDay)D \(bossHour)H \(bossMinitsu)M"
    }
    
    // 宝箱をおした時
    func openItemBox(sender: UIButton) {
        // flagがfalseならmyViewを表示.
        boxAnim = false
        if !boxOpen {
            // myViewを表示.
            itemView.hidden = false
            boxOpen = true
        }
        // flagがtrueならmyViewを非表示.
        else {
            // myViewを非表示.
            itemView.hidden = true
            boxOpen = false
        }
    }
    
    // Player Animations
    func walk() -> Array<UIImage>{
        var theArray = Array<UIImage>()
        for num in 1 ... 2 {
            let imageName = walkAnim[ moveState ] + String( num )
            let image = UIImage( named : "\( imageName )" )
            theArray.append( image! )
        }
        return theArray
    }
    func swing() -> Array<UIImage>{
        var theArray = Array<UIImage>()
        for num in 1 ... 5 {
            let imageName = swingAnim[ moveState ] + String( num )
            let image = UIImage( named : "\( imageName )" )
            theArray.append( image! )
        }
        return theArray
    }
    func levelup()  -> Array<UIImage>{
        var theArray = Array<UIImage>()
        for num in 1 ... 4 {
            let imageName = " yusyaA " + String( num )
            let image = UIImage( named : "\( imageName )" )
            theArray.append( image! )
        }
        return theArray
    }
    func damage() -> Array<UIImage>{
        var theArray = Array<UIImage>()
        for num in 1 ... 4 {
            let imageName = damageAnim[ moveState ] + String( num )
            let image = UIImage( named : "\( imageName )" )
            theArray.append( image! )
        }
        return theArray
    }

    // tableview cell count
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem.count
    }
    
    // cellに値を入れる
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> (UITableViewCell){
        let cell = todolistTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let image = UIImage( named: "\( todoImage[ indexPath.row ] )" )
        let imageViews = UIImageView( frame : CGRectMake( 0, 0, self.todolistTable.frame.width, self.todolistTable.frame.height ) )
        imageViews.image = UIImage( named : "cell_back.png" )
        imageViews.alpha = 1.0
        cell.backgroundView = imageViews
        let labelTitle = todolistTable.viewWithTag( 2 ) as! UILabel
        labelTitle.text = todoItem[ indexPath.row ]
        let imageView = todolistTable.viewWithTag( 3 ) as! UIImageView
        imageView.image = image
        let labelTime = todolistTable.viewWithTag( 4 ) as! UILabel
        labelTime.text = todoTime[ indexPath.row ]
        return cell
    }
    
    // TableView Deleate
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == UITableViewCellEditingStyle.Delete{
            state = BUTTLE_ANIM
            let image = UIImage( named: "\( todoImage[ indexPath.row ] )")
            let enemyImage = UIImageView(frame: CGRect( x : width, y : Int( self.player.layer.position.y ) , width : 45, height : 45 ) )
            enemyImage.image = image
            imageViews.append( enemyImage )
            self.view.addSubview( enemyImage )
            // enmey Animation
            UIView.animateWithDuration(
                0.5,
                delay: 0,
                options:[ UIViewAnimationOptions.CurveEaseIn ],
                animations: {() -> Void in
                     self.player.layer.position.x = self.view.frame.width
                     enemyImage.layer.position.x = self.view.frame.width / 2
                },completion: {( Bool ) -> Void in
                     self.allAnim( enemyImage )
                    
                }
            )
            todoCount++
            // Delete
            todoItem.removeAtIndex( indexPath.row )
            todoImage.removeAtIndex( indexPath.row )
            todoTime.removeAtIndex( indexPath.row )
            //保存
            NSUserDefaults.standardUserDefaults().setObject( todoItem, forKey : "todoLists" )
            NSUserDefaults.standardUserDefaults().setObject( todoImage, forKey : "todoImages" )
            NSUserDefaults.standardUserDefaults().setObject( todoTime, forKey : "todoTimes" )
            NSUserDefaults.standardUserDefaults().setObject( todoCount, forKey : "todoCount" )
            todolistTable.reloadData()
        }
    }
    // cell が選択された時
    func tableView( table: UITableView, didSelectRowAtIndexPath indexPath : NSIndexPath ) {
        
    }
    
    // --- Update ( Main ) ----
    func update( timer : NSTimer ){
        lebel.text = "\( myLebel )" + "F"
        todoCounts.text  = "\( todoCount )" + "個"
        // 秒カウント
        timeCounter++
        if timeCounter >= 2{
            // ボックスが開いた時
            if boxAnim {
                UIView.animateWithDuration(
                    0.8,
                    delay: 0,
                    options:[
                        UIViewAnimationOptions.Repeat],
                    animations: {
                        self.bikkuri.alpha = 1.0
                    },completion: nil
                )
            }else {
                self.bikkuri.layer.removeAllAnimations()
                self.bikkuri.alpha = 0
            }
            timeCounter = 0
            // ToDoの時間になった時
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let string = formatter.stringFromDate( now )
            
            for i in 0 ..< todoTime.count{
                if ( string == todoTime[ i ] ) && !animd{
                    let image = UIImage( named: "\( todoImage[ i ] )" )
                    let enemyImage = UIImageView( frame : CGRect( x : 350, y : 441, width : 45, height : 45 ) )
                    enemyImage.image = image
                    self.view.addSubview( enemyImage )
                    animd = true
                    UIView.animateWithDuration(
                        0.5,
                        delay: 0,
                        options:[ UIViewAnimationOptions.CurveEaseIn ],
                        animations: {
                            enemyImage.layer.position.x = self.view.frame.width / 2 - 30
                        },completion: {(Bool) -> Void in
                            enemyImage.removeFromSuperview()
                            self.player.animationDuration = (0.5)
                            self.player.animationImages = self.damage()
                            self.player.animationRepeatCount = 0
                            self.player.startAnimating()
                            if _ex <= 0 && myLebel <= 1{
                                _ex = 0
                                myLebel = 1
                            }else{
                                _ex -= 0.1
                                if _ex <= 0 && myLebel > 1  {
                                    myLebel--
                                    _ex = 0.9
                                }
                            }
                            self.exBar.progress = _ex
                            self.exBar.setProgress(_ex, animated: true)
                            NSUserDefaults.standardUserDefaults().setObject(_ex, forKey: "_ex")
                            NSUserDefaults.standardUserDefaults().setObject(myLebel, forKey: "myLebel")
                            self.animd = false
                    })
                    state = WAIT_ANIM
                }
            }
            
        }
        
        switch state {
            case WAIT_ANIM:           // Walk
                player.animationRepeatCount = 0
                player.animationDuration = NSTimeInterval( 0.5 )
                player.animationImages = walk()
                player.startAnimating()
            break
            case BUTTLE_ANIM:         //Buttle
                player.animationDuration = ( 0.5 )
                player.animationImages = swing()
                player.animationRepeatCount = 0
                player.startAnimating()
            break
            default:
            break
        }
    }
    // Tablebview Reload
    override func viewDidAppear( animated: Bool ) {
        todolistTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Animation
    func allAnim( thisView : UIImageView ){
        let scale = CGAffineTransformMakeScale( 1.5, 1.5 )
        let rotation = CGAffineTransformMakeRotation( CGFloat( M_PI ) )
        let transform = CGAffineTransformConcat( scale, rotation )

        UIView.animateWithDuration(
            0.5,
            delay: 0,
            options:[ UIViewAnimationOptions.CurveEaseIn ],
            animations: {
                thisView.transform = transform
                thisView.layer.position.x = self.view.frame.width + 50
                thisView.layer.position.y =  thisView.layer.position.y - 50
            },completion:{(Bool) -> Void in
                self.state = WAIT_ANIM
                // Enemy Dead
                thisView.removeFromSuperview()
                // EX Get
                let image = UIImage( named: "right.png" )
                let right = UIImageView( frame: CGRectMake( 300, 450, 50, 50 ) )
                right.image = image
                self.view.addSubview( right )
                UIView.animateWithDuration(
                    1.0,
                    delay: 0,
                    options:[ UIViewAnimationOptions.CurveEaseIn ],
                    animations: {
                        right.layer.position = CGPointMake( self.exBar.layer.position.x, CGFloat( self.height ) )
                    },completion:{(Bool) -> Void in
                        right.removeFromSuperview()
                        // Item Get ( random )
                        let ran = arc4random_uniform( self.item_drop )
                        print("ran : \( ran )")
                        _ex += 0.1
                        print( "ex : \( _ex )" )
                        // Ex Max ?
                        if _ex >= 1.0 {
                            _ex = 0.0
                            myLebel++
                            //
                            let levelUpImage = UIImage( named:"lebelup.png" )
                            let levelView = UIImageView( frame: CGRectMake( 120, 500, 60, 60 ) )
                            levelView.image = levelUpImage
                            
                            self.view.addSubview(levelView)
                            UIView.animateWithDuration(
                                1.0,
                                delay: 0,
                                options:[ UIViewAnimationOptions.CurveEaseIn ],
                                animations: {
                                    levelView.layer.position = CGPointMake( self.view.frame.width / 2, 450 )
                                    levelView.alpha = 0
                                },completion:{(Bool) -> Void in
                                    levelView.removeFromSuperview()
                            })
                            
                        }
                        self.exBar.progress = _ex
                        self.exBar.setProgress(_ex, animated: true)
                        NSUserDefaults.standardUserDefaults().setObject(_ex, forKey: "_ex")
                        NSUserDefaults.standardUserDefaults().setObject(myLebel, forKey: "myLebel")
                        let styRan = arc4random_uniform(UInt32( self.styleArray.count ) )
                        print("styRan : \(styRan)")
                        
                        // --- Item Drop ---
                        if ran == self.item_hit {
                            // This Item Has ? Yes : Run
                            for i in 0 ..< itemArray.count{
                                if itemArray[i] == self.styleArray[Int(styRan)] as! String{
                                    return
                                }
                            }
                            let itemRightImg = UIImage(named: "itemRight.png")
                            let itemRight = UIImageView(frame: CGRectMake( 300, 400, 50, 50 ))
                            itemRight.image = itemRightImg
                            self.view.addSubview( itemRight )
                            UIView.animateWithDuration(
                                1.0,
                                delay: 0,
                                options:[UIViewAnimationOptions.CurveEaseIn],
                                animations: {
                                    itemRight.layer.position = CGPoint( x: self.width, y: self.height / 2 )
                                },completion: {(Bool) -> Void in
                                    itemRight.removeFromSuperview()
                                    itemArray.append(self.styleArray[Int(styRan)] as! String)
                                    print("itemArray : \(itemArray)")
                                    let itemImg = UIImage(named: "\(itemArray[ itemArray.count - 1 ])")
                                    let itemImgView = UIButton( frame : CGRectMake( 0, 0, 30, 30 ) )
                                    itemImgView.setImage( itemImg, forState : .Normal )
                                    self.itemViews.append( itemImgView )
                                    self.itemViews.last!.layer.position = CGPoint( x : CGFloat( itemImgView.frame.width / 2 + 15 ) + CGFloat( ( self.itemViews.count - 1 )  * 40 ), y: self.itemView.frame.height / 2 + 10 )
                                    self.itemViews[ self.itemViews.count - 1 ].userInteractionEnabled = true
                                    // Tag Config
                                    if itemArray[self.itemViews.count - 1] == "yuusha.png"{
                                        self.itemViews[self.itemViews.count - 1].tag =  1
                                    }else if itemArray[self.itemViews.count - 1] == "yusya2.png"{
                                        self.itemViews[self.itemViews.count - 1].tag =  2
                                    }else if itemArray[self.itemViews.count - 1] == "yusya3.png"{
                                        self.itemViews[self.itemViews.count - 1].tag =  3
                                    }else if itemArray[self.itemViews.count - 1] == "yusya4.png"{
                                        self.itemViews[self.itemViews.count - 1].tag =  4
                                    }else if itemArray[self.itemViews.count - 1] == "enemy5.png"{
                                        self.itemViews[self.itemViews.count - 1].tag =  5
                                    }else if itemArray[self.itemViews.count - 1] == "enemy6.png"{
                                        self.itemViews[self.itemViews.count - 1].tag =  6
                                    }else if itemArray[self.itemViews.count - 1] == "enemy7.png"{
                                        self.itemViews[self.itemViews.count - 1].tag =  7
                                    }
                                    self.itemViews[self.itemViews.count - 1].addTarget( self, action: "selectDress:", forControlEvents: .TouchUpInside )
                                    self.itemView.addSubview( self.itemViews[ self.itemViews.count - 1 ] )
                                    self.itemView.bringSubviewToFront( self.itemViews[ self.itemViews.count - 1 ] )
                                    self.boxAnim = true
                                    // ItemArray Save
                                    NSUserDefaults.standardUserDefaults().setObject( itemArray, forKey: "itemArray" )
                                }
                            )
                            
                        }
                    }
                )
            }
        )
    }
    
    //
    func bossTimeResult(){
        // ---- Boss 出現までの時間 ----
        let myCalendar: NSCalendar = NSCalendar( calendarIdentifier : NSCalendarIdentifierGregorian )!
        let myComponents = myCalendar.components( [ .Year, .Hour, .Day, .Minute, .Second ],
            fromDate: now )
        // 終了した時間を取り出す
        if NSUserDefaults.standardUserDefaults().objectForKey( "saveDay" ) != nil {
            saveMonth = NSUserDefaults.standardUserDefaults().objectForKey( "saveMonth" ) as! Int
            saveDay = NSUserDefaults.standardUserDefaults().objectForKey( "saveDay" ) as! Int
            saveHour = NSUserDefaults.standardUserDefaults().objectForKey( "saveHour" ) as! Int
            saveMinitsu = NSUserDefaults.standardUserDefaults().objectForKey( "saveMin" ) as! Int
            saveScecound = NSUserDefaults.standardUserDefaults().objectForKey( "saveSec" ) as! Int
            // 日
            if saveDay > myComponents.day {
                if saveMonth != 3 && saveMonth != 5 && saveMonth != 7 && saveMonth != 10 && saveMonth != 12{
                    bossDay = myComponents.day + 31 - saveDay
                }else{
                    bossDay = myComponents.day + 30 - saveDay
                }
            }else{
                bossDay = myComponents.day - saveDay
            }
            // 時
            if saveHour > myComponents.hour {
                bossHour = myComponents.hour + 24 - saveHour
            }else{
                bossHour = myComponents.hour - saveHour
            }
            // 分
            if saveMinitsu > myComponents.minute{
                bossMinitsu = myComponents.minute + 60 - saveMinitsu
            }else{
                bossMinitsu = myComponents.minute - saveMinitsu
            }
            // 秒
            if saveScecound > myComponents.second{
                bossSec = myComponents.second + 60 - saveScecound
            }else{
                bossSec = myComponents.second - saveScecound
            }
            print("経過時間　：　\( bossDay )日\( bossHour )時 \( bossMinitsu )分 \( bossSec )秒 )")
            
        }
    }
}

