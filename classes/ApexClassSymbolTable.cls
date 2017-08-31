public class ApexClassSymbolTable {

    public static String endpointUrl = '';
    public static Map<String, Method> methodDetailsMap = new Map<String, Method>();
    public static Map<String, Constructor> constructorDetailsMap = new Map<String, Constructor>();

    public ApexClassSymbolTable (String apexClassName) {

        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        system.debug(baseUrl);
        String path = '/services/data/v39.0/tooling/query/?q=';
        String query = 'Select+Id,SymbolTable+From+ApexClass+WHERE+Name=\'' + apexClassName +'\'';
        
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());        
        request.setEndpoint(baseUrl + path + query);
        request.setMethod('GET');

       QueryResult result = (QueryResult)JSON.deserialize(
            new Http().send(request).getBody(), QueryResult.class
        );

        // All methods with their name and parameters
        for (Method method : result.records[0].symbolTable.methods) {
            if ((new Set<String> (method.modifiers)).contains('public')) {
                methodDetailsMap.put(method.name, method);
                System.debug('method.modifiers -->' + method.modifiers);
                System.debug('method name -->' + method.name);
                System.debug('method parameters -->' + method.parameters);
                System.debug('method.returnType -->' + method.returnType);
            }
        }

        for (Constructor constructor : result.records[0].symbolTable.constructors) {
            if ((new Set<String> (constructor.modifiers)).contains('public')) {
                constructorDetailsMap.put(constructor.name, constructor);
                System.debug('constructor.modifiers -->' + constructor.modifiers);
                System.debug('constructor name -->' + constructor.name);
                System.debug('constructor parameters -->' + constructor.parameters);
            }
        }

    }

    public class QueryResult {
        public final List<Record> records;
    }

    public class Record {
        public final SymbolTable symbolTable;
    }

    public class SymbolTable {
        public final List<Method> methods {get; set;}
        public final List<Constructor> constructors {get; set;}
    }

    public class Method {
        public final List<String> modifiers {get; set;}
        public final String name {get; set;}
        public final List<Parameter> parameters {get; set;}
        public final String returnType {get; set;}
    }

    public class Constructor {
        public final List<String> modifiers {get; set;}
        public final String name {get; set;}
        public final List<Parameter> parameters {get; set;}
    }

    public class Parameter {
        public final String name {get; set;}
        public final String type {get; set;}
    }
}