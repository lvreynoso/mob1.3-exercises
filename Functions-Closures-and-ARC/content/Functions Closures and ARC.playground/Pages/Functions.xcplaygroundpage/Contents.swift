
/*:
 ![Make School Banner](./swift_banner.png)
 # Learning Outcomes
 
 By the end of this tutorial, you should be able to...
 
 1. Understand what a function is in Swift and how to write and call them.
 1. Describe what an instance method or class method is, and know when to use them.
 1. Understand what a closure is and how to write and call them.
 1. Know when it makes sense to use a closure in your projects.
 1. Describe how ARC manages instances in memory.
 1. Differentiate between reference and value types, and what it means to pass by reference vs value
 
 # Functions
 
 **Functions** are the building blocks of coding in any language. Coding functions have properties similar to functions you used in math classes:
 - They in 0 or more inputs
 -  The same input must yield the same output
 
 A type of function is a method. **Methods** are functions that are associated with a type. You'll learn more about methods later in this section.
 
 ## Function Atanomy
 ![function atanomy](./function.png)
 
 1. `func` is how you declare a new function/method
 1. functionName is the name of this function
 1. Use camel case when naming your functions: no spaces, and use capital letters to differentiate words. For example, `thisIsCamelCasing`
 1. Inside the parenthises is the parameter list. First, is the name of the parameter (this will be the variable name you'll use in the function). Then, the data type after a colon `:`. Each parameter is separated by a comma.
 1. Lastly, the return type. If your function doesn't not return a value, then leave out the `-> ReturnType`
 
 Here are more examples:
 */

//function that takes in an int and returns a string of that int
func convertNumberIntoString(number: Int) -> String {
    let stringFromNumber = String(number)
    
    return stringFromNumber
}

//function that takes in an array of numbers and prints each number
func printTheListOfNumbers(numbers: [Int]) {
    for aNumber in numbers {
        print(aNumber)
    }
}

import Foundation
//this function takes in no arguments and does not return a value
func printTheCurrentTime() {
    let now = Date()
    
    print(now)
}

/*:
 ## Calling a function/method
 
 Using the same functions from above, here's how we call them:
 */

let numberFive = 5
let stringFromANumber = convertNumberIntoString(number: numberFive)
print(stringFromANumber)


let numbersToPrint = [2, 56, 7, 8, 43, 2]
printTheListOfNumbers(numbers: numbersToPrint)


printTheCurrentTime()

/*:
 ## More examples with functions
 
 Say you are hosting an extravagent dinner party (or video game night, or slam poetry reading, it's your event!). Every host will need a list of guests attending the event to know how much food to buy, what entertainment to have, and if Lenny is going to be there so you know to hide your water bottle that he always steals...
 
 Let's build out our guest list! We'll use the following `Guest struct` to create our guest list. This Guest struct has two properties:
 - name
 - age
 
 - note: Guests conform to two protocols `CustomDebugStringConvertible` and `Equatable`. Protocols will be described in a later lesson.
 - This struct also has a computed var `debugDescription` which formats print statements to be more easily read. `debugDescription` is part of the `CustomDebugStringConvertible` protocol.
 
 - As for `Equatable`, this allows our struct to be compared with another instance of the same struct using the `==` operator.
 */

struct Guest: CustomDebugStringConvertible, Equatable {
    var name: String
    var age: Int
    
    var debugDescription: String {
        return name
    }
}

/*:
 We'll start with a single guest, our bff Eric!
 
 Write a function that prints the name and age of a person
 1. give the function a proper name
 1. add one parameter to the function's parameter list and give the parameter a name and the correct data type (we want to pass into the function the eric variable which is a Guest type)
 1. In the body of this function, use a print statement to print the argument's name and age properties
 1. Once you've writen the function, call it and pass the variable eric into the function. It should print: `Eric, 19` in the console.
 
 ![console](./console-1.png)
 */

let eric = Guest(name: "Eric", age: 19)

//write the function here
func guestPrinter(guest: Guest) {
    print("\(guest.name) \(guest.age)")
}

//call the function and pass in eric into the function
guestPrinter(guest: eric)

/*:
 Let's invite more guests! As much as we love Eric, we can only handle close-up magic for so long.
 
 Let's invite Sam, Sarah, and Charlie. We're going to want to and store these guests into an array.
 */

let sam = Guest(name: "Sam", age: 24)
let sara = Guest(name: "Sara", age: 23)
let charlie = Guest(name: "Charlie", age: 17)
let invitedGuests = [sam, eric, sara, charlie]

/*:
 Now that we have our array of invited guests, let's see if we can get some more info about them.
 1. Write a function that takes in an array of guests and prints each guest in that array (hint: the parameter's type will look like this `[Guest]`)
 1. In the body of the function, use a for loop to print each guest
 */

//write the function here
func guestArrayPrinter(_ array: [Guest]) {
    for entry in array {
        print("\(entry.name) \(entry.age)")
    }
}

