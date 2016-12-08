/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_Client_ServiceTest
{
    private static testmethod void testTrigger()
    {
        // Force the dlrs_Client_ServiceTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new Client_Service__c());
    }
}