/**
 * Description : Test class used in testing the functionality to update Client Record's Last Address with
 *               Client Address's Address if its 'Address Type' is 'Last Permanent Address' and change 'Address Type' 
 *               on Client Address to 'Previous Permanent Address' for any old Client Address record 
 *               associated to the Client record
 *
 *    Author          Date (dd-mm-yyyy)           Version                 ChangeLog
 *    Anuradha N        26/05/2016                  1.0                   Initial Draft
 */

@isTest
private class ClientAddressTriggerHandlerTest {
    
    @testSetup static void setupTestData() {
    	
    	// Create Client records
    	List<OLI_Client__c> listClient = ClientAndAddressesTestDataFactory.getClientRecords(10,'Mother');    	
    	insert listClient;    	
    }
    
    // Method to test trigger when Client has Last Address and new Address record is created
    static testMethod void methodForClientWithValueInLastAddress(){
    	
    	// Get a client record
    	OLI_Client__c objClient = [Select Id,
                                          Last_Permenant__c,
                                          Last_Permanent_City__c,
                                          Last_Permanent_County__c,
                                          Last_Permanent_State__c,
                                          Last_Permanent_Zip__c
                                   From   OLI_Client__c
                                   Limit  1];
        
        // Assign some value in the Last address and update the record
        objClient.Last_Permenant__c = 'Test Address';
        objClient.Last_Permanent_City__c = 'Test City';
        objClient.Last_Permanent_County__c = 'US';
        objClient.Last_Permanent_State__c = 'Test State';
        objClient.Last_Permanent_Zip__c = '74849';
        
        update objClient;
        
        // Get the Address records from the utility class and insert the records
        List<Address__c> listAddresses = ClientAndAddressesTestDataFactory.getAddressRecords(1,
								                                                             objClient.Id,
								                                        'Last Permanent Address (at least 90 nights)');
		Test.startTest();
		insert listAddresses;
		Test.stopTest();
		
		// Get a client record
    	OLI_Client__c objUpdatedClient = [Select Id,
	                                             Last_Permenant__c,
	                                             Last_Permanent_City__c,
	                                             Last_Permanent_County__c,
	                                             Last_Permanent_State__c,
	                                             Last_Permanent_Zip__c
	                                      From   OLI_Client__c
	                                      Where  Id =: objClient.Id
	                                      Limit  1];	
	                                      
	    // Assert if the update is successful
	    System.assertEquals(objUpdatedClient.Last_Permenant__c, listAddresses[0].Street__c); 
	    System.assertEquals(objUpdatedClient.Last_Permanent_City__c, listAddresses[0].City__c);
	    System.assertEquals(objUpdatedClient.Last_Permanent_State__c, listAddresses[0].State__c);
	    System.assertEquals(objUpdatedClient.Last_Permanent_Zip__c, listAddresses[0].Zip__c);
	    System.assertEquals(objUpdatedClient.Last_Permanent_County__c, listAddresses[0].County__c);                                 			                                        
    }  
    
    // Method to test trigger when Client has an existing Address record and new Address record is created
    static testMethod void methodForClientWithExistingAddressRecordAndNewAddressIsCreated(){
    	
    	// Get a client record
    	OLI_Client__c objClient = [Select Id
                                   From   OLI_Client__c
                                   Limit  1]; 
                                   
        Test.startTest();
        
        // Get the Address records from the utility class
        List<Address__c> listAddresses = ClientAndAddressesTestDataFactory.getAddressRecords(2,
								                                                             objClient.Id,
								                                         'Last Permanent Address (at least 90 nights)');
		// Create existing record
		insert listAddresses[0];
		
		// Create new record
		insert listAddresses[1];
								                                        
		Test.stopTest();
		
		// Get the client record
    	OLI_Client__c objUpdatedClient = [Select Id,
	                                             Last_Permenant__c,
	                                             Last_Permanent_City__c,
	                                             Last_Permanent_County__c,
	                                             Last_Permanent_State__c,
	                                             Last_Permanent_Zip__c
	                                      From   OLI_Client__c
	                                      Where  Id =: objClient.Id];	
	                                     
	    // Assert if update on Client is successful
	    System.assertEquals(objUpdatedClient.Last_Permenant__c, listAddresses[1].Street__c); 
	    System.assertEquals(objUpdatedClient.Last_Permanent_City__c, listAddresses[1].City__c);
	    System.assertEquals(objUpdatedClient.Last_Permanent_State__c, listAddresses[1].State__c);
	    System.assertEquals(objUpdatedClient.Last_Permanent_Zip__c, listAddresses[1].Zip__c);
	    System.assertEquals(objUpdatedClient.Last_Permanent_County__c, listAddresses[1].County__c);		
	    
	    // Get Address record which has been updated
	    List<Address__c> listUpdatedAddresses = [Select  Id,
							   						     Address_Type__c
							   				     From    Address__c
							   				     Where   Client__c =: objUpdatedClient.Id And
							   				             Street__c =: listAddresses[0].Street__c And
							   				             City__c =: listAddresses[0].City__c And 
							   				             State__c =: listAddresses[0].State__c And
							   				             Zip__c =: listAddresses[0].Zip__c And 
							   				             County__c =: listAddresses[0].County__c];
	   				    
	    // Assert if update on Address is successful
	    System.assertEquals('Previous Permanent Address', listUpdatedAddresses[0].Address_Type__c);                                        
    }  
    
