import { LightningElement,track } from 'lwc';
import getOpportunities from '@salesforce/apex/Opportunities_cont.getOpportunities';
import updateOpportunity from '@salesforce/apex/Opportunities_cont.updateOpportunity';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

const actions = [
    { label: 'Update to Negotiation/Review',name: 'update_stage', typeAttributes: {value: 'Id'}}
];

const columnsConst = [
    // {label: 'Id', fieldName: 'Id', type: 'text'},
    // 
    {label:'Name',fieldName:'UrlOpp',type:'url',typeAttributes: {label: { fieldName: 'NameOpp' }, target: '_blank'},},
    {label:'Stage',fieldName:'StageNameOpp',type:'text'},
    {label:'Amount',fieldName:'AmountOpp',type:'currency'},
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    }
];



export default class UpdateOpportunities_lwc extends LightningElement {
    opportunities =[];
    count=0;
    @track spinner=false;
    columns = columnsConst;
    OppID;
    connectedCallback() {
        this.spinner=true;
        console.log('connectedCallback');
        this.loadOpportunities();
    }
    
    loadOpportunities(){
        console.log('loadOpportunities');
        this.opportunities =[];
        getOpportunities().then(result => {
            this.spinner=false;
            if(!result.error){
                this.count=result.opportunities.length;
                console.log('this.count: '+this.count);
                for (let i = 0; i < result.opportunities.length; i++) {
                    this.opportunities= [...this.opportunities,{
                        'Id':result.opportunities[i].Id,
                        'NameOpp':result.opportunities[i].NameOpp,
                        'UrlOpp':result.opportunities[i].UrlOpp,
                        'StageNameOpp':result.opportunities[i].StageNameOpp,
                        'AmountOpp':result.opportunities[i].AmountOpp
                    }]
                }
            }else{
                this.showToast("There has been an error",result.errorMessage,"error");
            }
        });
    }
    
    handleRowAction(event) {
        this.spinner=true;
        console.log(event.detail.action);
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.log(row.Id);
        console.log('actionName ' +actionName);
        switch (actionName) {
            case 'update_stage':
                this.updateStage(row.Id);
                break;
            //otras acciones
            default:
        }
    }
    
    updateStage(rowId) {
        console.log('update stage');
        updateOpportunity({
            recordId: rowId
        })
            .then(result => {
                this.loadOpportunities();
                this.spinner=false;
                this.showToast("Update Result",result,"info");
            
        });
    }
    
    
    
    showToast(tittle,error,variant) {
        const event = new ShowToastEvent({
            title: tittle,
            variant: variant,
            mode: "dismissable",
            icon: "utility:error",
            message: error
        });
        this.dispatchEvent(event);
    }
}