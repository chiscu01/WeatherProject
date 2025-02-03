/**
 * Created by chiscu on 2/3/2025.
 */

public with sharing class MockWeatherResponse implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"daily":{"temperature_2m_max":[15,16,17,18,19],"temperature_2m_min":[8,9,10,11,12],"weathercode":[1,2,3,4,5]}}');
        res.setStatusCode(200);
        return res;
    }
}