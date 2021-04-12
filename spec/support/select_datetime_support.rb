module SelectDatetimeSupport
  def select_datetime(datetime, word, model)
    select datetime.year, from: "#{model}[#{word}(1i)]"
    select datetime.month, from: "#{model}[#{word}(2i)]"
    select datetime.day, from: "#{model}[#{word}(3i)]"
    if datetime.hour.to_s.length == 1
      select "0#{datetime.hour}", from: "#{model}[#{word}(4i)]"
    else
      select datetime.hour, from: "#{model}[#{word}(4i)]"
    end
    if datetime.min == 0
      select '00', from: "#{model}[#{word}(5i)]"
    else
      select datetime.min, from: "#{model}[#{word}(5i)]"
    end
  end
end
