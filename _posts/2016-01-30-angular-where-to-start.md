---
layout: post
title: "Angular: Where to start?"
tags: [Angular, Angular 2, JavaScript, Javascript Framework]
author: anthony
---

### Angular: Where to start?

<span class="author">By <a href="https://twitter.com/nthony_i">Anthony</a></span>

<em>Disclaimer:</em> I have a little over one year of software development experience working with Angular and Rails as of writing this post. Don't go doing anything crazy off of what I tell you here.

If you are interested in learning Angular while Angular 2 makes its way out of beta, it can be difficult to know whether you should start with Angular 1.x or go straight for Angular 2. The issue here is that there are a huge number of production apps built on Angular 1.x, and regardless of whether they plan to stick with Angular 1.x or follow an upgrade path to Angular 2, anyone who wants to work on those teams will need some degree of familiarity with Angular 1.x.

<h4>Is it really that different?</h4>
It's not as if 1.x and 2 have nothing in common. They both use dependency injection; the differences in how they handle data bindings shouldn't leave anyone scratching their head for long; and the docs connect the dots between the controllers and directives of 1.x and components in 2. However, the Angular team chose to break the API for a reason. Angular 2 has learned a lot from 1.x, as well as other JS frameworks. The component architecture is probably the clearest example. In Angular 2, you now build your app as component tree with uni-directional data flow. That can solve a lot of problems that came up in 1.x as a result of deeply nested directives and two-way data binding.

My take is that while they are quite a bit different, you will definitely gain some insight into Angular 2 by having built something with 1.x, but I'm not sure that the same is true if you start with Angular 2. I actually think that it could be a painful process.

<h4>The case for Angular 1.x</h4>
As I mentioned earlier, there are a ton of production apps built on 1.x. So if you are looking for work right now, I would suggest starting there.

Angular 1.x has been in use long enough for many practices to become fairly standardized (see <a href="https://github.com/johnpapa/angular-styleguide">John Papa's style guide</a>), which is great, because it makes it easier to maintain consistency across a project. But there's still a lot of ground to cover before you will be proficient with Angular 1.x. Thankfully, there are also countless blog posts and Stack Overflow answers that cover most situations you are likely to have difficulty with.

Some of my favorite resources are:
<ul>
  <li><a href="https://github.com/johnpapa/angular-styleguide">John Papa's Angular Style Guide</a></li>
  <li><a href="https://app.pluralsight.com/library/courses/angular-application-development/">Lukas Ruebbelke's Angular Application Development course on Pluralsight</a></li>
  <li><a href="https://app.pluralsight.com/library/courses/angularjs-fundamentals">Joseph Eames and Jim Cooper's Angular Fundamentals course on Pluralsight</a></li>
  <li><a href="https://app.pluralsight.com/library/courses/angularjs-directive-fundamentals/">Joseph Eames' Angular Directives Fundamentals course on Pluralsight</a></li>
  <li><a href="https://docs.angularjs.org/api">Angular docs</a> (though I would suggest starting with a quick tutorial)</li>
  <li><a href="https://devchat.tv/adventures-in-angular">Adventures in Angular podcast</a></li>
  <li><a href="https://angularair.com/">Angular Air video podcast</a></li>
</ul>

Don't waste your time with Code School on this one. Their course was written before the community came together on how to write good angular code, so it's not going to be of much help.

<h4>The case for Angular 2</h4>
If you will be using Angular in side-projects or new projects where you have a significant level of control over the direction of the project, then I think it's an easy choice to go with Angular 2.

The performance benefits, web components, benefits of writing in TypeScript (compile-time error catching, productivity tools), and transferable skills (reactive programming, modern build system) make Angular 2 an incredible framework to get us closer to the future of the web.

I suggest the <a href="https://angular.io/docs/ts/latest/quickstart.html">Angular 2 Quickstart</a> and <a href="https://angular.io/docs/ts/latest/tutorial/">Tour of Heroes tutorial</a> as a great starting point. And here are some great podcasts for wrapping your head around the high-level concepts:
<ul>
  <li><a href="https://devchat.tv/adventures-in-angular/078-aia-ng-beta-with-brad-green-mi-ko-hevery-and-igor-minar">AiA NG Beta with Brad Green, Miško Hevery, and Igor Minar</a></li>
  <li><a href="https://devchat.tv/adventures-in-angular/072-aia-components-and-directives">AiA Components and Directives</a></li>
  <li><a href="https://devchat.tv/adventures-in-angular/073-aia-angular-2-beta-architecture">AiA Angular 2 Beta Architecture</a></li>
</ul>
