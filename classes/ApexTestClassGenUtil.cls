public class ApexTestClassGenUtil{

        public static String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        public static String endpoint = baseUrl + '/services/data/v39.0/tooling/sobjects';
        public static Map<String, Object> results = new Map<String, Object>();
        public static Id oid;
       
               
    public static void generateApexTestClass(String apexClassName, String jsonData, String classType) {
        
        EmailTemplate emailTemplateInstance = null;
        Id ApexClassOrTriggerId;
         
        
        if (classType == 'ApexClass') {
            emailTemplateInstance =
                [
                    SELECT
                        Name,
                        Id
                    FROM
                        EmailTemplate
                    WHERE DeveloperName = 'GenerateTestClassTemplate'
                ];
            ApexClassOrTriggerId = [Select Id From ApexClass WHERE Name =:apexClassName].id;
        } else {
            emailTemplateInstance =
                [
                    SELECT
                        Name,
                        Id
                    FROM
                        EmailTemplate
                    WHERE DeveloperName = 'GenerateTriggerTestClassTemplate'
                ];
                ApexClassOrTriggerId = [SELECT Id FROM ApexTrigger WHERE Name =:apexClassName].id;
            
        }
        if (emailTemplateInstance != null) {

            try {
                 // Pass JSON data to VF component's controller
                results = (Map<String, Object>)JSON.deserializeUntyped(jsonData);
                createApexClass(emailTemplateInstance.Id, ApexClassOrTriggerId, UserInfo.getSessionId());
                executeTestClass(oid, UserInfo.getSessionId());
                testClassCodeCoverage(ApexClassOrTriggerId,  oid, UserInfo.getSessionId());
                               
            }catch (Exception expectionInstance) {
                
            }
        }
    }

    public static void createApexClass(Id emailTemplateInstanceId, String apexClassId, String sessionId) {
        
        try {
            Messaging.SingleEmailMessage templateInstance =
                Messaging.renderStoredEmailTemplate(emailTemplateInstanceId, UserInfo.getUserId(), apexClassId);
            String apexClassString = templateInstance.getPlainTextBody().escapeJava();
            apexClassString = apexClassString.unescapeHtml4();
            apexClassString = apexClassString.replace('\\r\\n','\\r\\n');

            // create a Http request with post method
            HttpRequest request =
                GenerateApexClass.createHttpRequest(
                    endpoint + '/ApexClass',
                    'POST',
                    sessionId
                );
            request.setBody( '{"Name":"","Body":"' + apexClassString + '"}');

            // send request and receive response
            String response = GenerateApexClass.getResponse(request);
            ResponseWrapper resWrap = (ResponseWrapper)JSON.deserialize(response, ResponseWrapper.class);
            oid = resWrap.id;
            
        } catch (Exception exceptionInstance) {
            
        } 
    }
     public static void executeTestClass(Id apexTestClassId, String sessionId) {
        String path = '/services/data/v39.0/tooling/runTestsAsynchronous';

        try {
            HttpRequest request =
                GenerateApexClass.createHttpRequest(baseUrl + path, 'POST', sessionId);
            request.setBody('{"classids":"' + apexTestClassId + '"}');
            String response = GenerateApexClass.getResponse(request);
        } catch (Exception exceptionInstance) {
            
        }
    }

    public static void testClassCodeCoverage(Id apexClassOrTriggerId, Id apexTestClassId, String sessionId) {

        String path = '/services/data/v39.0/tooling/query/?q=';
        String query =
            'SELECT+Coverage,NumLinesCovered,NumLinesUncovered+' +
            'FROM+ApexCodeCoverageAggregate+' +
            'WHERE+ApexClassOrTriggerId=\''+ apexClassOrTriggerId +'\'';

        try {
            HttpRequest request =
                GenerateApexClass.createHttpRequest(baseUrl + path + query, 'GET', sessionId);
            String response = GenerateApexClass.getResponse(request);
        } catch (Exception exceptionInstance) {
        }
    }

    public class ResponseWrapper {
        String Id = null;
        Boolean success = null;
        List<String> errors = new List<String>();
    }
}