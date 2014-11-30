# wherex

[![Build Status](https://travis-ci.org/smathy/wherex.svg?branch=master)](https://travis-ci.org/smathy/wherex) [![Code Climate](https://codeclimate.com/github/smathy/wherex/badges/gpa.svg)](https://codeclimate.com/github/smathy/wherex) [![Test Coverage](https://codeclimate.com/github/smathy/wherex/badges/coverage.svg)](https://codeclimate.com/github/smathy/wherex)

Regexp support to ActiveRecord finders.

## Installation

Wherex is [Semantically Versioned](http://semver.org/), meaning that we will
always indicate a backwardly incompatible change with a MAJOR version bump, so
you can just use this in your `Gemfile`:

```ruby
gem 'wherex', '~> 1.0'
```

Only works with Rails >= 3.1

## Examples

```ruby
# find users in 93, 94 and 95 (5 digit) zipcodes (new style finder)
User.where :zipcode => /^9[345][0-9]{3}$/

# find students with invalid characters in their names (old style finder)
Student.all :conditions => { :name => /[^a-zA-Z ]/ }

# find products with a complex code structure (dynamic finders)
Product.find_by_code /^[NRW][^-]+-[456]/
```

## Be Aware

### POSIX Only (mostly)

Most DBs only support POSIX regexps!

Let me repeat?  POSIX only!  So, some examples of things to know:

 * `^` and `$` have their POSIX meanings, so beginning and end of the whole string, not of each line within the string.  Also `\A` and `\Z` have no special meaning.
 * Convenience character classes like `\w \W \d \D \s \S` 
 * Capturing parens won't break the RE, but there's no capturing (so you can't use what you captured)
 * No extended patterns, so `(?i:foo)` won't work, nor will `(?:bar)` and nor will `(?i)foo`
 * No look-around assertions work, so no `foo(?!bar)`

### SQLite is very slow

SQLite's implementation of REGEXP is actually a callback to a user defined
function, which this gem provides in Ruby.  This is **really cool™** because
SQLite users get to use full Ruby regexps (ie. **none** of the limitations above
apply) but it comes at a cost.

On a relatively small data set (say 1000 rows) my MySQL testing ran through all
records in 2.3ms whereas SQLite took 84.6ms (because it has to call out to Ruby
for each row tested).

So, don't be surprised if SQLite falls in a heap, and I'd recommend just
abandoning this idea for any production usage.

### Only SQLite, MySQL and PostgreSQL supported out of the box

You can add your own support for any other DB that supports regexp.  I know that
Oracle has a regexp function, and I believe that MSSQL has a regexp XP (a Perl
RE one actually).

Here's how I'd add in Oracle support:

```ruby
# config/initializers/wherex.rb
module Wherex
  module OracleEnhancedAdapter
    def regexp left, right
      "REGEXP_LIKE( #{left}, #{right} )"
    end

    def regexp_not left, right
      "NOT #{regexp left, right}"
    end
  end
end
```

That's it (and the 'NOT' is only necessary if you use meta_where or something
that enables negative Arel statements to be generated).  You just have to make
sure it is named correctly (needs to be the same as your actual adapter, so if
you're using `SomeOtherOracleAdapter` then you need to name your module that
too).

Wherex will pick this module up, and add it into the right place.  Just see
`lib/wherex/adapters.rb` for more examples.

## Testing

With the latest 1.1 I have added [Appraisal](//github.com/thoughtbot/appraisal)
for testing multiple versions of ActiveRecord. Check that out for how it works, but
basically you can run tests for all supported AR versions with:

```bash
appraisal rake
```

or you can pick one of the names from the `Appraisals` file and run just one, eg:

```bash
appraisal ar-4.0 rake
```

### Databases

There are test suites for all three database engines that ship with Rails, the
default is SQLite and requires no preconfiguration.  So you can just clone the
repo and run `rake` and it will run the tests against SQLite

If you want to run the tests against MySQL or PostgreSQL then you will first
need to create a `wherex_test` database in your local machine for the given DB.
Then you will need to `bundle install` for the given DB by using the `DB`
environment variable, eg:

```bash
DB=mysql bundle
```

...or...

```bash
DB=postgres bundle
```

You do the same thing when you're running the tests, eg:

```bash
DB=mysql rake
```

...or...

```bash
DB=postgres rake
```

These will use a default user of `root` for MySQL and `postgres` for PostgreSQL.
If you want to use different usernames or passwords then take a look in the
`config/database.yml` file and either provide the appropriate environment
variables, or edit the file itself.

You can also run an appraisal, or all appraisals through the same thing:

```bash
DB=mysql appraisal rake
```

## Copyright

Copyright © 2014 Jason King. See LICENSE.txt for further details.
