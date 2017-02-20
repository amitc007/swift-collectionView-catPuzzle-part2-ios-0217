//
//  PuzzleCollectionViewController.swift
//  CollectionViewCatPicPuzzle
//
//  Created by Joel Bell on 10/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var headerResuableView:HeaderReusableView!
    var footerResuableView:FooterReusableView!
    
    var itemSize: CGSize!
    var spacing: CGFloat!
    var sectionInsets: UIEdgeInsets!
    var referenceSize: CGSize!
    var numberOfRows: CGFloat!
    var numberOfColumns: CGFloat!
    
    var imageSlices:[UIImage] = [], correctImage:[UIImage] = []
    
    var puzzleTimer = PuzzleTimer()
    
    //move timer
    var firstMove:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///***Add supplementary views
        //1.add/register supplementary views
        collectionView?.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
        collectionView?.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        
        configureLayout()
        
        for cnt in 0...11 {
            imageSlices.append(UIImage(named: String(cnt+1))!)
            
        }
        correctImage = imageSlices
        
        let img = imageSlices[11]
        imageSlices[11] = imageSlices[10]
        imageSlices[10] = img
        //randomize
      /*  for idx in  0...imageSlices.count/2 {
           let newIdx = Int(arc4random_uniform(UInt32(imageSlices.count/2))+UInt32(imageSlices.count/2))
            let img = imageSlices[idx]
            imageSlices[idx] = imageSlices[newIdx]
            imageSlices[newIdx] = img
        } */
        print("Exiting viewDidLoad")
    }
    
    //2.add data source for supplementary view
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("Entered viewForSupplementaryElementOfKind")
        
        if kind == UICollectionElementKindSectionHeader {
            headerResuableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderReusableView
            
            print("added data s for header")
            
            return headerResuableView
        } else {
            footerResuableView =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as! FooterReusableView
            print("added data s for footer")
            
            footerResuableView.configureView(timerLabel: puzzleTimer.timerLabel)
            print("puzzleTimer:\(puzzleTimer.timerLabel.description)")
            
            return footerResuableView
        }
    }
    
    
    //3.configure layout methods
    func configureLayout() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        numberOfRows = 4
        numberOfColumns = 3
        spacing = 2
        sectionInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        referenceSize = CGSize(width: width, height: 60)
        //itemWidth = screenSize/cols - itemSpacing - 2*insets(left & right)
        let itemWidth = (width/numberOfColumns) - spacing*(numberOfColumns - 1) - 2*spacing
        let itemHeight = height/numberOfRows - spacing*(numberOfRows-1) - 2*spacing
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    ///***methods called by colection view to get values for configuring layout
    //1) itemsize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    //2a)spacing bet lines
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    //2b)spacing bet items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    //3) insets i.e margins
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    //4a)header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        print("header referenceSize")
        return referenceSize
    }
    
    //4b)footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        print("footer referenceSize")
        return referenceSize
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSlices.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "puzzleCell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = imageSlices[indexPath.row]
        
        return cell
        
    }
    
    ///***Move images
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //code
        if firstMove {
            firstMove = false
            print("Called moveItemAt")
            //footerResuableView.startTimer() //crashes as footer initializes later
            puzzleTimer.startTimer()
        }
        if (footerResuableView != nil) {
            print("puzzleTimer:\(puzzleTimer.timerLabel.description)")
        }
        
        //change image array
        self.collectionView?.performBatchUpdates({
            
            // reorder the imageSlices array here
            let img = self.imageSlices[destinationIndexPath.row]
            self.imageSlices[destinationIndexPath.row] = self.imageSlices[sourceIndexPath.row]
            self.imageSlices[sourceIndexPath.row] = img
            
        }, completion: { completed in
            
            // 1. Check for winning scenario
            if self.imageSlices != self.correctImage {
                print("performBatchUpdates:puzzle not solved")
                return
            }

            // 2. Invalidate the timer
            let timeText = self.puzzleTimer.timerLabel.text
            self.puzzleTimer.timer.invalidate()
            self.puzzleTimer.timerLabel.text = timeText
            // 3. Perform segue with identifier "solvedSegue"
            print("performBatchUpdates:puzzle solved. time:\(self.puzzleTimer.timerLabel.text)")
            //var segue = UIStoryboardSegue.self as! SolvedViewController
            self.performSegue(withIdentifier: "solvedSegue", sender: nil)
            
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if imageSlices != correctImage {
            print("prepare:puzzle not solved")
            return
        }
        
        print("prepare:puzzle solved")
        let destVC = segue.destination as! SolvedViewController
        
        destVC.image = #imageLiteral(resourceName: "cats")
        destVC.time = puzzleTimer.timerLabel.text
    }
    
}
