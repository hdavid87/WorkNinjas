@RestResource(urlMapping='/api/Leads/*')
global without sharing class getLeads {
    @HttpGet
    global static leadsResponse getLeads() {
        leadsResponse resp = new leadsResponse();
        try{
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
        }catch(Exception e){
            resp.error=true;
            resp.errorMessage = 'There has been an error, please try again in a few minutes.';
            system.debug(e.getMessage()+' at line '+e.getLineNumber()+' '+e.getStackTraceString());
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