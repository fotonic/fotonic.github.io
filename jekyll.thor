require "stringex"
require "yaml"

class Jekyll < Thor
  desc "new", "create a new post"
  def new

    # Basic post params in CLI
    title = ask("Post title?\n>")
    author = ask("Author first name?\n>").downcase

    # File compilation
    date = Time.now.strftime('%Y-%m-%d')
    filename = "_posts/#{date}-#{title.to_url}.md"

    # Author twitter linking
    path = '_data/members.yml'
    settings = YAML::load(File.open(path))
    # puts settings[0]['display_name']
    settings.each do |setting|
      if author == setting['first_name']
        @twitter = setting["twitter_url"]
      end
    end

    # Validate unique filename
    if File.exist?(filename)
      abort("#{filename} already exists!")
    end

    # Successful post creation
    puts "Creating new post: #{filename}"
    sleep 1

    # Post frontmatter formatting
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
      post.puts "\n"
      post.puts "<span class='author'>By <a href='#{@twitter}'>#{author.capitalize}</a></span>"
    end
  end
end

# create a new post by using "thor jekyll:new"
