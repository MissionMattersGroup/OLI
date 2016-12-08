@isTest
public class AddressTrigger_Test {

	@isTest
	static void testUpdateAddressContact() {
		Test.startTest();
		OLI_Client__c testClient = (OLI_Client__c)SmartFactory.createSobject('OLI_Client__c');
		insert testClient;
		Address__c testAddress = (Address__c)SmartFactory.createSobject('Address__c');
		testAddress.Street__c = 'Test Street';
		testAddress.City__c = 'Test City';
		testAddress.State__c = 'TN';
		testAddress.Zip__c = '11111';
		testAddress.Current_Address__c = true;
		testAddress.Client__c = testClient.Id;
		testAddress.Address_Type__c = 'Test Type';
		insert testAddress;
		System.assertEquals('Test Type', [SELECT Address_Type__c FROM OLI_Client__c WHERE Id = :testClient.Id].Address_Type__c);
		Test.stopTest();
	}

	@isTest
	static void testSetCurrentAddressFlag() {
		Test.startTest();
		TestFactory factory = new TestFactory(10);
		factory.getTestAddressMap();
		Address__c testAddress = (Address__c)SmartFactory.createSobject('Address__c', false);
		testAddress.Current_Address__c = true;
		testAddress.Client__c = factory.testClient.Id;
		insert testAddress;
		System.assertEquals(1, [SELECT count() FROM Address__c WHERE Current_Address__c = true AND Client__c = :factory.testClient.Id]);
		testAddress = [SELECT Id, Current_Address__c FROM Address__c WHERE Client__c = :factory.testClient.Id AND Current_Address__c = false LIMIT 1];
		testAddress.Current_Address__c = true;
		update testAddress;
		System.assertEquals(1, [SELECT count() FROM Address__c WHERE Current_Address__c = true AND Client__c = :factory.testClient.Id]);
		Test.stopTest();
	}

	class TestFactory {

		Integer recordCount { get; set; }
		List<Address__c> testAddressList { get; set; }
		OLI_Client__c testClient { get; set; }

		TestFactory(Integer count) {
			recordCount = count;
			setTestAddressList();
		}

		public Map<Id, Address__c> getTestAddressMap() {
			insert testAddressList;
			return new Map<Id, Address__c>(testAddressList);
		}

		public List<Address__c> getTestAddressList() {
			return testAddressList;
		}

		public void setTestAddressList() {
			testClient = (OLI_Client__c)SmartFactory.createSobject('OLI_Client__c', false);
			insert testClient;
			testAddressList = (List<Address__c>)SmartFactory.createSObjectList('Address__c', false, recordCount);
			String addyString = 'abcdefghij';
			for(Integer i=0; i<testAddressList.size(); i++) {
				testAddressList[i].Client__c = testClient.Id;
				testAddressList[i].Current_Address__c = false;
			}
			testAddressList[0].Current_Address__c = true;
		}
	}
}