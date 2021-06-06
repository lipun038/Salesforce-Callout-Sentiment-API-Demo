public with sharing class SentimentAnalysis {
    @AuraEnabled
    public static String findSentiment(String msg) {
        try{
            //Creating Request Body
            JSONGenerator gen = JSON.createGenerator(true);    
            gen.writeStartObject();      
            gen.writeStringField('message', msg);
            gen.writeEndObject();    
	        String jsonRequestBody = gen.getAsString();
            //Making sentiment callout to external API
            HTTP h = new HTTP();
            HTTPRequest req = new HTTPRequest();
            req.setEndPoint('https://salesforcelwc.herokuapp.com/sentiment');
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setBody(jsonRequestBody);
            req.setTimeout(120000);
            HTTPResponse res = h.send(req);
            String responseBody = res.getBody(); 
            //Parsing response from sentiment API
            SentimentWrapper wrap = (SentimentWrapper)JSON.deserialize(responseBody, SentimentWrapper.class);
            return wrap.intensifier;
        }catch(Exception ex){
            return 'Error while processing request';
        }
    }
    public class SentimentWrapper{
        //1. intensifier ="Extremely Negative"
        //2. intensifier ="Negative"
        //3. intensifier ="Natural"
        //4. intensifier ="Positive"
        //5. intensifier = "Extremely Positive"
        String intensifier; 
    }
}
