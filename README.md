# sherwood

[Sherwood Forrest](https://github.com/inertia186/sherwood) is a shared group curation tool for tracking posts on [steemit.com](https://steemit.com).  Collaboration groups can use it to track posts internally while at the same time, the public page lists the posts so that others can then vote for them on steemit.com.

This is a reference implementation for the
[Robin Hood Whale](https://steemit.com/@robinhoodwhale) project.

[![Sherwood](https://www.steemimg.com/images/2016/09/02/sherwood5e0a6.png)](https://www.steemimg.com/images/2016/09/02/Statue_of_Robin_Hood_in_Sherwood_Forest_94644ce49.jpg)
*Statue of Robin Hood in Sherwood Forest; Wikimedia UK; by [Nilfanion](https://commons.wikimedia.org/wiki/User:Nilfanion)*; Creative Commons

This project also serves to demonstrate a Ruby on Rails project that can access the STEEM blockchain using the [Radiator](https://github.com/inertia186/radiator) gem.

---

### Installation

```bash
$ git clone git@github.com:inertia186/sherwood.git
$ cd sherwood
$ bundle install
$ rake db:migrate
$ rails s
```

Once the server is running locally, browse to:

[http://localhost:3000/dashboard](http://localhost:3000/dashboard)

You can create an account and log in.  Then you can create a project and posts for that project.

The public view for posts can be seen by browsing to:

[http://localhost:3000/](http://localhost:3000/)

This public view does not require an account.

## Get in touch!

If you're using Sherwood, I'd love to hear from you.  Drop me a line and tell me what you think!  I'm @inertia on STEEM.
  
## License

I don't believe in intellectual "property".  If you do, consider Sherwood as licensed under a Creative Commons [![CC0](http://i.creativecommons.org/p/zero/1.0/80x15.png)](http://creativecommons.org/publicdomain/zero/1.0/) License.
