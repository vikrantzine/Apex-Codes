public with sharing class ContactTriggerHandler {
    //Task 2
    public static void totalContactCount(List<Contact> conList){
       Set<Id> accIds = new Set<Id>();
        for(Contact con : conList){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
            }
        }
        if(!accIds.isEmpty()){
            list<Account> accList = [SELECT Id, (SELECT Id FROM Contacts)FROM Account WHERE Id IN :accIds];
            for(Account acc:accList){
                acc.Count_Number_Of_Contact__c=acc.Contacts.size();
            }
            if(!accList.isEmpty()){
                update accList;
            }
        }
    }

    //Task 4
    public static Boolean isTriggerAlreadyFired = false;
    public static void updateLasNameofUpdatedCon(List<Contact> conList) {
        if (isTriggerAlreadyFired) {
            return;
        }
        isTriggerAlreadyFired = true;
 
        Set<Id> accIds = new Set<Id>();
        for(Contact con:conList){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
            }
        }
        List<Contact> conL=[SELECT Id, LastName, AccountId FROM Contact WHERE AccountId IN :accIds ORDER BY LastModifiedDate DESC]; 
        List<Contact> updateCon = new List<Contact>();
 
        for(Integer i=0; i<conL.size(); i++){
            Contact co=conL[i];
            co.LastName=co.LastName.replaceAll('[0-9]', '');
            co.LastName=co.LastName+' '+(i+1);
            updateCon.add(co);
        }
        if (!updateCon.isEmpty()) {
            update updateCon;
        }
    }
    public static void dm(List<Contact> conList){
  Set<Id>accIds=new Set<Id>();
  Map<Id,Integer>conCount=new Map<Id,Integer>();
  for(Contact con:conList){
   if(con.AccountId!=NULL){
    accIds.add(con.AccountId);
   }
  }
  List<Account> accList=[SELECT Id,Name,(SELECT Id FROM Contacts) FROM Account WHERE Id IN:accIds];
  for(Account acc:accList){
   conCount.put(acc.Id,acc.Contacts.size());
  }
  for(Contact con:conList){
   Integer count=conCount.get(con.AccountId);
   if(count != NULL && count >= 2){
    con.addError('Please check your Account Have Already 2 contacts');
   }
  }
 }
}