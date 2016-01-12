#!/usr/bin/env ruby

f = File.open('testcase.txt', 'w')
for i in 1..30
  str = (0..10).map{('a'..'z').to_a[rand(26)]}.join()
  id = i
  homework = (rand() * 30).to_i
  midterm = (rand() * 30).to_i
  final = (rand() * 30).to_i
  f.write("#{str} #{id} #{homework} #{midterm} #{final}\n")
end

f.close
