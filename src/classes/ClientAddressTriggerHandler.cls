/*
 * Description : This Trigger handler is used to changed the Address type to previous permanent address when Last 
 				 Permanent Address (At Last 90 Nights) type of record is already present And Update last permanent 
 				 Address values to the related client mother record
 *                
 * Version              Author           Date (MM-DD-YYYY)        Change Log
 * 1.0                 Anuradha N          05/26/2016             Initial Draft
 */
public with sharing class ClientAddressTriggerHandler {
	
	// Static strinf for Address Type equals Last Permanent Address (at least 90 nights)
    public static string AddressTypeLastParmanent = 'Last Permanent Address (at least 90 nights)';
    
    // Static strinf for Address Type equals Previous Permanent Address
    public static string AddressTypePreviousParmanent = 'Previous Permanent Address';
    
    //Map of ClientId and AddressId
    public map<Id, Id> mapClientId_AddressId;
    
    /**
     * Description: This method will genrate the set of client id and address id
     * Input: Client Address Records
     * Output: Update the Address and client Records
    */
	public void afterInsert(list<Address__c> lstAddress)
    {
    	set<Id> setClientId = new set<Id>();
    	mapClientId_AddressId = new map<Id, Id>();
    	
        for(Address__c objAddress: lstAddress)
        {
        	if(objAddress.Client__c != null) {
            	setClientId.add(objAddress.Client__c);
        	}
        }
        if(!setClientId.isEmpty())
        {
            updatePermanentAddressOnClient (lstAddress);
            updateAddressTypeOnClientAddress(setClientId);
        }
    }
    
    /**
     * Description: This method will query the client records that are related to client address and update client with 
     				last permanent Address 
     * Input: lstAddress- list of newly inserted address
     * Output: Update the Client Records
    */
    public void updatePermanentAddressOnClient(list<Address__c> lstAddress)
    {
    	map<Id,OLI_Client__c> mapClientId_Client = new map<Id,OLI_Client__c>();
    	
    	for(Address__c objAddress: lstAddress) 
    	{
    		if (objAddress.Address_Type__c == AddressTypeLastParmanent && objAddress.Client__c != null) {
    				
			   OLI_Client__c objOLIClient = new OLI_Client__c();
			   
			   objOLIClient.Id = objAddress.Client__c;
               objOLIClient.Last_Permenant__c = objAddress.Street__c;
               objOLIClient.Last_Permanent_City__c = objAddress.City__c;
               objOLIClient.Last_Permanent_County__c = objAddress.County__c;
               objOLIClient.Last_Permanent_State__c = objAddress.State__c;
               objOLIClient.Last_Permanent_Zip__c = objAddress.Zip__c;
               
               mapClientId_Client.put(objOLIClient.Id,objOLIClient);
               
               mapClientId_AddressId.put(objAddress.Client__c,objAddress.Id);
    		}
    	}
        
        //Check client list is empty or not
        if(!mapClientId_Client.isEmpty())
        {
            update mapClientId_Client.values();
        }
    }
    
    /**
     * Description: This method will query the client address records that has Address type last permanent Address
     				and update it to Previous permanent Address 
     * Input: setClientId - client id related to client Addres
     * Output: Update the Address Records
    */
    public void updateAddressTypeOnClientAddress(set<Id> setClientId)
    {
    	if (!setClientId.isEmpty() && !mapClientId_AddressId.Values().isEmpty()) {
	    	map<Id, list<Address__c>> mapAddressId_lstAddress = new map<Id, list<Address__c>>();
	    	
	    	list<Address__c> lstAddressToUpdateAddressType = new list<Address__c>();
	    	
	    	list<Address__c> lstAddress = [Select Id,Client__c,Address_Type__c From Address__c 
	    								   where Client__c IN: setClientId And Id NOT IN: mapClientId_AddressId.Values()];
	    													  
	    	for(Address__c objAddress: lstAddress) {
	    		if(mapClientId_AddressId.containsKey(objAddress.Client__c)) {
	    			if (ObjAddress.Address_Type__c == AddressTypeLastParmanent) {
    					ObjAddress.Address_Type__c = AddressTypePreviousParmanent;
    				    lstAddressToUpdateAddressType.add(ObjAddress);
    				}
	    		}
	    	}
	    	//Check client Address list is empty or not
	    	if(!lstAddressToUpdateAddressType.isEmpty())
	        {
	            update lstAddressToUpdateAddressType;
	        }
    	}
    }
}