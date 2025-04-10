public with sharing class Opportunities_cont {
    
    @AuraEnabled
    public static oppResponse getOpportunities(){
        oppResponse resp = new oppResponse();
        try {
            Id idOwner = UserInfo.getUserId();
            if(idOwner!=null){
                List<Opportunity> opps = [SELECT Id,Name, Amount, StageName FROM Opportunity where ownerid =:idOwner and StageName!='Negotiation/Review' order by StageName asc,Name asc];
                if(!opps.isEmpty()){
                    for(Opportunity opp: opps){
                        opps oppRes = new opps();
                        oppRes.Id=opp.Id;
                        oppRes.NameOpp=opp.Name;
                        oppRes.UrlOpp='/'+opp.Id;
                        oppRes.StageNameOpp=opp.StageName;
                        oppRes.AmountOpp=opp.Amount;
                        resp.opportunities.add(oppRes);
                    }
                }else{
                    resp.error = true;
                    resp.errorMessage='No records found';
                }
            }else{
                resp.error=true;
                resp.errorMessage = 'You must provide an Onwer Id';
            }
        } catch (Exception e) {
            resp.error=true;
            resp.errorMessage = 'There has been an error at '+e.getLineNumber() + ' ' + e.getMessage();
        }
        system.debug('resp.opportunities: '+resp.opportunities);
        return resp;
    }
    
    @AuraEnabled
    public static string updateOpportunity(string recordId){
        string resp = '';
        try {
            if(recordId!=null){
                
                List<Opportunity> opp = [SELECT Id,Name, StageName,isClosed FROM Opportunity where Id=:recordId];
                if(!opp.isEmpty()){
                    if(opp[0].isClosed){
                        resp = 'You cannot edit a Closed Won record';
                    }else{
                        opp[0].StageName='Negotiation/Review';
                        update opp;
                        resp='Record updated succesfully';
                    }
                }else{
                    resp ='No record found with the Id '+recordId;
                }
            }else{
                resp='Record Id not found';
            }
        }catch(Exception e){
            
        }
        return resp;
    }
    
    public class oppResponse{
        @AuraEnabled public Boolean error;
        @AuraEnabled public String errorMessage;
        @AuraEnabled public List<opps> opportunities;
        public oppResponse(){
            error=false;
            errorMessage='';
            opportunities=new List<opps>();
        }
    }
    
    public class opps{
        @AuraEnabled public string Id;
        @AuraEnabled public string NameOpp;
        @AuraEnabled public string UrlOpp;
        @AuraEnabled public string StageNameOpp;
        @AuraEnabled public decimal AmountOpp;
        public opps(){
            Id='';
            NameOpp='';
            UrlOpp='';
            StageNameOpp='';
            AmountOpp=0;
        }   
    }
}