module SelectDatetimeSupport
  def select_datetime(datetime, word)
    select datetime.year  , from: "park[#{word}_time(1i)]"
    select datetime.month , from: "park[#{word}_time(2i)]"
    select datetime.day   , from: "park[#{word}_time(3i)]"
    if datetime.hour.to_s.length == 1
      select "0#{datetime.hour}"  , from: "park[#{word}_time(4i)]"
    else
      select datetime.hour  , from: "park[#{word}_time(4i)]"
    end
    if datetime.min == 0
      select '00', from: "park[#{word}_time(5i)]"
    else
      select datetime.min   , from: "park[#{word}_time(5i)]"
    end
  end
end