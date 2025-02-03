/**
 * Created by chiscu on 2/3/2025.
 */

@isTest
public class weatherComponentControllerTest {

    @isTest
    static void testGetCoordinates() {
        Test.startTest();

        String cityName = 'London';
        Test.setMock(HttpCalloutMock.class, new MockCoordinatesResponse());
        Map<String, Double> result = weatherComponentController.getCoordinates(cityName);

        Test.stopTest();

        System.assertNotEquals(result, null);
        System.assert(result.containsKey('latitude'));
        System.assert(result.containsKey('longitude'));
    }

    @isTest
    static void testGetWeather() {
        Test.startTest();

        String lat = '51.5074';
        String lon = '-0.1278';
        Test.setMock(HttpCalloutMock.class, new MockWeatherResponse());
        String result = weatherComponentController.getWeather(lat, lon);

        Test.stopTest();

        System.assertNotEquals(result, null);
        System.assert(result.contains('temperature_2m_max'));
        System.assert(result.contains('temperature_2m_min'));
    }
}