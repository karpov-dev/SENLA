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
        List<Account> newAccounts = (List<Account>)Trigger.new;
        List<Account> oldAccounts = (List<Account>)Trigger.old; 
        List<Id> newAccountsIds = GetIds(newAccounts);
        List<Contact> contacts = [SELECT FirstName, Id, AccountId FROM Contact WHERE AccountId = :newAccountsIds];
        List<Contact> contactsForUpdate = new List<Contact>();
        for(Integer i = 0; i < newAccounts.size(); i++){
            if(newAccounts[i].Name != oldAccounts[i].Name){
                for(Contact contact : contacts){
                    if(contact.AccountId == newAccounts[i].Id){
                        contact.FirstName = newAccounts[i].Name;
                        contactsForUpdate.add(contact);
                    }
                }
            }
        }
        update contactsForUpdate;
    }

    //получает List<id> обновленных аккаунтов 
    public List<Id> GetIds(List<Account> accounts){
        List<Id> Ids = new List<Id>();
        for(Account account : accounts){
            Ids.add(account.Id);
        }
        return Ids;
    }
}
