defmodule LibraryFees do
  def datetime_from_string(string) do
    NaiveDateTime.from_iso8601!(string)
  end

  def before_noon?(datetime) do
    datetime.hour < 12
  end

  def return_date(checkout_datetime) do
    cond do
      before_noon?(checkout_datetime) ->
        checkout_datetime
        |> NaiveDateTime.add(28 * 86400, :second)
        |> NaiveDateTime.to_date()
      true ->
        checkout_datetime
        |> NaiveDateTime.add(29 * 86400, :second)
        |> NaiveDateTime.to_date()
    end
  end

  def days_late(planned_return_date, actual_return_datetime) do
    actual_return_date = NaiveDateTime.to_date(actual_return_datetime)
    date_diff = Date.diff(actual_return_date, planned_return_date)
    cond do
      date_diff <= 0 -> 0
      true -> date_diff
    end
  end

  def monday?(datetime) do
    date = NaiveDateTime.to_date(datetime)
    if Date.day_of_week(date) == 1 do
      true
    else
      false
    end
  end

  def calculate_late_fee(checkout, return, rate) do
    checkout_datetime = datetime_from_string(checkout)
    return_datetime = datetime_from_string(return)
    planned_return_date = return_date(checkout_datetime)
    late_days = days_late(planned_return_date, return_datetime)
    if monday?(return_datetime) do
      Float.floor(late_days * rate * 0.5)
    else
      late_days * rate
    end
  end
end
