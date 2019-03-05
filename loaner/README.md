# loaner

> Update this readme

# Concepts learned, used (in order of development)

MODELS
Loan
- default image 
- default property values
- nested types

STORYBOARD
ViewController
- profile and item images using Assets.xcassets
- dummy data, add a gray background to the dummy cell
- collection view bonus vertically

ItemCollectionViewCell
- cell size 164x
- height of image view is 6:7 of stack view
- outlets and configure method

VIEW CONTROLLER
ViewController
- set up collection view layout

STORYBOARD
- Embed ViewController in UINavigationViewController
- Create Show Segue from Vc to new Vc

DetailedItemViewController
- Resize ViewController from fixed to freeform to 1000px
- navbar stack view
- content scroll view
- - image views are clip to bounds and apsect fill
- floating button view

VIEW CONTROLLERS
ItemDetailedVc
- updateUI
- todo: prompt the contact info

ViewController
- unwind from back, from mark as returned, from trash
- Create blank item, add, delete item

ItemEditorVc
- layout ui
- `===` in the textfielddidend
- UIImagePickerController
- UIImage Extension

ItemContactInfoVc
- contact ui
- - predicate for enabling contacts

MODELS
Item
- assignLoanee from CNContact
- remove dummy data

VIEWCONTROLLERS
ViewController
- unwindToHome(_:) add new saved item

ItemDetailedVc
- present contact info
- hide and show the navigation bar

LOCAL NOTIFICATIONS
NotificationService
PrivacyUtility
SettingsUrls

CHALLENGES

VIEWCONTROLLERS
ItemEditor
- save to albums
- info.plist

# Project Spec

# In Class Project 2 - Loaner Ledger App

## Description 

Create an that takes a picture of things you have loaned 
and a description, name and date of the borrower. 

Show a list of things loaded in a collection view. 

Adds new items loaded.

Uses contact picker to keep track of borrowers

- Lönr - an items loaded tracker 
- Ldgr - trackers things you have loaned to others

## Objectives 

- Modeling and Structuring Data 
- NSCoding 
- Constraints 
- Collection View 
- Custom Cells
- Collection View Layout 
- UIImagePicker Controller 

## Stretch Challenges

Add a return date with a notification. 

- Uses the camera 
- Saves pictures 

# Outline of Lesson
---

# MOB 1.2 Sec 10-12
# Some Sample Clone App (2) - Part 1 - Modeling and Structure
## Modeling and Structure
#### Model Data Types
1. Item struct
2. Loanee struct
3. CNContact class
# Some Sample Clone App (2) - Part 2 - Layout Essentials
## More on Constraints
#### Layout Detail View Controllers
> Topics covered: Constraints, Content Hugging Priority, Content Compression Resistance Priority, Equality constraints, UIStackViews
1. Layout ItemDetailedVc
2. Layout ItemEditorVc
3. Layout ItemContactInfoVc

# Some Sample Clone App (2) - Part 3 - Collections
## CollectionView
#### UICollectionView - datasource and delegate
1. Layout in Storyboard
2. Populate with dummy data
3. Select items
#### UICollectionView layouts
1. Custom Layout
