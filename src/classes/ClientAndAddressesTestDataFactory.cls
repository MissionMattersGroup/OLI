/**
 * Description : Utitlity class used in test class to test the functionality to update Client Record's Last Address with
 *               Client Address's Address if its 'Address Type' is 'Last Permanent Address' and change 'Address Type' 
 *               on Client Address to 'Previous Permanent Address' for any old Client Address record 
 *               associated to the client
 *
 *    Author          Date (dd-mm-yyyy)           Version                 ChangeLog
 *                    26/05/2016                    1.0                   Initial Draft
 */

public abstract class ClientAndAddressesTestDataFactory {

    // Method to returns 'n' Client records with the record type mentioned
    public static List<OLI_Client__c> getClientRecords(Integer recordsRequired, String strRecordType) {
    	
    	List<OLI_Client__c> listClient = new List<OLI_Client__c>();
    	
    	// Get record type id for the string being provided 
    	Id clientRecordTypeId = 
    	               Schema.SObjectType.OLI_Client__c.getRecordTypeInfosByName().get(strRecordType).getRecordTypeId();
    	
    	// Create dummy Client records to be tested
    	for(Integer recCount = 0; recCount < recordsRequired; recCount++){    		
    		
    		listClient.add(new OLI_Client__c(Name = 'Test'+recCount,
    		                                 First_Name__c = 'First'+recCount,
    		                                 Last_Name__c = 'Last'+recCount,
    		                                 Client_Status__c = 'Current',
    		                                 Our_Ladys_Inn_location__c = 'St. Louis',
    		                                 RecordTypeId = clientRecordTypeId));
    	}
    	
    	return listClient;
    }
        
    // Method to returns 'n' Address records associated with a Client with specified 'Address Type'
    public static List<Address__c> getAddressRecords(Integer recordsRequired, Id clientRecordId, 
                                                        String strAddressType) {
    	
    	List<Address__c> listAddresses = new List<Address__c>();
    	    	
    	// Create dummy Address records to be tested
    	for(Integer recCount = 0; recCount < recordsRequired; recCount++){    		
    		
    		listAddresses.add(new Address__c(Street__c = 'Street'+recCount,
	    		                             City__c = 'City'+recCount,
	    		                             State__c = 'State'+recCount,
	    		                             Zip__c = '4444'+recCount,
	    		                             County__c = 'US',
	    		                             Address_Type__c = strAddressType,
	    		                             Client__c = clientRecordId));
    	}
    	
    	return listAddresses;
    }
}