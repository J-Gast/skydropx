# Skydropx Challenge

This services was developed to look for tracking updates for your packages!

## Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes.

### Prerequisites

 - Ruby 2.5
 - Redis

### Installing

First, clone the repo, enter to the main folder and look for the
main branch from the repo.
```sh
git clone git@github.com:MJorgeX/skydropx.git
```

Do bundle install:
```sh
bundle install
```

## Usage

In order to run the back-end, just go:
```sh
bundle exec rackup -p 4567
```

Execute unit tests
```sh
bundle exec rake test
```

To see the routes of the project you should run:
```sh
bundle exec rake grape:routes
```

API documentation route
```sh
/api/swagger_doc
```
