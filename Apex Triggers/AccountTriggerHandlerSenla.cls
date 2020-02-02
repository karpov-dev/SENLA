public class AccountTriggerHandlerSenla extends TriggerHandlerSenla{
    
    public override void afterInsert(){
        List<Contact> contacts = new List<Contact>();
        for(SObject currentAcc : Trigger.new){
            Account account = (Account)currentAcc;
            contacts.add(new Contact(LastName = account.Name, AccountId = account.Id));
        }
        insert contacts;
    }

    public override void afterUpdate(){
        List<Account> accountsWithContscts = [SELECT Name, (SELECT FirstName FROM Contacts) FROM Account WHERE Id IN :Trigger.new];
        List<Contact> contactsForUpdate = new List<Contact>();
        for(Account account : accountsWithContscts){
            List<Contact> contacts = account.Contacts;
            for(Integer i = 0; i < contacts.Size(); i++){
                if(account.Name != contacts[i].FirstName){
                    contacts[i].FirstName = account.Name;
                    contactsForUpdate.add(contacts[i]);
                }
            }
        }
        update contactsForUpdate;
    }
}