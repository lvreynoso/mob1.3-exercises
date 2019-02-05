
/*:
 # Common Uses of Closures
 
 One of the common uses of closures are **high order functions (HOFs)** on arrays. HOFs are array functions that take a closure as input and return a new array that is the result of running the closure on the elements in the original array. `sort`, `filter`, `reduce` and `map` are examples of HOFs we'll be going over today.
 
 Let's look at how using some of these HOFs and closures help to simplify some of our code.
 
 ## Filtering
 The **filter** method on an array will **return a new array with elements that returned true in the given closure.** The closure's signature looks like this:
 
 ### Signature
 `(Element) -> Bool` where `Element` is the type of what's in the array
 
 In our case, `Element` is our Guest struct since we have an array of Guest. Here's that Guest struct as a reminder:
 */
struct Guest: CustomDebugStringConvertible, Equatable {
    var name: String
    var age: Int
    
    var debugDescription: String {
        return name
    }
}
/*:
 In our example, we'll pass a closure that returns true if the guest's age is greater than or equal to 18. Otherwise, return false.
 */

let eric = Guest(name: "Eric", age: 19)
let sam = Guest(name: "Sam", age: 17)
let sara = Guest(name: "Sara", age: 23)
let charlie = Guest(name: "Charlie", age: 18)

let guestList = [sam, eric, sara, charlie]

/*:
 Below is how we would filter without the use of HOFs and closures:
 */

//filtering using our own function
func adultGuests(guests: [Guest]) -> [Guest] {
    var adultGuestList: [Guest] = []
    
    for aGuest in guests {
        if aGuest.age >= 18 {
            adultGuestList.append(aGuest)
        }
    }
    
    return adultGuestList
}

let adultsList = adultGuests(guests: guestList)

/*:
 Now let's see how we can write our solution more efficiently through using HOFs and closures:
 */
//filtering using a HOF
let adultsListFromFilter = guestList.filter { (aGuest: Guest) in
    if aGuest.age >= 18 {
        return true
    } else {
        return false
    }
}

/*:
 As you can tell, the filter method is much smaller than having to create our own function. Later in this lesson you'll learn how to reduce the code down to a single line!
 
 Let's look at some more functions:
 
 ## Sorted
 Sorted takes an array and sorts its elements based on the provided closure. Its closure signature is different from what we previously saw with `Filter`:
 ### Signature
 
 `(Element, Element) -> Bool`.
 
 **Sorted will compare two elements in the array and will use this closure to determin if the first element should be sorted before the second element.**
 
 The Closure will return true if its first argument should be ordered before its second argument.
 - note: you can reverse this by negating the logic thus sorting by descending order vs ascending
 */

//sort by age, oldest is at the front of the array
let sortedGuestList = guestList.sorted { (aGuest: Guest, bGuest: Guest) in
    if aGuest.age >= bGuest.age {
        return true
    } else {
        return false
    }
}

/*:
 ## Map
 Map takes an array and applies Think of the **map function as a transforming function:** for example, you can use `map` to convert an array of numbers into an array of strings.
 
 ### Signature
 
 `(Element) -> Result` where Element is the type of the array, and Result is the new type you want to map each element into
 
 There's a bit more you have to define upfront when using `map` on an array:
 1. Define what the return type is for the given closure (previously it could only have been `Bool`)
 1. Return a new instance of the same type as the closure's return type
 
 Let's create a list of lowercased strings and try to uppercase them (the return type of the closure can be the same type as the original array)
 */

let lowerCaseLetters = ["a", "z", "b", "x", "c", "y"]
let upperCaseLetters = lowerCaseLetters.map { (aLetter: String) -> String in
    let upperCaseOfLetter = aLetter.uppercased()
    
    return upperCaseOfLetter
}

/*:
 As another example, let's create two separate arrays based on our previously created `guestList`:
 - One contains the ages of guests
 - The other contains only the names of guests
 - important: notice the return type of each closure matches the return value inside the closure's body
 */

let listOfAgesFromGuests = guestList.map { (aGuest: Guest) -> Int in
    return aGuest.age
}

