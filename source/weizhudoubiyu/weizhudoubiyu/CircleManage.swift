//
//  CircleManage.swift
//  weizhudoubiyu
//
//  Created by YaoJ on 15/1/12.
//  Copyright (c) 2015年 YaoJ. All rights reserved.
//
import Foundation

class CircleManage {
    
    var row:Int
    var col:Int
    
    init(row:Int,col:Int){
        self.row = row
        self.col = col
    }
    
    func calcRoad() -> CircleManage?{
        var newCurrentCircle:CircleManage? = nil
        _ = manage.count
        for road in manage{
            _ = circle[road.row][road.col].tag
            if circle[road.row][road.col].tag != 1{
                newCurrentCircle = road
                break
            }
        }
        return newCurrentCircle
    }
    
    func findAllRoundCircle(){
        manage.removeAll(keepCapacity: false)
        if (getLeft() != nil) {
            manage.append(getLeft()!)
        }
        if (getRight() != nil) {
            manage.append(getRight()!)
        }
        if (getLeftUp() != nil) {
            manage.append(getLeftUp()!)
        }
        if (getRightUp() != nil) {
            manage.append(getRightUp()!)
        }
        if (getLeftDown() != nil) {
            manage.append(getLeftDown()!)
        }
        if (getRightDown() != nil) {
            manage.append(getRightDown()!)
        }
    }
    
    func getLeft() -> CircleManage?{
        var cir:CircleManage?
        if self.col != 0{
            cir = CircleManage(row: 0, col: 0)
            cir?.row = self.row
            cir?.col = self.col - 1
        }
        return cir
    }
    
    func getRight() -> CircleManage?{
        var cir:CircleManage?
        if self.col != 8{
            cir = CircleManage(row: 0, col: 0)
            cir?.row = self.row
            cir?.col = self.col + 1
        }
        return cir
    }
    
    func getLeftUp() -> CircleManage?{
        var cir:CircleManage?
        if self.row != 0 {
            if self.row % 2 == 0 && self.col == 0{
            }
            else{
                cir = CircleManage(row: 0, col: 0)
                cir?.row = self.row - 1
                if self.row % 2 == 0{
                    cir?.col = self.col - 1
                }
                else{
                    cir?.col = self.col
                }
            }
        }
        return cir
    }
    
    func getRightUp() -> CircleManage?{
        var cir:CircleManage?
        if self.row != 0 {
            if self.row % 2 != 0 && self.col == 8{
            }
            else{
                cir = CircleManage(row: 0, col: 0)
                cir?.row = self.row - 1
                if self.row % 2 == 0{
                    cir?.col = self.col
                }
                else{
                    cir?.col = self.col + 1
                }
            }
        }
        return cir
    }
    
    func getLeftDown() -> CircleManage?{
        var cir:CircleManage?
        if self.row != 8 {
            if self.row % 2 == 0 && self.col == 0{
            }
            else{
                cir = CircleManage(row: 0, col: 0)
                cir?.row = self.row + 1
                if self.row % 2 == 0{
                    cir?.col = self.col - 1
                }
                else{
                    cir?.col = self.col
                }
            }
        }
        return cir
    }
    
    func getRightDown() -> CircleManage?{
        var cir:CircleManage?
        if self.row != 8 {
            if self.row % 2 != 0 && self.col == 8{
            }
            else{
                cir = CircleManage(row: 0, col: 0)
                cir?.row = self.row + 1
                if self.row % 2 == 0{
                    cir?.col = self.col
                }
                else{
                    cir?.col = self.col + 1
                }
            }
        }
        return cir
    }
    
}
