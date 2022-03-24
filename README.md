# eff-wordlist-diceroll

A bash script that downloads the EFF's Long Word List (for use with five dice) and then picks five random words using random.org's API.

*Requires a valid API key to be passed in the environment `EFF_API_KEY`*

I cannot assure that this is a secure way to generate passwords. I chose random.org because they generate numbers based on random atmospheric phenomenon and not pseudo-random numbers generated inside a CPU. 

Six random numbers from 1554 to 7775 are returned from random.org and are then converted to base 6 and then 1 is added to each place of the number to simulate five dice rolls.
