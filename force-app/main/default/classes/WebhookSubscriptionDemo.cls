@RestResource(urlMapping='/api/Webhooks/pushDetailsdemo/*')
global with sharing class WebhookSubscriptionDemo{
    @HttpPost
    global static void handleNotification(){
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String hashedval = request.headers.get('X-Hub-Signature-256');
        Blob bB = request.requestBody;
        JSONParser parser = JSON.createParser(request.requestbody.toString());
        pusher ps;
        head_commit hc;  
        String repo;
        while(parser.nextToken()!=null)
        {
            if(parser.getText() == 'pusher'){
                System.debug('Inside Pusher');
                parser.nextToken();
                ps = (pusher)parser.readValueAs(pusher.class);
                System.debug(ps);
            }
            if(parser.getText()=='head_commit'){
                System.debug('Inside Head Commit');
                parser.nextToken();
                hc = (head_commit)parser.readValueAs(head_commit.class);
                System.debug(hc);
            }
            if(parser.getText() == 'full_name'){
                System.debug('Inside Full Name');
                parser.nextToken();      
                repo = parser.getText();
                System.debug(repo);
            }
        }
        GIT_PushDetail__c detail = new GIT_PushDetail__c();
        detail.Commiter_Name__c = ps!=null?ps.name:'';
        detail.Commiter_Email__c = ps!=null?ps.email:'';
        detail.Commit_Message__c = hc!=null?hc.message:'';
        //detail.Commit_Timestamp__c = hc!=null?hc.timestamp:'';
        detail.Committed_URL__c = hc!=null?hc.url:'';
        detail.Repository_Name__c = repo;
        // detail.Added_Components__c = hc!=null&&hc.added!=null?String.join(hc.added,','):'';
        // detail.Removed_Components__c = hc!=null&&hc.removed!=null?String.join(hc.removed,','):'';
        // detail.Modified_Components__c = hc!=null&&hc.modified=null?String.join(hc.modified,','):'';
        insert detail;  
        response.statusCode = 200;
        response.responseBody = Blob.valueOf(JSON.serialize(new SFDCResponse('Success','Processed Successfully')));
    }
public class SFDCResponse{
    String response;
    String message;
    public SFDCResponse(String resp,String msg){
        response = resp;
        message = msg;
    }
}
public class pusher{
    public string name;
    public string email;
    public pusher(String name,String email){
        name = name;
        email = email;
    }
}
public class head_commit{
    public string message;
    //public String timestamp;
    public string url;
    public head_commit(String message,String timestamp,String url){
        message = message;
        //timestamp = timestamp;
        url = url;
    }
}
}