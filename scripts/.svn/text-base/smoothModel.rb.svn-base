#!/usr/bin/ruby

# Smooth the probabilities of different outputs.
# Does not affect transition probabilities or
# initial state probabilities
#
# Usage: smoothModel.rb < input_model > smoothed_model

EPSILON = 1.0 * 10**-6
lines = readlines
lines.each do |line|
  if line.start_with? 'IntegerOPDF'
    probs = line.sub(/IntegerOPDF \[(.*) \]/, '\1').split
    total = 0.0
    probs.each_index do |i|
      probs[i] = probs[i].to_f + EPSILON
      total += probs[i]
    end
    prob_str = ''
    probs.each do |p|
      smoothed_prob = p / total
      prob_str += "#{smoothed_prob} "
    end
    puts "IntegerOPDF [#{prob_str}]"
  else
    puts line
  end
end

