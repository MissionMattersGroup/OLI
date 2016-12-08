public class AddressTriggerHandler {

	public void onAfter(List<Address__c> newList) {
		setCurrentAddressFlag(newList);
		updateAddressContact(newList);
	}

	private void setCurrentAddressFlag(List<Address__c> newList) {
		Set<Id> clientIdSet = new Set<Id>();
		Set<Id> currentAddressIdSet = new Set<Id>();
		for(Address__c a : newList) {
			if(a.Current_Address__c) {
				currentAddressIdSet.add(a.Id);
				clientIdSet.add(a.Client__c);
			}
		}
		if(!currentAddressIdSet.isEmpty()) {
			List<Address__c> addressUpdateList = new List<Address__c>();
			for(Address__c a : [SELECT Id, Current_Address__c FROM Address__c WHERE Current_Address__c = true AND Client__c IN :clientIdSet AND Id NOT IN :currentAddressIdSet]) {
				a.Current_Address__c = false;
				addressUpdateList.add(a);
			}
			if(!addressUpdateList.isEmpty()) {
				update addressUpdateList;
			}
		}
	}

	private void updateAddressContact(List<Address__c> newList) {
		Map<Id, Address__c> addressByContactIdMap = new Map<Id, Address__c>();
		for(Address__c a : newList) {
			if(a.Current_Address__c) addressByContactIdMap.put(a.Client__c, a);
		}
		List<OLI_Client__c> contactList = [SELECT Id, Address_Type__c FROM OLI_Client__c WHERE Id IN :addressByContactIdMap.keySet()];
		for(OLI_Client__c c : contactList) {
			c.Address_Type__c = addressByContactIdMap.get(c.Id).Address_Type__c;
		}
		update contactList;
	}
}