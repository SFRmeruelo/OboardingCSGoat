public with sharing class Job_PostingCloner {
    
    @InvocableMethod(description = 'Clones Job post of current record' label = 'Clone Job Post' category='JobPosts')
    public static void jobPostingCloner ( List<Id> jobPostingIds){
 
        Map<Id, Id> clonedJobPosts = jobCloner(jobPostingIds);
        Map<Id, Id> newStages = interviewStageCloner(clonedJobPosts);
        possibleInterviewerCloner(newStages);
        interviewQuestionsCloner(newStages);                         
    }

    private static Map<Id, Id> jobCloner(List <Id> originalJobs){
        
        List<Id> originalJobIds = new List <Id>();
        List<Job_Posting__c> newJobPosts  = new List<Job_Posting__c>();

        String fields = ' Id, Name , Salary_Range__c , Hiring_Manager__c , Job_Description__c , '
                           + ' Job_Qualifications__c , Recruiting_Specialist__c  ';

        List<Job_Posting__c> jobs = RecordsGetter(fields, null,originalJobs);

        for(Job_Posting__c job : jobs){
            Job_Posting__c newJob = new Job_Posting__c(
                Name = job.Name + '(Cloned)',
                Salary_Range__c = job.Salary_Range__c,
                Hiring_Manager__c = job.Hiring_Manager__c,
                Job_Description__c = job.Job_Description__c,
                Job_Qualifications__c = job.Job_Qualifications__c,
                Recruiting_Specialist__c = job.Recruiting_Specialist__c,
                Status__c = 'Drafting'
            );

            originalJobIds.add(job.Id);
            newJobPosts.add(newJob);
        }
        
        List <Id> clonedJobIds = RecordInserter(newJobPosts);
        Map<Id, Id> clonedJobPosts  = CloneDataFormater( originalJobIds,clonedJobIds);
        return clonedJobPosts;
    }
        
    private static Map<Id, Id> interviewStageCloner(Map<Id, Id> jobPostings){
        
        List <Id> originalJobs = new List <Id>(jobPostings.keySet());
        List <Id>  originalInterviewStagesIds = new List <Id>();                                                       
        List<Interview_Stage__c> newInterviewStages = new List <Interview_Stage__c>();

        String fields = ' Name , Job_Posting__c , Stage__c, Stage_Number__c , Stage_Name__c';
        String relationship = 'Interview_Stages__r';
       

        List <Interview_Stage__c> stages = RecordsGetter(fields, relationship, originalJobs);
     
        for(Interview_Stage__c stage :stages){

            Interview_Stage__c newStage = new Interview_Stage__c(
            Job_Posting__c = jobPostings.get(stage.Job_Posting__c),
            Name = stage.Stage_Name__c,
            Stage__c = stage.Stage__c,
            Stage_Number__c = stage.Stage_Number__c,
            Status__c ='Not Started'
            );
        
            newInterviewStages.add(newStage);
            originalInterviewStagesIds.add(stage.Id);
        }
        
        List <Id> clonedInterviewStagesIds = RecordInserter(newInterviewStages);
        Map<Id,Id> clonedInterviewStages = CloneDataFormater( originalInterviewStagesIds,clonedInterviewStagesIds);
        return clonedInterviewStages;   

    }

    private static void possibleInterviewerCloner(Map<Id,Id> interviewStages){

        List <Id> originalInterviewStagesIds = new List <Id>(interviewStages.keySet());
        List <Possible_Interviewer__c> newPossibleInterviewers = new List<Possible_Interviewer__c>();
        String fields = 'User__c, Interview_Stage__r.Id';
        String relationship = 'Possible_Interviewers__r';

        List <Possible_Interviewer__c> PossibleInterview = RecordsGetter(fields, relationship, originalInterviewStagesIds);
        for(Possible_Interviewer__c pI : PossibleInterview){
            Possible_Interviewer__c clone = new Possible_Interviewer__c(
                Interview_Stage__c = interviewStages.get(pI.Interview_Stage__r.Id),
                User__c = pI.User__c
            );
            newPossibleInterviewers.add(clone);
        }
        List <Id> newPossibleInterviewersIds = RecordInserter(newPossibleInterviewers);
    }
    private static void interviewQuestionsCloner(Map<Id,Id> interviewStages){

        List <Id> originalInterviewStagesIds = new List <Id>(interviewStages.keySet());
        List <Interview_Question__c> newInterviewQuestions = new List<Interview_Question__c>();
        String fields = 'Question__c, Interview_Stage__r.Id';
        String relationship = 'Interview_Question__r';

        List <Interview_Question__c> InterviewQuestions = RecordsGetter(fields, relationship, originalInterviewStagesIds);
        for(Interview_Question__c iQ : InterviewQuestions){
            Interview_Question__c clone = new Interview_Question__c(
                Interview_Stage__c = interviewStages.get(iQ.Interview_Stage__r.Id),
                Question__c = iQ.Question__c
            );
            newInterviewQuestions.add(clone);
        }
        List <Id> newInterviewQuestionsIds = RecordInserter(newInterviewQuestions);
    }

    private static List <Id> recordInserter( List <SObject> insertList){
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
        return newIds;
    }

    private static List<SObject> recordsGetter(String fields, String relationship, List<Id> IDs ){
        
        String sobjectType = IDs[0].getSObjectType().getDescribe().getName();
        List <SObject> records = new List<SObject>();
        
        if(relationship != null){ 
            for (SObject query : Database.query(String.escapeSingleQuotes('SELECT Id , (SELECT '+ fields + 
                                                ' FROM ' + relationship + ' ) FROM ' + 
                                                 sobjectType +  ' WHERE Id IN : IDs '))){
                for(SObject c : query.getSObjects( relationship)){
                    records.add(c);
                }
            }
        }else{       
            for (SObject query : Database.query('SELECT ' + fields + ' FROM ' + sobjectType + ' WHERE Id IN : IDs ')){
                records.add(query);
            }
        }
        return records;
    }

    private static Map <Id, Id> cloneDataFormater(List<Id> copiedRecordId , List<Id> cloneIds){
      
       Map<Id, Id> cloneData = new  Map<Id,Id>();
            for(Integer i = 0; i < copiedRecordId.size();i++){
                cloneData.put(copiedRecordId[i],cloneIds[i]);
            }
        return cloneData;
    }
}

