# Implementation Explain 
========

## Current App Problem

The current application's ViewController handles many tasks such as requesting Restful API, parsing JSON and all the business logics. Therefore, it is very hard for the code to be reusable and testable. 

## Solutions

With the purpose to improve the resuability and testability for the application, I have come up with some solutions: 

* Replace MVC to MVVM design architecture
* Create a request service class to manage API requests
* Handle error exception with details description
* Apply dependency injection (DI) to test the module easier
* Implement Decodable model to deserialize JSON to object efficiently and effectively 
* Create a table view cell which uses to display all tram information 
* Implement unit testing for the code

### Following MVVM design architecture

The default MVC architecture that Apple supports for iOS is good for a small project, but it is very hard to test because of the complicated ViewController. So, I have used the MVVM architecture to separate the coupling of the ViewController class into View class (ViewController) and ViewModel class. The ViewModel will handle the business logic, in this case, it loads the tram data and then binding the data to the UI. Likewise, any errors that may happen while handling the business logic will be displayed as an alert view.

### Implement TramData model 

Since Swift 4, Apple has released the Decodable model which helps developers to serialize JSON to object and vice a versa. In this application, I have created the TramData and Token model to deserialize tram and token value. 

### Implement TramService with DI 

The purpose of this class is to improve the extendability and testability of the application. The users can now use the service in any places. Moreover, they can extend it to use for other purposes. 


### Display all information in cell 

The cell is now showing all information of the bus including: 
* Route number
* Destination
* Expected time arrival 
* Time interval


### Unit testing with Quick and Nimble 
I have operated unit testing for the public functions of the application. For testing the failure case of URL request, I have created a MockFailSession which returns 500 status code. 

