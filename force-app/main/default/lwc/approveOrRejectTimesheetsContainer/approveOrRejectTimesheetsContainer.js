import { LightningElement, api, wire  } from 'lwc';
import {refreshApex} from '@salesforce/apex';
import {showToastEvent} from '@salesforce ';
import getTimesheetsByProject from '@salesforce/apex/ApproveOrRejectTimesheetsController.getTimesheetsByProject';
import approveOrRejectTimesheets from '@salesforce/apex/ApproveOrRejectTimesheetsController.approveOrRejectTimesheets';

export default class ApproveOrRejectTimesheetsContainer extends LightningElement{

    @api recordId;
    @api title;

    timesheets;
    wiredTimesheetsResponce;

    @wire( getTimesheetsByProject, {projectId: '$recordId'})
   
    wiredTimesheets(response){

        this.wiredTimesheetsResponce = response;

        this.timesheets = response.data;

        if(response.error){
            console.warn(error);
        }
    }

  
    handleApproveOrRejectTimesheets(event){
        console.log(event.detail)
        approveOrRejectTimesheets({timesheets: event.detail.timesheets, status: event.detail.status}) 

            .then(response =>{
                console.log('Im here now')
                refreshApex(this.wiredTimesheetsResponce);
                    console.log(`timesheets successfully ${event.detail.status.toLowerCase()}`);
            })
            .catch(error => {
                console.warn(error);
            })
    }

}