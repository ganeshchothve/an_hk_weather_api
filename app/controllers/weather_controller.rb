class WeatherController < ApplicationController
  def create
    weather_data = params.permit(
      :date, :lat, :lon, :city, :state, temperatures: []
    )
    
    weather = Weather.create(weather_data)
    [:lat, :lon].each do |x|
      weather_data[x] = weather_data[x].to_f
    end
    weather_data[:temperatures] = weather_data[:temperatures].map(&:to_f)
    render json: weather_data.merge(id: weather.id), status: :created
  end

  def index
    weather_records = fetch_weather_records(params[:date], params[:city], params[:sort])
    render json: weather_records, status: :ok
  end

  def show
    weather_record = find_weather_record(params[:id])
    
    if weather_record
      render json: weather_record, status: :ok
    else
      render status: :not_found
    end
  end

  private

  def fetch_weather_records(date, city, sort)
    records = Weather.all

    records = records.where(date: date) if date.present?
    records = records.where("LOWER(city) = ?", city.downcase) if city.present?
    records = records.order(date: (sort == '-date' ? :desc : :asc)) if sort.present?

    records
  end

  def find_weather_record(id)
    Weather.find_by(id: id)
  end
end
