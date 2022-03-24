#!/usr/bin/env bash


if [[ -z ${EFFWL_API_KEY} ]]; then
	echo "No API key set."
	exit 1;
fi

EFF_WORDLIST=$(curl -s https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt)

clean_output() {
  echo "$1" | grep -Po '\[.*\]' | sed 's/\[\|\]//g' | sed 's/,/ /g'
}

get_rand_numbers() {
	api_stuff="{ \
    \"jsonrpc\": \"2.0\", \
    \"method\": \"generateIntegers\", \
    \"params\": { \
        \"apiKey\": \"${EFFWL_API_KEY}\", \
        \"n\": 5, \
        \"min\": 1554, \
        \"max\": 7775, \
        \"replacement\": true \
    }, \
    \"id\": 42 \
    }"
    clean_output $(curl -s -X POST -H "Content-type: application/json" -d "${api_stuff}" https://api.random.org/json-rpc/4/invoke)
}


convert_to_dice_roll() {
  local result
  local intermediate="${1}"

  while [[ ${intermediate} -gt 0 ]]; do
	  result=${result}$((1+$((intermediate%6)))) # convert to base 6 then + 1
    intermediate=$((intermediate/6))
  done
 echo ${result}
}

main() {
  rando_nums=$(get_rand_numbers) 
  result=""
  for i in ${rando_nums}; do
    dice_roll=$(convert_to_dice_roll ${i})  
    result="${result} $(echo "${EFF_WORDLIST}" \
	    | awk -v fn="$dice_roll" '{if ($1==fn) print $2;}')"
  done
  echo ${result}
}
main
