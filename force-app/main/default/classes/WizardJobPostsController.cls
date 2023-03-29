public with sharing class WizardJobPostsController {

    
    @AuraEnabled
    public static void insertFullJobPosts(List <sObject> newJobPosts){
        try{
            
            //update timesheets;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}