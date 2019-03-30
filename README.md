# Course Code Challenge

## Ruby version
Developed on:
```ruby 2.6.1p33 (2019-01-30 revision 66950) [x86_64-linux]```

## Rails version
Developed on:
``` Rails 5.2.2.1 ```

## Configuration
Modify ```db/seeds.rb``` to add available departments.

Example:
```ruby
...
...

Department.create([ {name: 'Computer Science'},
                    {name: 'Liberal Arts'},
                    {name: 'Any other department'}])
```

## Database creation and initialization
```bundle exec rake db:create```

```
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
```

