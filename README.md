Reedsy Job Application
======================

Task description
----------------

* [Copy of task in this repository](task.md)
* [Task in the original repository](https://github.com/reedsy/challenges/blob/master/ruby-on-rails-engineer.md)

Question 1
----------

> Write a paragraph about yourself, your hobbies and your major achievements
> in your career or study so far. Add another one about your professional
> experience and commercial projects you've been involved with.

I'm fully remote, love to travel, and work from unusual places. I climb rocks,
dance salsa, and code sublime plugins (that I use in my work then) for fun. My
significant achievements include "Sublime Enhanced Plugins" which received 1k+
stars on my GitHub, co-founded company IdFly which we made during our work
year in Thailand, and co-founded startup Pricelessly which we made during my
half-year stay in Trento (Italy) in TeachPeaks People Accelerator (batch #1).
Now I enjoy working in an international team as a developer.

I'm the developer with 12 years experience with Ruby, Javascript, Go, Python,
PHP languages (and I'm not going to stop :). I helped Switzerland company
Diagonal to deliver 1000TB+ of data to 300+ cinemas across Switzerland, and
integrated their app with Disney & Deluxe distributors. I implemented the
application for the startup "Nalopatu" which started to generate revenue in
the third week after launch. I've created web applications for marketing
programs for ~dozen big brands like Sony & Nivea which were used by over a
million people in Russia.

Question 2
----------

> How would you implement a feed generator for a specific user, based on their
> upvotes and the authors they follow.

I've implemented a basic feed generator that returns books if the user follows
an author or user upvoted one of the author books. The example of its usage
located in the `app.rb` file and can be run by executing `./bin/app` script.
The code is organized under `Task2` namespace, but in a production
environment, it would be a meaningful name.

Here is the sample output (log timestamps are stripped):

```
$ ./bin/app
INFO -- : generate sample data...
INFO -- : books in user "Leo" feed:
INFO -- : Death Be Not Proud by Garrett Reichel @2017-06-11
INFO -- : Vile Bodies by Miguel Paucek @2017-07-11
INFO -- : Fear and Trembling by Miguel Paucek @2018-02-23
INFO -- : Cabbages and Kings by Miguel Paucek @2018-05-09
INFO -- : generate sample data again...
INFO -- : new books in user's feed:
INFO -- : A Catskill Eagle by Garrett Reichel @2017-10-20
INFO -- : The Moon by Night by Adrianne Feeney Jr. @2017-11-13
INFO -- : Arms and the Man by Adrianne Feeney Jr. @2017-12-09
INFO -- : Edna O'Brien by Adrianne Feeney Jr. @2018-04-18
INFO -- : The Daffodil Sky by Adrianne Feeney Jr. @2018-04-19
INFO -- : The Millstone by Gail Yost PhD @2018-05-06
```

Tests can be executed by `rspec` command:

```
$ rspec
...........................

Finished in 0.59438 seconds (files took 0.3433 seconds to load)
27 examples, 0 failures
```

I've used default Rubocop styles with `Metrics/BlockLength` disabled for spec
files (which is default practice according to https://stackoverflow.com/questions/40934345/rubocop-25-line-block-size-and-rspec-tests):

```
$ rubocop
Inspecting 8 files
........

8 files inspected, no offenses detected
```

Question 3
----------

> Implement a Payment Factory to process payments with multiple adapter (Stripe,
Paypal, etc...). Your code should respect SOLID principles as much as possible.
> Provide only the design without any concrete methods implementation.

Here is the default workflow for payments I propose:

* User creates order
* User is redirected to a payment page and pays the order
* User returns to order page
* Application receive payment status and processes the order

```
module Task3
  # Payment is database object that contains current payment status, amount,
  # any information received from vendor; I provided implementation expected by
  # default by interviewers, but in service-oriented architechture I propose to
  # create separate service with methods listed below to decouple validations &
  # relations logic from business logic (make model thin)
  #
  # Usage:
  #
  # def pay_order
  #   # create the payment and redirect user to payment page
  #   # params[:id] should contain order id
  #   redirect_to Payment::Stripe.make(Order.find(params[:id]))
  # end
  #
  # def process_order
  #   # params[:id] should contain vendor payment id
  #   payment = Payment::Stripe.find_by_vendor_id(params[:id])
  #   payment.complete
  #   if payment.success?
  #     redirect_to payment_received_path
  #   else
  #     redirect_to payment_failed_path
  #   end
  # end
  class Payment < ActiveRecord::Base
    # Payment is connected to corresponding order that should contain all
    # information required to create a payment: amount, user email, user
    # address; method should return vendor id which can be used with
    # #find_by_vendor_id to find the payment
    def self.make(order)
      raise NotImplementedError
    end

    # Method should return a concrete vendor Payment instance and should be
    # used on checkout completion page
    def self.find_by_vendor_id(id)
      raise NotImplementedError
    end

    # Method should return a url where user should be directed in order to make
    # actual payment
    def checkout_url
      raise NotImplementedError
    end

    # Method should receive payment status from vendor
    # - In case of success, order#payment_received should be called
    # - This method can be executed more than once to serve different vendor
    #   payment status needs (preparing, processing, received and etc.)
    # - order#payment_received should be called only once
    # - Method should be executed at the order completion page or via
    #   cron-script to process those payments which status were not received by
    #   visiting order completion page due to connection errors or other
    #   circumstances
    def complete
      raise NotImplementedError
    end
  end
end
```


Question 4
----------

> With the previous data schema (question 2), with a list of genres for each
> books, how would you build a recommendation system.
> What kind of dependencies, tools or algorithms you would like to use?

Recommendation engines are a big topic, and for this domain, I would recommend
using some SASS solution (for example, suggestgrid.com) if it fits product
economy.

If enough resource is given, I will give a try to
http://predictionio.apache.org/index.html and
https://cloud.google.com/ml-engine, though I'm not a data science engineer and
outcome will be highly unpredictable.

The simplest in-house solution maybe cross-category search implemented via
elastic search (check below).

Question 5
----------

Following script demonstrates simplest recommendation engine:

```
$ docker run --name elasticsearch -p 9200:9200 elasticsearch

$ curl \
  -X PUT \
  -d '{"upvotes": ["death_be_not_proud", "vile_bodies", "Fear_and_trembling", "cabbages_and_kings"]}' \
  http://localhost:9200/upvotes/user/1

$ curl \
  -X PUT \
  -d '{"upvotes": ["death_be_not_proud", "vile_bodies", "the_moon", "arms_and_the_man"]}' \
  http://localhost:9200/upvotes/user/2

$ curl \
  -X PUT \
  -d '{"upvotes": ["arms_and_the_man", "vile_bodies", "the_daffodil_sky"]}' \
  http://localhost:9200/upvotes/user/3

# activate field data
$ curl \
  -X PUT \
  -d '
    {
      "properties": {
        "upvotes": {
          "type":     "text",
          "fielddata": true
        }
      }
    }
  ' \
  http://localhost:9200/upvotes/_mapping/upvotes?update_all_types

$ curl \
  -X POST \
  -d '
    {
      "query": {
        "match": {
          "upvotes": "Vile_Bodies"
        }
      },
      "aggregations": {
        "movies_like_vile_bodies": {
          "terms": {
            "field": "upvotes",
            "min_doc_count": 1
          }
        }
      }
    }
  ' \
  http://localhost:9200/upvotes/user/_search
```

Result will be:

```
{
  "took": 99,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "skipped": 0,
    "failed": 0
  },
  "hits": {
    ...
  },
  "aggregations": {
    "movies_like_vile_bodies": {
      "doc_count_error_upper_bound": 0,
      "sum_other_doc_count": 0,
      "buckets": [
        {
          "key": "vile_bodies", # vile_bodies itself should be omitted
          "doc_count": 3
        },
        {
          "key": "arms_and_the_man",
          "doc_count": 2
        },
        {
          "key": "death_be_not_proud",
          "doc_count": 2
        },
        {
          "key": "cabbages_and_kings",
          "doc_count": 1
        },
        {
          "key": "fear_and_trembling",
          "doc_count": 1
        },
        {
          "key": "the_moon",
          "doc_count": 1
        },
        {
          "key": "the_daffodil_sky",
          "doc_count": 1
        }
      ]
    }
  }
}
```
