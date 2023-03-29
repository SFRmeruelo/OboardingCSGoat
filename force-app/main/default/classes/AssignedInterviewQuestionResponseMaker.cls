public with sharing class AssignedInterviewQuestionResponseMaker {
    
   public static void assignedResponceCreator(List<Assigned_Interview__c> assignedInterviewers){


    List<Id> interviewIds = new List<Id>();
    List<Id> interviewStagesIds = new List<Id>();
    List <Question_Response__c> newQRs = new List <Question_Response__c>();

    //getList -> interviews 
    //track -> interviewers in which interview -> map
    //getList -> all stages interviewers related too
    //what interview to what stage
    //all interviews associated to stage
    //each of those responce to all create
    for(Assigned_Interview__c interviewer : assignedInterviewers){
        interviewIds.add(interviewer.Interview__c);
    }

    List<Interview__c> allInterviews = [SELECT Interview_Stage__c 
                                        FROM Interview__c  
                                        WHERE Id IN :interviewIds];
    

    for(Interview__c interview : allInterviews){
        interviewStagesIds.add(interview.Interview_Stage__c);
    }

    List<Interview_Question__c> allInterviewQuestions = [SELECT Question__c 
                                                         FROM Interview_Question__c 
                                                         WHERE Interview_Stage__c IN :interviewStagesIds];


    for(Interview_Question__c question : allInterviewQuestions){
        
        Question_Response__c ques  = new Question_Response__c(
            Assigned_Interviewer__c = assignedInterviewers[0].Id,
            Question__c = question.Question__c
        );
        newQRs.add(ques);
    }
                                             

   // Map <Id, List <Id>> mapIntervewStageQuestions  = new Map<Id, List <Id>>();
    
    // for(SObjectd object: [ SELECT Question__c 
    //                        FROM Interview_Questions__c 
    //                        WHERE Interview_Stage__c In :Interview.keys()]){
    // }









                                                     
    // for(Assigned_Interview__c interviewer : assignedInterviewers){
    //     interviewStagesIds.add(interviewer.Interview__r.Interview_Stage__c);
    // }

   // List <Interview_Question__c> interviewQuestions = QuestionGetter(interviewStagesIds);


    // for(Assigned_Interview__c interviewer : assignedInterviewer){
    //     for( Interview_Question__c question : interviewQuestions){
    //         if(question.Interview_Stage__r.Id == interviewer.Interview__r){

    //             Question_Response__c QR = new Question_Response__c(
    //                 Assigned_Interviewer__c = interviewer.Id,
    //                 Question__c = question.Question__c
    //                 );

    //                newQRs.add(QR);
    //         }
    //     }
    // }

    recordInserter(newQRs);
   }

//    private static List<Interview_Question__c> questionGetter(List<Id> InterviewStages ){

//      List<Interview_Question__c>records = new List <Interview_Question__c>();

//     for(Interview_Stage__c Stage : [SELECT Id, (SELECT Interview_Stage__c, Question__c 
//                                                 FROM Interview_Question__r) 
//                                                 FROM Interview_Stage__c
//                                                 WHERE ID IN :InterviewStages]){
//         for(Interview_Question__c IQ : Stage.Interview_Question__r){
//             records.add(IQ);
//         }

//     }
//     return records;
// }
    
   private static void recordInserter( List <SObject> insertList){
    List<Database.SaveResult> srList = Database.insert(insertList,true);
    List <Id> newIds = new List<Id>();

    for (Database.SaveResult sr : srList) {
        if (sr.isSuccess()) {
            System.debug('Successfully inserted Record .Record ID: ' + sr.getId());
            newIds.add(sr.getId());
        }
        else {         
            for(Database.Error err : sr.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Record fields that affected this error: ' + err.getFields());
            }
        }    
    }
    }
}