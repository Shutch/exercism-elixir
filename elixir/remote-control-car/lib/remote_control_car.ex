defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct [
    :nickname,
    distance_driven_in_meters: 0,
    battery_percentage: 100
  ]

  def new(nickname \\ "none") do
    %RemoteControlCar{nickname: nickname}
  end

  def display_distance(remote_car) when is_struct(remote_car, RemoteControlCar) do
    "#{remote_car.distance_driven_in_meters} meters"
  end

  def display_battery(remote_car) when is_struct(remote_car, RemoteControlCar) do
    if remote_car.battery_percentage > 0 do
      "Battery at #{remote_car.battery_percentage}%"
    else
      "Battery empty"
    end
  end

  def drive(remote_car) when is_struct(remote_car, RemoteControlCar) do
    if remote_car.battery_percentage == 0 do
      remote_car
    else
      remote_car = %{remote_car | distance_driven_in_meters: remote_car.distance_driven_in_meters + 20}
      %{remote_car | battery_percentage: remote_car.battery_percentage - 1}
    end
  end
end
