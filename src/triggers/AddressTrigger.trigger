trigger AddressTrigger on Address__c (before insert, before update, after insert, after update) {

	AddressTriggerHandler handler = new AddressTriggerHandler();
	ClientAddressTriggerHandler objAddressTriggerHandler = new ClientAddressTriggerHandler();

    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        UpdateCountyTriggerHandler.updateAddress(Trigger.new);
    } else if (Trigger.isAfter) {
		if(Trigger.isInsert || Trigger.isUpdate) handler.onAfter(Trigger.new);
		if(Trigger.isInsert) {
			objAddressTriggerHandler.afterInsert(Trigger.new);
		}
	}
}