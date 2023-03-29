trigger AssignedInterviewer on Assigned_Interview__c (after insert) {

    if(trigger.isAfter && trigger.isInsert){
         
        AssignedInterviewQuestionResponseMaker.assignedResponceCreator(trigger.new);
    }
}