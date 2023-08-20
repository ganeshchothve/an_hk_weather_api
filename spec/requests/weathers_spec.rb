require 'rails_helper'

describe 'WeatherController', type: :request do
  describe 'POST /weather' do
    let(:params) do
      {
        date: '1985-01-11',
        lat: 36.1189,
        lon: -86.6892,
        city: 'Nashville',
        state: 'Tennessee',
        temperatures: [
          17.3, 16.8, 16.4, 16.0, 15.6, 15.3,
          15.0, 14.9, 15.8, 18.0, 20.2, 22.3,
          23.8, 24.9, 25.5, 25.7, 24.9, 23.0,
          21.7, 20.8, 29.9, 29.2, 28.6, 28.1
        ]
      }
    end

    before { post '/weather', params: params }

    it 'saves correctly all data sent in request body' do
      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)).to eq(params.merge(id: 1).stringify_keys)
    end
  end

  describe 'GET /weather' do
    let(:seed_data) do
      [
        {
          date: '1985-01-11',
          lat: 36.1189,
          lon: -86.6892,
          city: 'Nashville',
          state: 'Tennessee',
          temperatures: [
            17.3, 16.8, 16.4, 16.0, 15.6, 15.3,
            15.0, 14.9, 15.8, 18.0, 20.2, 22.3,
            23.8, 24.9, 25.5, 25.7, 24.9, 23.0,
            21.7, 20.8, 29.9, 29.2, 28.6, 28.1
          ]
        },
        {
          date: '1985-01-11',
          lat: 36.9261,
          lon: -111.4478,
          city: 'Page',
          state: 'Arizona',
          temperatures: [
            12.0, 11.3, 3.1, 0.1, 2.4, 2.1,
            2.3, 4.1, 7.9, 7.7, 6.3, 8.0,
            10.5, 15.4, 5.5, 4.1, 15.1, 4.1,
            9.5, 4.1, 4.2, 5.2, 7.4, 5.1
          ]
        },
        {
          date: '1987-01-11',
          lat: 36.9261,
          lon: -111.4478,
          city: 'Page',
          state: 'Arizona',
          temperatures: [
            11.0, 11.0, 5.5, 7.0, 5.0, 5.5,
            6.0, 9.5, 11.5, 5.0, 6.0, 8.0,
            9.5, 5.0, 9.0, 9.5, 12.0, 6.0,
            9.5, 8.5, 8.0, 8.0, 9.0, 6.5
          ]
        },
        {
          date: '1986-01-12',
          lat: 36.9261,
          lon: -111.4478,
          city: 'Phoenix',
          state: 'Arizona',
          temperatures: [
            -2.0, -4.5, 1.0, -6.0, 1.0, 1.5,
            -9.0, -2.5, -3.0, -0.5, -13.5, -9.0,
            -11.5, -5.5, -5.5, -3.5, -14.0, -9.5,
            1.5, -15.0, -6.5, -7.0, -13.5, -14.5
          ]
        },
      ]
    end

    let(:expected_responses) do
      seed_data.map.with_index(1) do |record, index|
        record.merge(id: index).stringify_keys
      end
    end

    let(:date) { nil }
    let(:city) { nil }
    let(:sort) { nil }

    before do
      seed_data.each do |weather_params|
        post '/weather', params: weather_params

        unless [200, 201].include?(response.status)
          fail('POST /weather not implemented')
        end
      end
    end

    before { get '/weather', params: {date: date, city: city, sort: sort} }

    context 'when no query parameters are passed' do
      it 'returns all weather records ordered by ID' do
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(expected_responses)
      end
    end

    context 'when "date" query parameter is present' do
      context 'and records with such date exist in the system' do
        let(:date) { seed_data[0][:date] }

        it 'should return only those weather records, which belong to that date' do
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to eq([expected_responses[0], expected_responses[1]])
        end
      end

      context 'and records with such date do not exist in the system' do
        let(:date) { '2020-10-10' }

        it 'should return empty list in response' do
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to eq([])
        end
      end
    end

    context 'when "city" query parameter is present' do
      context 'and records with such city exist in the system' do
        let(:city) { 'page' }

        it 'should return only those weather records, which belong to that city' do
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to eq([expected_responses[1], expected_responses[2]])
        end
      end

      context 'and records with such city do not exist in the system' do
        let(:city) { 'berlin' }

        it 'should return empty list in response' do
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to eq([])
        end
      end
    end

    context 'when "sort" query parameter is set as "date"' do
      let(:sort) { 'date' }

      it 'should return weather records ordered by "date" field in ascending order' do
        expect(response.status).to eq(200)
        expected = [expected_responses[0], expected_responses[1], expected_responses[3], expected_responses[2]]
        expect(JSON.parse(response.body)).to eq(expected)
      end
    end

    context 'when "sort" query parameter is set as "-date"' do
      let(:sort) { '-date' }

      it 'should return weather records ordered by "date" field in descending order' do
        expect(response.status).to eq(200)
        expected = [expected_responses[2], expected_responses[3], expected_responses[0], expected_responses[1]]
        expect(JSON.parse(response.body)).to eq(expected)
      end
    end
  end

  describe 'GET /weather/:id' do
    context 'when system contains weather record with a given ID' do
      let(:params) do
        {
          date: '1985-01-11',
          lat: 36.1189,
          lon: -86.6892,
          city: 'Nashville',
          state: 'Tennessee',
          temperatures: [
            17.3, 16.8, 16.4, 16.0, 15.6, 15.3,
            15.0, 14.9, 15.8, 18.0, 20.2, 22.3,
            23.8, 24.9, 25.5, 25.7, 24.9, 23.0,
            21.7, 20.8, 29.9, 29.2, 28.6, 28.1
          ]
        }
      end

      it 'returns successful response with a correspondent weather record' do
        post '/weather', params: params
        weather_id = JSON.parse(response.body)['id']

        get "/weather/#{weather_id}"
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(params.merge(id: 1).stringify_keys)
      end
    end

    context 'when weather record by given ID does not exist' do
      it 'returns 404 response status code' do
        get '/weather/1'
        expect(response.status).to eq(404)
      end
    end
  end
end