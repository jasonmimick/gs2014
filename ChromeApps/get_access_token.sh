client_secret=$1
client_id=$2
refresh_token=$3
curl --verbose  https://accounts.google.com/o/oauth2/token -d \
	"client_secret=$client_secret&client_id=$client_id&refresh_token=$refresh_token&grant_type=refresh_token"

