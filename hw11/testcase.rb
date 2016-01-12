#!/usr/bin/env ruby

if ARGV.size < 3
  puts "enter three argv"
  exit 1
end

f = File.open('ellipse.txt', 'w')
n = ARGV[0].to_i
w = ARGV[1].to_i
h = ARGV[2].to_i

for i in 1..n
  x = rand() * w;
  y = rand() * h;
  f.write("#{x} #{y}\n")
end

f.close

