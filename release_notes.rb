#!/usr/bin/env ruby

# gem 'pivotal-tracker'
require 'pivotal-tracker'

TRACKER_TOKEN = ENV['PIVOTALTRACKER_TOKEN']
TRACKER_PROJECT_ID = ENV['PIVOTALTRACKER_PROJECT_ID']
TRACKER_BRANCH = ENV['PIVOTALTRACKER_BRANCH']
LATEST_TAG = 'v0.3'

PivotalTracker::Client.token = TRACKER_TOKEN
PivotalTracker::Client.use_ssl = true

project = PivotalTracker::Project.find(TRACKER_PROJECT_ID)

search_result = `git log \`git describe --tags --abbrev=0 #{LATEST_TAG}^\`..HEAD --oneline #{TRACKER_BRANCH}`

puts "\n-------------------------"
puts "Stories delivered in #{LATEST_TAG}\n\n"
search_result.scan(/#(\d+)/).uniq!.flatten.map do |story_id|
  story = project.stories.find(story_id)
  if story
    puts "#{story_id} - #{story.description}"
  end
end
puts "-------------------------"