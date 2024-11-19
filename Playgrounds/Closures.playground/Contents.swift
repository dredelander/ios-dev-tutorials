import UIKit

//CLOSURES:
// Closures are funtions that you can pass as a parameter

//Simple function
func funcWithParam(param: String){
    print(param)
}

funcWithParam(param: "Hello I'm function")

// Computed variable:
var greeting : String {
  return "Hello, playground"
}

// As a function
func greetingFx()-> String{
    return "Hello, playground"
}
funcWithParam(param: greetingFx())

// Now lets create a function with a closure/function as a param
func funcWithClosure(param: (()->String)){
    print(param())
}
//Function/closure does not get evaluated untill it gets called in the param() inner scope of the functionWithClosure
funcWithClosure(param: greetingFx)
//
//
//Here is a function that takes in a closure/function with a param
func funcWithClosureAndParamType(param: ((String)->String)){
    let hello = "Hello "
    print(param(hello))
}
funcWithClosureAndParamType{ hello in
    return hello + "playground"
}
//
// Here is an example of a reusable in a second parameter of a function:
func request(url:String, response:((String)->Void)){
    response("Here is your data")
}

request(url: "google.com") { response in
    print(response)
}

request(url: "apple.com"){res in
    print(res)
}

