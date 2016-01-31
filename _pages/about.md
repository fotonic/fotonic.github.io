---
layout: page
title: About
  We're friends, coffee drinkers, designers, developers and makers. Curious creativity & innovative ideas empower us.
permalink: /about/
---

### Find us online

Check out [Github](http://github.com/fotonic) to see what we're up to. (_Twitter is coming soon._)

<!-- ### Contact

If you have a web project you'd like discuss with us, [get in touch](http//) -->

<!-- A simple Jekyll theme inspired by Google's new visual language, Material Design.

Andrea
Web designer and food lover. 

Anthony


Chip






{% highlight css %}
#container {
  float: left;
  margin: 0 -240px 0 0;
  width: 100%;
}
{% endhighlight %}

{% highlight html %}
{% raw %}
<nav class="pagination" role="navigation">
{% if page.previous %}
<a href="{{ site.url }}{{ page.previous.url }}" class="btn" title="{{ page.previous.title }}">Previous article</a>
{% endif %}
{% if page.next %}
<a href="{{ site.url }}{{ page.next.url }}" class="btn" title="{{ page.next.title }}">Next article</a>
{% endif %}
</nav><!-- /.pagination -->
{% endraw %}
{% endhighlight %}

{% highlight ruby %}
  module Jekyll
  class TagIndex < Page
  def initialize(site, base, dir, tag)
  @site = site
  @base = base
  @dir = dir
  @name = 'index.html'
  self.process(@name)
  self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
  self.data['tag'] = tag
  tag_title_prefix = site.config['tag_title_prefix'] || 'Tagged: '
  tag_title_suffix = site.config['tag_title_suffix'] || '&#8211;'
  self.data['title'] = "#{tag_title_prefix}#{tag}"
  self.data['description'] = "An archive of posts tagged #{tag}."
  end
  end
  end
{% endhighlight %} -->
