/**
 * Class to generated HTTP callout for Apex Tooling API
 */
public with sharing class GenerateApexClass{

    public static String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
    public static final String endpoint = baseUrl + '/services/data/v39.0/tooling/sobjects';

    public GenerateApexClass()
    {
        
    }

    // used receive response by sending a http request
    public static String getResponse(HttpRequest req)
    {
        try
        {
            Http httpreq = new Http();
            HttpResponse res = httpreq.send(req);
            String reqresponse = res.getBody();
            System.debug('status -->' + res.getStatus());
            return reqresponse;
        }
        catch (Exception e)
        {
            return 'Error:' +e.getMessage();
        }
    }

    /**
     * Create Http request for the specified endpoint and session. Invoke the specified method 
     */
    public static HttpRequest createHttpRequest(String endpointURL, String method, String sessionId)
    {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + sessionId);
        req.setHeader('Content-Type', 'application/json');
        //System.debug('endpointURL -->' + endpointURL);
        req.setEndpoint(endpointURL);
        req.setMethod(method);
        return req;
    }
}