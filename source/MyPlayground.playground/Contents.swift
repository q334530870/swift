//: Playground - noun: a place where people can play

import UIKit

var f = 11111123333.335
var formater = NSNumberFormatter()
formater.positiveFormat = "#,##0.00"
var a = formater.stringFromNumber(f)

