import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getWeather from '@salesforce/apex/weatherComponentController.getWeather';
import getCoordinates from '@salesforce/apex/weatherComponentController.getCoordinates';
import rainyIcon from '@salesforce/resourceUrl/rain';
import snowIcon from '@salesforce/resourceUrl/snow';
import sunnyIcon from '@salesforce/resourceUrl/sunny';
import cloudyIcon from '@salesforce/resourceUrl/cloudy';

export default class WeatherComponent extends LightningElement {
    @api recordId;
    @api fieldApiName;
    @api objectApiName;
    weatherData;
    city;

    get fields(){
        return [`${this.objectApiName}.${this.fieldApiName}`];
    }

    @wire(getRecord, {
        recordId: '$recordId',
        fields:  '$fields'
    })
    record({ error, data }) {
          if (data) {
              const city = data.fields[this.fieldApiName];
              if (city && city.value) {
                  this.city = city.value;
              } else {
                  this.city = null;
              }
              getCoordinates({ cityName: this.city })
                  .then((result) => {
                      if (result) {
                          if (result.latitude && result.longitude) {
                              this.callGetWeather(result.latitude,result.longitude);
                          } else {
                              console.error('Invalid coordinates received:', result);
                          }
                      }
                  })
                  .catch((error) => {
                      console.error('Error fetching coordinates:', error);
                  });
          }
    }

    callGetWeather(lat, lon) {
         getWeather({ lat: lat, lon: lon })
                .then((data) => {
                    this.weatherData = JSON.parse(data);
                    this.error = undefined;

                    this.forecastData = this.weatherData.daily.time.map((date, index) => {
                        const weatherCode = this.weatherData.daily.weathercode[index];
                        return {
                            date: date,
                            tempMax: this.weatherData.daily.temperature_2m_max[index],
                            tempMin: this.weatherData.daily.temperature_2m_min[index],
                            weatherCode: this.getWeatherIcon(weatherCode),
                            dayOfWeek: this.getDayOfWeek(date),
                        };
                    });
                })
                .catch((error) => {
                    console.error('Weather API Error:', error);
                    this.error = 'Failed to load weather data.';
                    this.weatherData = undefined;
                });
    }

    get roundedTemperature() {
        return this.weatherData ? Math.round(this.weatherData.current.temperature_2m) : '';
    }

    getDayOfWeek(dateString) {
        const daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        const date = new Date(dateString);
        return daysOfWeek[date.getUTCDay()];
    }

    getWeatherIcon(weathercode) {
        switch (weathercode) {
            case 0:
                return sunnyIcon;
            case 1:
            case 2:
            case 3:
                return cloudyIcon;
            case 51:
            case 53:
            case 55:
            case 61:
            case 63:
            case 65:
            case 80:
            case 81:
            case 82:
                return rainyIcon;
            case 71:
            case 73:
            case 75:
            case 85:
            case 86:
                return snowIcon;
            default:
                return sunnyIcon;
        }
    }
}