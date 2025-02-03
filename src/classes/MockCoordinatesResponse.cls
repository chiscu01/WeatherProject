/**
 * Created by chiscu on 2/3/2025.
 */

public with sharing class MockCoordinatesResponse implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"results":[{"latitude":51.5074,"longitude":-0.1278}]}');
        res.setStatusCode(200);
        return res;
    }
}