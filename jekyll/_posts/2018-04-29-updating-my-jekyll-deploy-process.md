---
layout: post
title: Updating my Jekyll deploy process
---
# This is according to common practices in the jekyll documentation.
also another article about jekyllizing a html template site was good.  
Following these instructions to create the jekyll install initially: https://jekyllrb.com/tutorials/convert-site-to-jekyll/ .  
  
The main point is, put layouts in `_layouts/` , stub the content with curly braces .  The default layout is selected in index.md.  If index.md chose the indexlayout layout for example, that would be found in `_layouts/indexlayout.html`.  
  
Assets go in the top level like this.  
```
├── assets
│   ├── css
│   ├── js
│   └── sass
├── _config.yml
├── index.md
├── _layouts
│   ├── default.html
│   └── indexlayout.html
```  
  
And they can be accessed from the HTML `assets/css/main.css` for example here  
  
# Now the different part:  deploying
Before what I did was, build the site, then commit the site to git, then push the built site to the production server.  Problem is committing the built site, it's a waste.  It's better to not store the generated site.  
  
**Option:  Push to Prod, Build on Prod, Push to Github for archiving**
* Requires Jekyll install on prod.  Prod may not have RAM or Disk **BAD**
* Can put a hook in github which deploys on push.  Non-developers can use github directly to update content **GOOD**
**Option: Push to Github for archiving, build the site locally, scp the built site to prod**
  
**Option:  (Push to Github or Edit inside Github) , build on Jenkins, deploy with Jenkins**  
* Easy editing for Non-Developers
* Only 1 push required if using command line
* Jenkins can configure the Hook and the deploy destination
