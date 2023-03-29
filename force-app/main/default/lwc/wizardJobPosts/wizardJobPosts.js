import { LightningElement, api } from 'lwc';

export default class WizardJobPosts extends LightningElement {

jobPosts;
interviews;
interviewsQuestions;
possibleInterviewers

handleWizardJobPost(event){
 

    
}

handleOnChange(event){

let object = event.dataset.object  // on html side it would be data-object="jobPosts"
let field = event.detail.label     // on html side it would be label = 'Description'

this.object.field = event.target.Value;
}

}

