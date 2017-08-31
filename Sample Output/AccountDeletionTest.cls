@isTest 
private class AccountDeletionTest {
        

            @isTest
            static void TestDeleteAccountWithOneOpportunity() {
                // Test data setup
                List<account> accountList =
                    createaccountTestData(1);

                List<opportunity> opportunityList = 
                    createopportunityTestData(accountList, 1);

                // Perform test
                Test.startTest();
                List<Database.deleteResult> result = Database.delete(accountList, false);
                Test.stopTest();
                for (Database.deleteResult r : result) {
                    // Verify that the deletion should have been stopped by the trigger,
                    // so check that we got back an error.
                    System.assert(!r.isSuccess());
                    System.assert(r.getErrors().size() > 0);
                    System.assertEquals('Cannot delete account with related opportunities.', r.getErrors()[0].getMessage());
                }
            }
        

            @isTest
            static void TestDeleteBulkAccountWithOneOpportunity() {
                // Test data setup
                List<account> accountList =
                    createaccountTestData(5);

                List<opportunity> opportunityList = 
                    createopportunityTestData(accountList, 1);

                // Perform test
                Test.startTest();
                List<Database.deleteResult> result = Database.delete(accountList, false);
                Test.stopTest();
                for (Database.deleteResult r : result) {
                    // Verify that the deletion should have been stopped by the trigger,
                    // so check that we got back an error.
                    System.assert(!r.isSuccess());
                    System.assert(r.getErrors().size() > 0);
                    System.assertEquals('Cannot delete account with related opportunities.', r.getErrors()[0].getMessage());
                }
            }
        

            @isTest
            static void TestDeleteAccountWithNoOpportunities() {
                // Test data setup
                List<account> accountList =
                    createaccountTestData(1);

                List<opportunity> opportunityList = 
                    createopportunityTestData(accountList, 0);

                // Perform test
                Test.startTest();
                List<Database.deleteResult> result = Database.delete(accountList, false);
                Test.stopTest();
                for (Database.deleteResult r : result) {
                    // Verify that the deletion was successful
                    System.assert(r.isSuccess());
                }
            }
            private static List<account> createaccountTestData(Integer numberOfrecords) {
                List<account> accountList = new List<account>();

                for (Integer i = 0; i < numberOfrecords ; i++) {
                    accountList.add(
                        new account (
                            Name = 'TestData'
                        )
                    );
                }
                insert accountList;
                return accountList;
            }
            private static List<opportunity> createopportunityTestData(List<account> accountList , Integer numberOfrecords) {
                List<opportunity> opportunityList = new List<opportunity>();

                for (Integer j = 0; j < accountList.size(); j++) {
                    account accountObj = accountList[j];
                    for (Integer k = 0; k < numberOfrecords; k++) {
                        opportunityList.add(
                            new opportunity (
                                Name = 'TestData' ,
                                StageName = 'TestData' ,
                                CloseDate = Date.valueOf('2017-08-29 00:00:00') ,
                                AccountId = AccountObj.Id
                            )
                        );
                    }
                }
                insert opportunityList;
                return opportunityList;
            } 
}