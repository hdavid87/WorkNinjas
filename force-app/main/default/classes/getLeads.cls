@RestResource(urlMapping='/api/Leads/*')
global without sharing class getLeads {
    @HttpGet
    global static leadsResponse getLeads() {
        leadsResponse resp = new leadsResponse();
        string email = RestContext.request.params.get('email');
        
        if(email!=null){
            list<Lead> leads = [SELECT Id, Name, FirstName,LastName, Email FROM Lead where Email =:email];
            if(!leads.isEmpty()){
                resp.resultLeads = leads;
            }else{
                resp.error=true;
                resp.errorMessage='No records found';
            }
        }else{
            resp.error=true;
            resp.errorMessage = 'You must provide an email to search for';
        }
        
        return resp;
    }
    
    global class leadsResponse{
        list<Lead> resultLeads;
        Boolean error;
        string errorMessage;
        global leadsResponse(){
            resultLeads = new list<Lead>();
            error = false;
            errorMessage = '';
        }
    }
    
}