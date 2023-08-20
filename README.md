# Ruby on Rails: Weather API 

## Project Specifications

**Read-Only Files**
- spec/*

**Environment**  

- Ruby version: 2.7.1
- Rails version: 6.0.2
- Default Port: 8000

**Commands**
- run: 
```bash
bin/bundle exec rails server --binding 0.0.0.0 --port 8000
```
- install: 
```bash
source ~/.rvm/scripts/rvm && rvm --default use 2.7.1 && bin/bundle install
```
- test: 
```bash
RAILS_ENV=test bin/rails db:migrate && RAILS_ENV=test bin/bundle exec rspec
```
    
## Question description

You will need to implement endpoints for managing weather information.

Each weather data is a JSON object describing hourly temperatures recorded at a given location on a given date.

Each such object has the following properties:

- id: the unique integer ID of the object
- date: the date, in YYYY-MM-DD format, denoting the date of the record
- lat: the latitude (up to 4 decimal places) of the location of the record
- lon: the longitude (up to 4 decimal places) of the location of the record
- city: the name of the city of the record
- state: the name of the state of the record
- temperatures: an array of 24 float values, each up to one decimal place, denoting the hourly temperatures in Celsius

Example of a weather data JSON object:
```
{
   "id": 1,
   "date": "1985-01-01",
   "lat": 36.1189,
   "lon": -86.6892,
   "city": "Nashville",
   "state": "Tennessee",
   "temperatures": [17.3, 16.8, 16.4, 16.0, 15.6, 15.3, 15.0, 14.9, 15.8, 18.0, 20.2, 22.3, 23.8, 24.9, 25.5, 25.7, 24.9, 23.0, 21.7, 20.8, 29.9, 29.2, 28.6, 28.1]
}
```

## Requirements:

POST request to `/weather`:
- creates a new weather data record
- expects a valid weather data object as its body payload, except that it does not have an id property; you can assume that the given object is always valid
- adds the given object to the collection and assigns a unique integer id to it
- the response code is 201 and the response body is the created record, including its unique id

GET request to `/weather`:
- the response code is 200
- the response body is an array of matching records, ordered by their ids in increasing order
- accepts an optional query string parameter, `date`, in the format `YYYY-MM-DD`, and when this parameter is present, only the records with the matching date are returned
- accepts an optional query string parameter, `city`,  and when this parameter is present, only the records with the matching city are returned. The value of this parameter is case insensitive, so "London" and "london" are equivalent.
- accepts an optional query string parameter, `sort`, that can take one of two values: either "date" or "-date". If the value is "date", then the ordering is by date in ascending order. If it is "-date", then the ordering is by date in descending order. If there are two records with the same date, the one with the smaller id must come first.

GET request to `/weather/<id>`:
- returns a record with the given id
- if the matching record exists, the response code is 200 and the response body is the matching object
- if there is no record in the collection with the given id, the response code is 404
