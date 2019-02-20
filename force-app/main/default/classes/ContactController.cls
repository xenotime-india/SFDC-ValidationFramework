/*************************************************************************
Name : ContactController 
Author : Sandeep Kumar
Date : February 20th,2019
Usage : Controller class for CreateContactForm lc
*************************************************************************/

public with sharing class ContactController {
    
    @AuraEnabled
    public static Map<String, String> createContact(Contact newContactObj) {
        System.debug(newContactObj);
        insert newContactObj;
        return null;
    }
}