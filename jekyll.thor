require "stringex"
require "yaml"

class Jekyll < Thor
  desc "new", "create a new post"
  def new

    path = '_data/members.yml'
    settings = YAML::load(File.open(path))
    puts settings[0]['display_name']

    title = ask("Post title?\n>")
    author = ask("Author first name?\n>").downcase
    date = Time.now.strftime('%Y-%m-%d')
    filename = "_posts/#{date}-#{title.to_url}.md"


    if File.exist?(filename)
      abort("#{filename} already exists!")
    end

    puts "Creating new post: #{filename}"
    sleep 1
    open(filename, 'w') do |post|
      post.puts "---"
      post.puts "layout: post"
      post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
      post.puts "author: #{author}"
      post.puts "tags:"
      post.puts " -"
      post.puts "---"
      post.puts "\n"
      post.puts "### #{title}"
    end
  end
end

=begin
create a new post by using "thor jekyll:new"
=end
