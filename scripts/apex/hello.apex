
//String fields = ' Name , Job_Posting__r.Id , Interview_Type__c ';
//String relationship = 'Interview_Stages__r';



List <SObject> p = [SELECT Id FROM Job_Posting__c];

list<Id> parents = new list<Id>();
for(SObject a : p){
    parents.add(a.Id);
}


Job_PostingCloner.JobPostingCloner(parents);


 