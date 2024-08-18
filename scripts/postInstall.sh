#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 90s;


if [ -e "./initialized" ]; then
    echo "Already initialized, skipping..."
else
    target=$(docker-compose port vector-admin 3001)
    weaviate_target=$(docker-compose port weaviate 8080)


    register_response=$(curl http://${target}/api/auth/transfer-root \
    -H 'accept: */*' \
    -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
    -H 'cache-control: no-cache' \
    -H 'content-type: text/plain;charset=UTF-8' \
    -H 'pragma: no-cache' \
    -H 'priority: u=1, i' \
    -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36' \
    --data-raw '{"email":"'${ADMIN_EMAIL}'","password":"'${ADMIN_PASSWORD}'"}')

    token=$(echo $register_response | jq -r '.token' )

    curl http://${target}/api/system/update-settings \
    -H 'accept: */*' \
    -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
    -H 'authorization: Bearer '${token}'' \
    -H 'cache-control: no-cache' \
    -H 'content-type: text/plain;charset=UTF-8' \
    -H 'pragma: no-cache' \
    -H 'priority: u=1, i' \
    -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36' \
    --data-raw '{"config":{"allow_account_creation":false,"account_creation_domain_scope":null}}'


    curl http://${target}/api/v1/org/create \
    -H 'accept: */*' \
    -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
    -H 'authorization: Bearer '${token}'' \
    -H 'cache-control: no-cache' \
    -H 'content-type: text/plain;charset=UTF-8' \
    -H 'pragma: no-cache' \
    -H 'priority: u=1, i' \
    -H 'requester-email: '${ADMIN_EMAIL}'' \
    -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36' \
    --data-raw '{"orgName":"Vector"}'

    curl http://${target}/api/v1/org/vector/add-connection \
    -H 'accept: */*' \
    -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
    -H 'authorization: Bearer '${token}'' \
    -H 'cache-control: no-cache' \
    -H 'content-type: text/plain;charset=UTF-8' \
    -H 'pragma: no-cache' \
    -H 'priority: u=1, i' \
    -H 'requester-email: '${ADMIN_EMAIL}'' \
    -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36' \
    --data-raw '{"config":{"type":"weaviate","settings":{"clusterUrl":"http://'${weaviate_target}'","authTokenHeader":"","authToken":""}}}'
    touch "./initialized"
fi