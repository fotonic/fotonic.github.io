require "stringex"
class Jekyll < Thor
  desc "new", "create a new post"
  def new

    title = ask("Post title?\n>")
    author = ask("Author first name?\n>")
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
      post.puts "author: #{author.downcase}"
      post.puts "tags:"
      post.puts " -"
      post.puts "---"
      post.puts "\n"
      post.puts "### #{title}"
    end
  end
  # def new(author, *title)
  #   title = title.join(" ")
  #   author = author.chomp(",")
  #   date = Time.now.strftime('%Y-%m-%d')
  #   filename = "_posts/#{date}-#{title.to_url}.md"
  #
  #   if File.exist?(filename)
  #     abort("#{filename} already exists!")
  #   end
  #
  #   puts "Creating new post: #{filename}"
  #   open(filename, 'w') do |post|
  #     post.puts "---"
  #     post.puts "layout: post"
  #     post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
  #     post.puts "author: #{author.downcase}"
  #     post.puts "tags:"
  #     post.puts " -"
  #     post.puts "---"
  #     post.puts "\n"
  #     post.puts "### #{title}"
  #   end
  # end
end

=begin
create a new post by using "thor jekyll:new"
=end
