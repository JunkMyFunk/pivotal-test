#!/usr/bin/env ruby

# gem 'pivotal-tracker'
require 'pivotal-tracker'

TRACKER_TOKEN = ENV['PIVOTALTRACKER_TOKEN']
TRACKER_PROJECT_ID = ENV['PIVOTALTRACKER_PROJECT_ID']
TRACKER_BRANCH = ENV['PIVOTALTRACKER_BRANCH']

PivotalTracker::Client.token = TRACKER_TOKEN
PivotalTracker::Client.use_ssl = true

project = PivotalTracker::Project.find(TRACKER_PROJECT_ID)
stories = project.stories.all(:state => "finished", :story_type => ['bug', 'feature', 'chore'])

stories.each do | story |
  puts "Searching for #{story.id} in local git repo."
  search_result = `git log --grep #{story.id} #{TRACKER_BRANCH}`
  if search_result.length > 0
    puts "Found #{story.id} in #{TRACKER_BRANCH} branch, marking as delivered."
    story.notes.create(:text => "Delivered by staging deploy script.")
    story.update({"current_state" => "delivered"})
  else
    puts "Coult not find #{story.id} in #{TRACKER_BRANCH}"
  end
end