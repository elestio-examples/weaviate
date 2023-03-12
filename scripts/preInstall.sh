#set env vars
#set -o allexport; source .env; set +o allexport;

apt install jq -y

mkdir -p ./weaviate
chown -R 1000:1000 ./weaviate
