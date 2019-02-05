/*:
 # ARC: Memory Management

 ## Retain Counts
 Swift uses **Automatic Reference Counting, or ARC,** to manage when an instance is in kept in memory and when it gets deleted.

 #How does it work
 Once an instance of a class is created, ARC will keep track of its **reference count, or retain count.** Let's look at an example:

 We create a class called Person and add an initizalizer, a deinit method, and a single property `name`.
 */

class Person {
    var name: String

    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

/*:
 Each instance of a class has its own retain count. This counter is what tells ARC to keep the instance in memory or delete it from memory. When the retain count is zero, ARC will delete the instance.

 Let's create an instance of this class and assign it to a local variable:
 */

let eric = Person(name: "Eric")

/*:
 Since `eric` references the new instance, the retain count is now 1. Let's create another instance of `Person`
 */

let jack = Person(name: "Jack")

/*:
 Again, this new instance has a retain count of 1. Each instance has a retain count of 1 because each instance has one variable "pointing" at each instance.

 So now that we saw how to **increment** a retain count, let's see how we can decrement one.

 ## Decrementing a retain count
 We'll use the same two instances, `Person(name: "Eric")` and `Person(name: "Jack")`, and create a new variable and set it equal to `eric`.
 */

var jacksBestFriend: Person? = eric

/*:
 Any guesses on what the retain count is of the first instance?

 It's 2. The first instance, `Person(name: "Eric")`, now has two variables pointing to it. How is this possible?

 On the previous line of code, we assign `jacksBestFriend` to equal `eric`. But, what happened under the hood is the variable, or pointer, `jacksBestFriend` now *points* to whatever `eric` *points to* which is the first instance, `Person(name: "Eric")`. Let's update `jacksBestFriend` to not point to `eric`:
 */

jacksBestFriend = nil

/*:
 Now the retain count for `Person(name: "Eric")` is back to 1 since `eric` still points to that instance. Overall, **the retain count for all instances depends on how many properties, variables, and constants are pointing to that instance.**

 ## When do retain counts go to zero?
 A common place for an instance's retain count to go to zero is via a local variable. Let's take a look:
 */

func createPersonInstance() {
    let bella = Person(name: "Bella")

    print("New person's name is \(bella.name)")
}

print("function call starts")
createPersonInstance()
print("function call ends")

/*:
 Look in the console and see that Bella is initalized after the function starts and deinitialized after the function ends.

 ![deinit](./deinit.png)

 This is because the **local variable is removed when the function that created the local variable fell out of scope.**

 Another common case is when you present a new view controller onto the screen a new instance of that view controller is initalized. But, when the screen goes away, by a back button for example, the view controller is then deinitialized.

 ## Two Kinds of Types
 Types come in two varieties:
 - **Reference Type**
 - **Value Type**

 We'll cover both of these in-depth, as there are important differences between the two. Let's start with Reference Type.

 ### Reference Types
 In Swift, there are `classes`, `structs`, and `enums`. **Classes are the only type that can be a reference type. All others, are value types.** What does this mean in our code?

 #### Functions, passed by value or pass by reference
 Let's look at the following code and see what's going on:
 */

let billy = Person(name: "Billy")

func printDetailsOf(_ person: Person) {
    print(person.name)
}

printDetailsOf(billy)

/*:
 So, what's going on when we call the function `printDetailsOf`? Since the variable `billy` points to an instance of a Person class, which is a reference type, the instance is passed by reference. **Passing by reference means that only the pointer is given to the function.** The pointer that contains the instance is stored in memory.

 Similarly, when we created the variable `jacksBestFriend` previously, and set it equal to `eric`, `jacksBestFriend` was assigned a pointer to the same place in memory as `eric` which was `Person(name: "Eric")`.

 ![eric diagram](./eric-diagram.png)

 ### Value Types
 Now, if `Person` was a value type instead, in other words a `struct` vs a `class`, different operations would occur in our two previously discussed situations:

 In the first situation (above `billy` code), the function would make a copy of `billy`, which would therefore copy the values of `billy` (his name).

 In the second situation(`jacksBestFriend`), again, the values would be copied. Once we assign `jacksBestFriend` to `eric`, `jacksBestFriend` would have its own copy of `eric`'s values.

 ![eric value diagram](./eric-value-diagram.png)

 ### Reference Vs. Value
 Let's go over some familiar examples using both reference and value types. First we'll take a look at using reference types:
 */

//using reference types
let molly = Person(name: "Molly")
var ericBestFriend = molly

print("before changing the name: \(molly.name)")
ericBestFriend.name = "Molls"

print("after changing the name: \(molly.name)")

/*:
 Notice when we changed the name of `ericBestFriend` it changed the name of `molly`. This is because both `ericBestFriend` and `molly` point to the same instance because `Person` is a class (reference type).

 ![molly reference](./molly-ref.png)

 Now, let's try this with a value type, `Customer`:
 */

struct Customer {
    var name: String
}

//using value types
let danny = Customer(name: "Danny")
var bankCustomer = danny

print("before changing the name: \(danny.name)")
print(bankCustomer.name)
bankCustomer.name = "Dan"

print("after changing the name: \(danny.name)")
print(bankCustomer.name)

/*:
 Now in this case, notice how the value of `danny.name` remained the same. While, `bankCustomer.name` changed to the new name. This is because `bankCustomer` was a copy of `danny`

 ![danny value](./danny-diagram.png)

 ## Retain Cycles
 ARC has its common challenges, one is a retain cycle. A retain cycle occurs when two instances point at each other. Let's see how that looks:

 We have the following two classes:

 ![retain cycle classes](./retain-cycle-classes.png)

 - important: a person has a property of type Apartment. And, an apartment has a property of type Person.

 Let's create an instance of each classes and assign the person to the unit and the unit to the person:

 ![retain cycle-create instances](./retain-cycle-create-instances.png)

 Let's look at a graph the help use describe what's going on:

 ![retain cycle](./referenceCycle02_2x.png)

 Here, we created two instances, a Person instance stored in `john`, and an Apartment instance stored in `unit4A`. `john.apartment` points to the instance `unit4A` points to. Then, `unit4A.tenant` points to the instance `john` points to.

 ### The problem

 Here in the following graph, both variables `john` and `unit4A` no longer point to the instances `Person(name: "John Appleseed")` and `Apartment(unit: "4A")`. But, notice the two instances still point to each other. **This is a problem, because each instance still has a retain count of 1 (instead of 0), therefore they haven't been deinitalized from memory.** In fact, both instances are unreachable:

 ![retain cycle-2](./referenceCycle03_2x.png)

 So, how do we fix this? We have to break the chain between the two instances somehow.

 By default, all variables, properties and constants are **strong pointers.** Meaning, they **increament and decreament retain counts of the instances each variable points to.** Since it is the default, `unit4a.tenant` and `john.apartment` are strongly pointing to each other, giving us the problem we're currently facing.

 So we've identified where to break the chain, but how can we do it? If only there was a weaker pointer type...

 ## Weak References
 Oh good, there is! **Weak pointers utilze the `weak` keyword to allow variables to point to an instance without increamenting its retain count. Since a weak variable does not increament the retain count, the instance the optional points to can be deinitialized, thus the variable can be `nil`.
 - note: Any time a weak reference is used, this turns the variable into an `optional`. Weak variable and `optional` are considered synonymous.

 Let's try to fix our retain cycle using a weak variable:

 ![retain cycle classes-fixed](./retain-cycle-classes-fixed.png)

 Here we mark the tenant property as a *weak property*. This is what the graph looks like now:

 ![weak reference](./weakReference01_2x-1.png)

 - note: The variable, or pointer, from the `apartment` to the `tenant` is now a `weak` reference. Thus, the retain count for `tenant` is only one. The retain count for `apartment` is still two as it was previously.

 Once the `john` variable is deleted, or no longer pointing at `Person(name: "John Appleseed")`, the Person instance's retain count goes from 1 to zero, thus the instance is removed from memory:

 ![person deinit](./weakReference02_2x.png)

 Once the person is deinitialized, now apartment's retain count went from 2 to 1, 1 being the `unit4A` variable. And like expected, once `unit4A` is removed, `Apartment(unit: "4A")` is deinitalized from memory:

 ![apartment deinit](./weakReference03_2x.png)

 ## Unowned References
 Unowned serves the same effect as `weak`, the retain count is not increamented or decreamented but this implicitly unwraps the optional for you. So, if you can guarentee that the instance an `unowned variable` points to will never be deinitalized when you use the unowned variable, then mark it as `unowned` vs `weak`.

 - important: Like force unwrapping an optional, if there is no value there, your app will crash. **Thus, unowned variables are not used often.**
 */


/*:
 ## Summary
 Throughout this tutorial (other than planning a fabulous event) we covered:
 - How to write functions
 - What a closure is and how they relate to functions (they are functions!)
 - How we use closures and how they relate to higher order functions (HOFs)
 - How we can optimize our closure code via shorthands
 - How ARC works in regards to managing memory, the difference between reference/value types, and the differences between strong and weak references.

 This gives us a solid foundation to build on as we continue to navigate the intricacies of building out projects in iOS!

 ## Feedback and Review
 Please take a moment to rate your understanding of learning outcomes from this tutorial, and how we can improve it via our [tutorial feedback form](https://goo.gl/forms/hPZCYMoFxEEIUfEo1)
 */


//: [Previous](@previous)





















import Foundation
