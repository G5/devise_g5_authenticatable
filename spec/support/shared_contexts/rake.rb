# frozen_string_literal: true

# Based on: http://robots.thoughtbot.com/test-rake-tasks-like-a-boss
# Modified for a non-Rails environment
require 'rake'

RSpec.shared_context 'rake' do
  let(:rake)      { Rake::Application.new }
  let(:task_name) { self.class.top_level_description }
  let(:task_path) do
    "lib/tasks/#{task_name.split(':').first}/#{task_name.split(':').last}"
  end
  let(:root_path) { File.expand_path('../../../..', __FILE__) }
  subject(:task)  { rake[task_name] }

  def loaded_files_excluding_current_rake_file
    $LOADED_FEATURES.reject { |file| file =~ /#{task_path}\.rake$/ }
  end

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path,
                                  [root_path],
                                  loaded_files_excluding_current_rake_file)
    Rake::Task.define_task(:environment)
  end
end