//call the function and pass in invitedGuests into the function
guestArrayPrinter(invitedGuests)
/*:
 Great! Now that we have our list of invited guests we can see each of their ages. Except now we realize that Charlie is still 17! His birthday isn't for another couple of months. Since we'll be having guests ranging from teens to adults, we need to see who's 18 years or older so we know who doesn't need a parent to sign a liability waiver (you know....given how the last party went...).
 
 Write a function that returns a list of guests who are 18 years or older
 1. Give the function a proper name
 1. Add one argument that takes in an array of guests
 1. Set the return type of this function to be an array of guests `-> [Guest]`
 1. In the body of the function, loop through each guest in the given array of guests and check if each age is greater than or equal to 18. If so, add the guest to a new array
 1. After the for loop, return the new array of guests that contain guests that are 18 years or older
 */

//write the function here
func adultGuests(_ array: [Guest]) -> [Guest] {
    var output: [Guest] = []
    for entry in array {
        if entry.age >= 18 {
            output.append(entry)
        }
    }
    return output
}

//call the function and use this list of guests as your input to your function
//you can see the results by wrapping your function call in a print()
print(adultGuests(invitedGuests))
/*:
 ## Internal and external names
 
 In Swift, each parameter variable name in a function parameter list can have two names; internal and external names. The internal name is the variable name used inside the body of the function while the external name is what is used when the function is being called or used.
 
 ![function external names](./function-external-names.png)
 
 - note: If a parameter only has one name, it's used for both the external and internal names for that parameter.
 
 Here is an example:
 */

//this functions returns true or false if the given guest list contains the given guest
func does(_ guestList: [Guest], contain guest: Guest) -> Bool {
    if guestList.contains(guest) {
        return true
    } else {
        return false
    }
}

/*:
 
 * This function has two parameters in its parameter list. The first parameter has an external name of `_` which is a way to say there is no external name. But, the internal name is `guestList`.
 * As for the second parameter, the external name is `contain` and the internal name is `guest`.
 
 Now we can easily check if we've already invited someone to our party!
 
 Lets see how the function looks like when it's called:
 */

let isEricAlreadyInvited = does(invitedGuests, contain: eric)
print(isEricAlreadyInvited)

/*:
 ## Instance and class methods
 
 Functions can also be added inside a class or struct. Swift also supports functions inside of enums.
 
 ### Instance methods
 
 You are now a bank owner! Congrats! As the first order of business, we need a way to keep track of our customers and their information. We can do this by creating a class for our customers. So, lets create a new class!
 */

class Customer: CustomDebugStringConvertible {
    
    //1
    private static var numberOfCustomers = 0
    
    //2
    var firstName: String
    var lastName: String
    var age: Int
    
    //3
    var debugDescription: String {
        return getFullName()
    }
    
    //4
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        
        Customer.numberOfCustomers += 1
    }
    
    //5
    deinit {
        Customer.numberOfCustomers -= 1
    }
    
    //6
    static func getNumberOfCustomers() -> Int {
        return numberOfCustomers
    }
    
    //7
    func getFullName() -> String {
        return firstName + " " + lastName
    }
}

/*:
 Lets talk about what our new class has
 1. This is a **class property** that will serve as a counter of how many customers we have in total. In step 6 we'll see how to use a class property/method
 - note: This class property also has `private` as its control flow. Long story short, this property is **ONLY visible inside the class itself,** thus if you try to read or change this class property, the complier will not like this:
 
 ![private properties](./control-flow-1.png)
 
 2. These are **instance properties**. These properties are only accessable from an instance of our Customer class:
 ![instance properties](./isntance-properties.png)
 1. As used in our `Guest` struct, this property is part of the `CustomDebugStringConvertible` protocol. Here we return the value of an instance method `getFullName() -> String`
 1. This is our **initializer, or constructor,** for our class. Since we need to update the number of customers every time we get a new one, it makes the most sense to increament that count during the creation process of a customer.
 1. A **deinit** is the opposite of an initalizer. This block of code is executed when an instance of our class is being deleted from memory. More on memory management in a later lesson. Here, we'll decrement the customer counter since we need to keep track of removed customers.
 1. Since our class property counter (`numberOfCustomers`) is private, we created a **static method** that returns the value of that class property. This is how we prevent any code from directly accessing `numberOfCustomers`, and therefore beign able to manipulate it in a way we did not intend (such as maliciously manipulating our record of the number of customers).
 1. This is our **instance method**, which is a method that returns a value that is unique to each instance of our class (unique to each customer). This method returns the first and last name values into a single string separated by a space. Each customer will have a unique return value when they call this method (unless they have the same name).
 
 Lets create some customers and print the number of customers
 1. print the number of customers in a print statement using the class method `getNumberOfCustomers()`
 */

let sammy = Customer(firstName: "Sammy", lastName: "Love", age: 19)
let dan = Customer(firstName: "Dan", lastName: "Rodgrize", age: 20)
let timmy = Customer(firstName: "Timmy", lastName: "Turnner", age: 18)

//print the number of customers here
print(Customer.getNumberOfCustomers())
/*:
 Great work here! Functions will be something we use a LOT going forward, and are the building blocks for writing code. Let's move on to the next section where we'll learn about Closures, aka anonymous functions:
 */
//: [Previous](@previous) | [Next](@next)
