# Simple app for tracking social networks (or any other links)

Easiest way to solve this task - it's just to use this gem: [typhoeus](https://github.com/typhoeus/typhoeus).
But as I have to show some of my skills in limited period of time - I'll do it in more verbose way.

### To save our time, let me help you to review what did I use here:

- Rails API with limited set of middleware (--api --minimal)
- [parallel gem](https://github.com/grosser/parallel ) for reliable parallel execution
- rspec and webmock for tests
- dry libraries for services
- standardrb for style guide validation

## How to run
```
rvm install ruby-2.7.2
gem install bunder
bundle install
rails s
```

## Tests
```
rspec .
```

## Usage
```
brew install jsonpp # optional, just for convenience

curl http://localhost:3000 | jsonpp
{
  "facebook": [
    {
      "name": "Some Friend",
      "status": "Here's some photos of my holiday. Look how much more fun I'm having than you are!"
    },
    {
      "name": "Drama Pig",
      "status": "I am in a hospital. I will not tell you anything about why I am here."
    }
  ],
  "instagram": [{
    "error": "Requested url: https://takehome.io/instagram is not accessible for now, please, try again later"
  }],
  "twitter": [
    {
      "username": "@GuyEndoreKaiser",
      "tweet": "If you live to be 100, you should make up some fake reason why, just to mess with people... like claim you ate a pinecone every single day."
    },
    {
      "username": "@mikeleffingwell",
      "tweet": "STOP TELLING ME YOUR NEWBORN'S WEIGHT AND LENGTH I DON'T KNOW WHAT TO DO WITH THAT INFORMATION."
    }
  ]
```

### API supports any custom links passed with `urls` param
```
curl --location --request GET 'http://localhost:3000?urls[]=https://jsonplaceholder.typicode.com/todos/1?_limit=3&urls[]=https://jsonplaceholder.typicode.com/users?_limit=3' | jsonpp
```
