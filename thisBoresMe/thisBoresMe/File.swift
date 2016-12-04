// import UIKit
// var commentuuid = [String]()
// var commentowner = [String]()
// class commentVC: UIViewController {
//    
//    
//    
//    // UI Objects
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var commentTxt: UITextView!
//    @IBOutlet weak var sendBtn: UIButton!
//    var refresh = UIRefreshControl()
//    
//    // values for resetting Uito default
//    var tableViewHeight : CGFloat = 0
//    var commentY : CGFloat = 0
//    var commentHeight : CGFloat = 0
//    
//    // varible to hold keyboard frame
//    var keyboard = CGRect()
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.backgroundColor = .redColor()
//        
//        // self.tabBarController?.tabBar.hidden = true
//        
//        // title at the top
//        self.navigationItem.title = "Comments"
//        self.navigationItem.hidesBackButton = true
//        let backBtn = UIBarButtonItem(title: "back", style: .Plain, target: self, action: #selector(commentVC.back(_:)))
//        self.navigationItem.leftBarButtonItem = backBtn
//        
//        
//        
//        
//        let hideTap = UITapGestureRecognizer(target: self, action: #selector(commentVC.hideKeyboardTap(_:)))
//        hideTap.numberOfTapsRequired = 1
//        self.view.userInteractionEnabled = true
//        self.view.addGestureRecognizer(hideTap)
//        
//        // swipe to go back
//        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(commentVC.back(_:)))
//        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
//        self.view.addGestureRecognizer(backSwipe)
//        
//        // catch notifcation if the keyboard is shown or hidden
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(commentVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(commentVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
//        
//        // disable keyboard
//        sendBtn.enabled = false
//        
//        
//        
//        alignment()
//        
//    }
//    
//    func hideKeyboardTap(recongnizer: UITapGestureRecognizer) {
//        commentTxt.endEditing(false)
//        return viewDidLoad()
//        
//    }
//    
//    
//    
//    // preload function
//    override func viewWillAppear(animated: Bool) {
//        
//        // hide bottom bar
//        self.tabBarController?.tabBar.hidden = true
//        
//        // call keyboard
//        commentTxt.becomeFirstResponder()
//        
//    }
//    
//    // post load function
//    override func viewWillDisappear(animated: Bool) {
//        self.tabBarController?.tabBar.hidden = false
//    }
//    
//    
//    
//    // func loading when keyboard is shown
//    func keyboardWillShow(notification : NSNotification) {
//        
// 
// // define keyboard frame size
// keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
// 
// // move UI up
// UIView.animateWithDuration(0.4) { () -> Void in
//    
//    self.tableView.frame.size.height = self.tableViewHeight - self.keyboard.height - self.commentTxt.frame.size.height + self.commentHeight
//    
//    self.commentTxt.frame.origin.y = self.commentY - self.keyboard.height - self.commentTxt.frame.size.height + self.commentHeight
//    
//    self.sendBtn.frame.origin.y = self.commentTxt.frame.origin.y
//    
//    
//    
//    
//    
//    
// }
// }
// 
// 
// func keyboardWillHide(notification : NSNotification) {
//    
//    // move UI down
//    UIView.animateWithDuration(0.4) { () -> Void in
//        self.tableView.frame.size.height = self.tableViewHeight
//        self.commentTxt.frame.origin.y = self.commentY
//        self.sendBtn.frame.origin.y = self.commentY
//        
//        
//    }
// }
// // alignment function
// func alignment()  {
//    
//    let width = self.view.frame.size.width
//    let height = self.view.frame.size.height
//    
//    
//    tableView.frame = CGRectMake(0, 0, width, height / 1.096 - self.navigationController!.navigationBar.frame.size.height - 20)
//    tableView.estimatedRowHeight = width / 5.333
//    tableView.rowHeight = UITableViewAutomaticDimension
//    
//    
//    
//    commentTxt.frame = CGRectMake(10, tableView.frame.size.height + height / 56.8, width / 1.306, 33)
//    commentTxt.layer.cornerRadius = commentTxt.frame.size.width / 50
//    
//    sendBtn.frame = CGRectMake(commentTxt.frame.origin.x + commentTxt.frame.size.width + width / 32, commentTxt.frame.origin.y,
//                               width - (commentTxt.frame.origin.x + commentTxt.frame.size.width) - (width / 32) * 2, commentTxt.frame.size.height)
//    
//    
//    // assign reseting values
//    tableViewHeight = tableView.frame.size.height
//    commentHeight = commentTxt.frame.size.height
//    commentY = commentTxt.frame.origin.y
//    
// }
// 
// 
// // go back
// func back(sender : UIBarButtonItem) {
//    
//    // push back
//    self.navigationController?.popViewControllerAnimated(true)
//    
//    // clean comment uui from last holding information
//    if !commentuuid.isEmpty {
//        commentuuid.removeLast()
//        
//        
//        // clean comment owner from last holding information
//        if !commentowner.isEmpty {
//            commentowner.removeLast()
//        }
//        
//    }
//    
// }
// 
// 
// }