    // Method to test trigger when Client does not have any Address record and many new Address records is created
    static testMethod void methodForClientWithMultipleNewAddressesBeingCreated(){
    	
    	// Get a client record
    	OLI_Client__c objClient = [Select Id
                                   From   OLI_Client__c
                                   Limit  1]; 
                                   
        Test.startTest();
        
        // Get the Address records from the utility class and insert the records
        List<Address__c> listAddresses = ClientAndAddressesTestDataFactory.getAddressRecords(2,
								                                                             objClient.Id,
								                                         'Last Permanent Address (at least 90 nights)');		
		insert listAddresses;
		                                      
		Test.stopTest();
		
		// Get Address record which has been updated
	    List<Address__c> listUpdatedAddresses = [Select  Id,
							   						     Address_Type__c,
							   						     Street__c,
							   				             City__c,
							   				             State__c,
							   				             Zip__c,
							   				             County__c
							   				     From    Address__c
							   				     Where   Client__c =: objClient.Id And
							   				             Address_Type__c =: 
							   				                             'Last Permanent Address (at least 90 nights)'];
		
		/* Assert if update on Address is successful and only one Address record is present with the Address Type 
		   'Last Permanent Address (at least 90 nights)'
		*/
	    System.assertEquals(1, listUpdatedAddresses.size());	
	    
	    // Get the updated client record
    	OLI_Client__c objUpdatedClient = [Select Id,
	                                             Last_Permenant__c,
	                                             Last_Permanent_City__c,
	                                             Last_Permanent_County__c,
	                                             Last_Permanent_State__c,
	                                             Last_Permanent_Zip__c
	                                      From   OLI_Client__c
	                                      Where  Id =: objClient.Id];
	     
	    // Assert if update on Client is successful
	    System.assertEquals(objUpdatedClient.Last_Permenant__c, listUpdatedAddresses[0].Street__c); 
	    System.assertEquals(objUpdatedClient.Last_Permanent_City__c, listUpdatedAddresses[0].City__c);
	    System.assertEquals(objUpdatedClient.Last_Permanent_State__c, listUpdatedAddresses[0].State__c);
	    System.assertEquals(objUpdatedClient.Last_Permanent_Zip__c, listUpdatedAddresses[0].Zip__c);
	    System.assertEquals(objUpdatedClient.Last_Permanent_County__c, listUpdatedAddresses[0].County__c);                                					   				                             
    }
    
    // Method to test trigger for multiple Client with single Address records
    static testMethod void methodForClientWithMultipleClientWithSingleNewAddresses(){
    	
    	// Get client records
    	List<OLI_Client__c> listClient = [Select Id
                                          From   OLI_Client__c]; 
        
        List<Address__c> listAddresses = new List<Address__c>();
        
        // Map to assert when update on client is successful after the trigger is exicuted
        Map<Id,Address__c> mapToCheckClientsAddressEqualsAddresses = new Map<Id,Address__c>();
        
        // Get the Address records from the utility class
        for(OLI_Client__c objClient:listClient){
        	List<Address__c> listTempAddresses = ClientAndAddressesTestDataFactory.getAddressRecords(1,
								                                                                 objClient.Id,
								                                        'Last Permanent Address (at least 90 nights)');
        	listAddresses.addAll(listTempAddresses);
        	
        	// Add the client Id and address to the map
			mapToCheckClientsAddressEqualsAddresses.put(objClient.Id,listTempAddresses[0]);					                                        
        }
        
        Test.startTest();
		insert listAddresses;               
		Test.stopTest();  
		
		// Get the updated client record
    	List<OLI_Client__c> listUpdatedClient = [Select Id,
					                                    Last_Permenant__c,
					                                    Last_Permanent_City__c,
					                                    Last_Permanent_County__c,
					                                    Last_Permanent_State__c,
					                                    Last_Permanent_Zip__c
					                             From   OLI_Client__c
					                             Where  Id In: new Set<OLI_Client__c>(listClient)];    
	                                      
	     for(OLI_Client__c objClient:listUpdatedClient){
	     	if(mapToCheckClientsAddressEqualsAddresses.containsKey(objClient.Id)){
	     		
	     		// Assert if update on Client is successful
			    System.assertEquals(objClient.Last_Permenant__c, 
			                                       mapToCheckClientsAddressEqualsAddresses.get(objClient.Id).Street__c); 
			    System.assertEquals(objClient.Last_Permanent_City__c, 
			                                         mapToCheckClientsAddressEqualsAddresses.get(objClient.Id).City__c);
			    System.assertEquals(objClient.Last_Permanent_State__c, 
			                                        mapToCheckClientsAddressEqualsAddresses.get(objClient.Id).State__c);
			    System.assertEquals(objClient.Last_Permanent_Zip__c, 
			                                          mapToCheckClientsAddressEqualsAddresses.get(objClient.Id).Zip__c);
			    System.assertEquals(objClient.Last_Permanent_County__c, 
			                                       mapToCheckClientsAddressEqualsAddresses.get(objClient.Id).County__c); 
	     	}
	     }                                                    
    }
}