let listOfNamesFromGuests = guestList.map { (aGuest: Guest) -> String in
    return aGuest.name
}

/*:
 ## Reduce
 This one is interesting. Reduce will, like all other HOFs, iterate through each element in the array but **the goal of reduce is to take the array and transform (or reduce) the array down into a single new type.**
 
 For example, let's say you have an array of integers and you want to reduce the array into a sum, a single integer.
 
 ### Signature
 
 `(Result, Element) -> Result` where `Element` is the same type as the array, and `Result` is the new type you want to reduce each element into.
 
 The first argument is what the current reduced form looks like (always starts out nil). The second argument is an element from the array.
 
 Let's try this out by writing the first example out:
 */

let randomNumbers = [2, 1, 6, 2, 8, 3, 10, -1]
let sumOfRandomNumbers = randomNumbers.reduce(0) { (sumSoFar, anInt) -> Int in
    let newSum = sumSoFar + anInt
    
    return newSum
}

/*:
 Let's break this down a bit:
 1. `sumSoFar` is our running tally of our sum
 1. `anInt` represents an element from the array (in this case 2, 1, 6, 2, etc.)
 1. For each element (`anInt`) in the array, we're going to add it to our running tally of our sum (`sumSoFar`) and save it (`newSum`)
 1. `newSum` is an `Int` that gets returned after we've gone through every element in the array and calculated the sum
 
 Pretty cool, right? We took an array and boiled it down into a single element! Let's apply this knowledge to our event that we've been working on. Arrays are great, but if we're looking at a guest list, a sentence is much more readable for most of us.
 
 Let's reduce an array of guests into a sentence, or `String`, that contains the names of all the guests separated by a comma:
 */

let namesCombined = guestList.reduce("") { (sentence, aGuest) -> String in
    let newSentence = aGuest.name + ", " + sentence
    
    return newSentence
}

/*:
 ## You try!
 
 Practice using the high order functions by completing the following:
 */

//sort these numbers
let numbersToSort = [2, 4, 4, 2, 1, 0]
let sortedNumbers = numbersToSort.sorted(by: { $0 < $1 } )
print(sortedNumbers)


//sort the guests by name
let guestsToSort = [sam, eric, sara, charlie]
let sortedGuests = guestsToSort.sorted(by: { (first: Guest, second: Guest) -> Bool in
    if first.name < second.name {
        return true
    } else {
        return false
    }
})
print(sortedGuests)

//sort the guests by age, but in descending order (youngest at the front of the array)
let ageSortedGuests = guestsToSort.sorted(by: { first, second in
    return first.age < second.age
})
print(ageSortedGuests)
//filter the guests to only include guests younger than 18 years
let minorGuests = guestsToSort.filter({ guest in return guest.age < 18 })
print(minorGuests)

//filter the numbers to only include even numbers
let numbersToFilter = [2, 1, 1, 5, 6, 7, 10]
let evens = numbersToFilter.filter({ number in return number % 2 == 0 })
print(evens)

//map the numbers to be double their values (e.g. 5 gets mapped to 10)
let numbersToDouble = [2, 4, 6, 8]
let doubledNumbers = numbersToDouble.map({ number in return number * 2 })
print(doubledNumbers)

//map the numbers into strings
let numbersToMapIntoStrings = [2, 4, 5, 1, 2, 2]
let stringified = numbersToMapIntoStrings.map({ number in return String(number) })
print(stringified)

//reduce the numbers into a sum, but exclude negative numbers from the sum. Thus, your reduce closure should reduce this array to equal 10
let numbersToSum = [-2, -5, -4, 5, -5, 5]
let summified = numbersToSum.reduce(0, { accum, value in
    if value < 0 {
        return accum
    } else {
        return accum + value
    }
})
print(summified)

/*:
 We've learned more on how to use closures in our code, specifically with higher order functions, in order to clean up our code and make it more efficient.
 
 But we can make it EVEN MORE efficient! In the next section we'll learn some shorthand for writing closures.
 */
//: [Previous](@previous) | [Next](@next)


