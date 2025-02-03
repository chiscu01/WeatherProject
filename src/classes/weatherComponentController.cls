public with sharing class weatherComponentController {

    @AuraEnabled(Cacheable=true)
    public static Map<String, Double> getCoordinates(String cityName) {
        System.debug('cityName'+cityName);
        String endpoint = 'callout:OpenMeteoCoordinates/v1/search?name=' + cityName + '&count=1&language=en&format=json';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

            if (responseMap.containsKey('results')) {
                List<Object> results = (List<Object>) responseMap.get('results');
                if (!results.isEmpty()) {
                    Map<String, Object> firstResult = (Map<String, Object>) results[0];

                    Double latitude = (Double) firstResult.get('latitude');
                    Double longitude = (Double) firstResult.get('longitude');

                    Map<String, Double> coordinates = new Map<String, Double>();
                    coordinates.put('latitude', latitude);
                    coordinates.put('longitude', longitude);

                    return coordinates;
                }
            }
        }
        throw new CalloutException('Error fetching coordinates or no results found.');
    }

    @AuraEnabled(Cacheable=true)
    public static String getWeather(String lat, String lon) {
        System.debug(lat);
        System.debug(lon);
        String url = 'callout:OpenMeteoWeather/v1/forecast?latitude='+lat + '&longitude='+lon+'&forecast_days=5&daily=temperature_2m_max,temperature_2m_min,weathercode';

        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            System.debug(res.getBody());
            return res.getBody();
        } else {
            throw new CalloutException('Error: ' + res.getStatus());
        }
    }
}