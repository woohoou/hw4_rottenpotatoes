Given /^the following movies exist:$/i do |movies_table|
  movies_table.hashes.each{|movie| Movie.create movie}
end

Then /^the director of "(.*)" should be "(.*)"$/ do |movie,director|
  step %Q{I should see "#{director}"}
end
