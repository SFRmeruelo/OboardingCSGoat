import { LightningElement, api } from 'lwc';

export default class ApproveOrRejectTimesheetsTable extends LightningElement {

    @api timesheets;
    @api title;

    modalShown = false;
    selectedRows = [];
   
    columns = [
        { label: 'Name', fieldName: 'Name', type: 'text'},
        { label: 'Hours', fieldName: 'Hours__c', type: 'number' },
        { label: 'Employee', fieldName: 'Employee__c', type: 'text'},
        { label: 'Status', fieldName: 'Status__c', type: 'text' }
    ];

    get noRowsSelected(){
        return this.selectedRows.length === 0;
    }

    handleSelectedRows(event){
        this.selectedRows = event.detail.selectedRows;    
    }

    approveOrRejectTimesheets(event){
        let status = event.currentTarget.dataset.status;
        this.dispatchEvent(new CustomEvent('approveorreject',{
            detail:{
                timesheets: this.selectedRows,
                status: status
            }
        }));
        this.toggleModal
    }

    toggleModal(){
        this.template.querySelector('c-model').toggleModal();
        this.selectedRows = [];
    }
    
}