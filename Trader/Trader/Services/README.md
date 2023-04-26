
Please read the instructions carefully and ensure you understand the requirements before you start coding.

There is no time limit on the task, so you can work on it over the next couple of days as your time allows. Keep focused on the quality of your code and the chosen solutions.

It’s important that you use a private remote GIT repository to track your code as you go along and share it with us easily. Enjoy your coding and good luck!

  

# Task Description

Create a universal stock tracker iOS app that supports all orientations. It should display realtime trades updates for US Stock, forex and crypto.

The app should include two views/screens: Company price list (main) and Company detail view.

  

## Company Price List

  

This view should provide a list of companies with theirs price. The design for a table view and cell will be up to you. 

Bonus points will be given for clean and stylish CX. 

Mandatory fields to be included in the cell are:  
• Company acronym (Symbol name)
• Updated price
• Difference (absolute and relative). Note: The first value won’t have any previous number to compare, so up to you to provide the initial view setup. Also, please highlight this value on different colour depending if price went up (green) or down (red)

Tapping on any row will push to another view with the company details.


## Company Details

This page will display information about company selected. As in the previous view, the UI design is up to you. API has many information, up to you to pick the filed you find suitable.

Also, bonus points will be given based on the CX. Mandatory fields to be included in the view are:
* Company full name
* Symbol name
* Company logo
* Industry sector
* Actual price

>Note you would need to implement a mechanism to go back to the previous page.

## API Specification

Data provider is Finnhub Stock API (https://finnhub.io). For further information, please

visit the following link (https://finnhub.io/docs/api).

  

In order to fetch price updates you would need to establish a socket and subscribe for price

updates for several symbols: wss://ws.finnhub.io. Regarding authentication, you would need

to sign up on the site (it is free and quick). You would get an API Token on your dashboard. Therefore, to establish the socket you would need to connect to: (wss://ws.finnhub.io?token=<your-token>)

  

Regarding the socket implementation, there is no special requirement on how to do it. You can use a 3rd party (e.g. Starscream…) or code by yourself. Obviously, the effort of building an inhouse socket controller will be more valuable (but not mandatory). Nevertheless, note that FinnHub server sends data that can’t be compressed (thus you would need to disabl compression from socket)

The list of company should be easily tuneable from the code. You can pick any ticker available

on US Stock market (https://www.nyse.com/listings_directory/stock). Use 5 or 6, although this

solution should be generic and easily scalable.

  

When a push notification arrives, we have 2 scenarios:

• Company is already included in the list: In this case, the push notification will refresh

the content of the existing row.

• Company is not added to the list yet: A new row will be inserted containing the

information of the company.

  

Note the app should contain persistence. If app is killed, previous stock info should be kept for the following session. Up to you to decide which persistence approach you want to sure. Please justify your decision.

In order to get information from the company (for the details page), you can use:

https://finnhub.io/api/v1/stock/profile2?symbol=<company-symbol>&token=<your-token>

  

As stated above, pick the data you need from the one available in the endpoint.

## Global Requirements:

1. Code should be written in Swift.

2. Subscribed symbols terms should be easy to tune in code.

3. Use stock Cocoa UI elements.

4. In case you want to use a 3rd party, please justify the usage of it.

5. Please handle socket reconnection if app goes offline or sockets disconnects.

6. Follow the best OOP practices and software engineering processes.

7. Produce clean code.

## Bonus

1. Move the service wrapper into a separate Cocoa Touch framework, and include it using

Swift Package Manager.
