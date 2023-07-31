#!/bin/bash

# Dad Jokes API endpoint
jokes_json="https://www.fatherhood.gov/jsonapi/node/dad_jokes"

# Where are all the cows?
cows_directory="/opt/homebrew/Cellar/cowsay/3.04_1/share/cows/"

if [[ ! $(which jq) ]]; then
  echo "The jokes are way funnier if you have the jq utility installed. https://stedolan.github.io/jq/" >&2
  exit 1
fi

if [[ ! $(which cowsay) ]]; then
  echo "Saying jokes is better with cowsay. Promise! https://formulae.brew.sh/formula/cowsay" >&2
  exit 1
fi

if [[ ! $(which shuf) ]]; then
  echo "We need to shuffle our cows. https://formulae.brew.sh/formula/coreutils" >&2
  exit 1
fi

# Get the list of jokes from fatherhood.gov.
jokes=$(curl -s $jokes_json)

# Count the total number of jokes in the API response.
num_jokes=$(echo "$jokes" | jq '.data | length')

# Get a random number using the array length to shuffle the jokes.
random_joke=$(shuf -i 0-"$num_jokes" -n 1)-1

# Get the opener and closer for the joke
joke_opener=$(echo "$jokes" | jq .data[$random_joke] | jq .attributes.field_joke_opener)
joke_response=$(echo "$jokes" | jq .data[$random_joke] | jq .attributes.field_joke_response)

# Get an animal to use with cowsay
cow_to_say=$(find $cows_directory -name "*.cow" | shuf -n 1)

# Say the joke and punchline with cowsay.
echo ""
printf "%s \n %b" "$joke_opener" "$joke_response" | cowsay -f "$cow_to_say" 
echo ""
