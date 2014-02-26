access_token=$1
channelId=$2
payload=$3
curl --verbose -X POST --header "Authorization: Bearer $1" --header "Content-Type: application/json" \
https://www.googleapis.com/gcm_for_chrome/v1/messages -d \
"{\"channelId\":\"$channelId\",\"subchannelId\":\"0\",\"payload\":\"$payload\"}"

