trigger Timesheet on Timesheet__c (before update, after insert) {

    if(Trigger.isBefore && Trigger.isUpdate){
        TimesheetRejectionIncrementor.incrementRejectionNumber(Trigger.new,Trigger.oldMap);
        
    } else if(Trigger.isAfter && Trigger.isInsert){

        TimesheetReminderTaskCreator.submissionTaskReminder(Trigger.new);
    }
} 