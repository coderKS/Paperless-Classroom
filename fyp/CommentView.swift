//
//  CommentView.swift
//  fyp
//
//  Created by Ka Hong Ngai on 7/11/2016.
//  Copyright © 2016 IK1603. All rights reserved.
//

import UIKit

class CommentView: UIImageView {
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  var selectedComment: String = "Ngai Ka Hong"
  let width:CGFloat = 200
  let height:CGFloat = 30
  
  //List of comments
  var comments = [UITextView]()
  var textView:UITextView?
  
  var view: UITextView?
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first?.location(in: self)
    drawComment(touch!.x, touch!.y)
  }
  
  func setComment(_ comment: String){
    self.selectedComment = comment
  }
  
  func drawComment(_ x: CGFloat, _ y:CGFloat){
    //Draw the comment and attach it to the view
    textView = UITextView(frame: CGRect(x: x - width / 2, y: y - height / 2, width: width, height: height))
    textView?.isSelectable = false
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(dragged))
    textView?.addGestureRecognizer(gesture)
    textView?.isUserInteractionEnabled = true
    textView?.backgroundColor = UIColor.cyan
    textView?.layer.cornerRadius = 10
    textView?.layer.borderWidth = 2
    textView?.layer.borderColor = UIColor.cyan.cgColor
    textView?.text = selectedComment
    textView?.textAlignment = .center
    //Attach to the view
    self.addSubview(textView!)
    
    //Append to comments array for saving purpose
    comments.append(textView!)
    
    //Utilize the undo manager to manage the manipulation
    self.undoManager?.registerUndo(withTarget: self, selector: #selector(undo), object: textView!)
  }
  
  func dragged(gesture: UIPanGestureRecognizer){
    let loc = gesture.location(in: self)
    
    if gesture.state == .changed {
      if view != nil {
        view?.center = loc
      } else if let selected = hitTest(loc, with: nil) as? UITextView {
        selected.center = loc
        view = selected
      }
    } else if gesture.state == .ended {
      view = nil
    }
  }
  
  func undo(_ textView: UITextView){
    //Register redo
    undoManager?.registerUndo(withTarget: self, selector: #selector(redo), object: textView)
    
    //Remove it
    textView.removeFromSuperview()
  }
  
  func redo(_ textView: UITextView){
    //Register undo
    undoManager?.registerUndo(withTarget: self, selector: #selector(undo), object: textView)
    
    //Add it
    self.addSubview(textView)
  }
  
  func done(){
    //Clear all temp entry
    comments = []
  }
  
  func cancel(){
    //Remove all temp entries
    for comment in comments {
      comment.removeFromSuperview()
    }
    //Clear all temp entry
    comments = []
    //Cancel
  }
  
}
