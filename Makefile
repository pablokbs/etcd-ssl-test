clean:
	rm -f docker-compose.override.yaml

stop:
	docker-compose stop

up:
	docker-compose up -d
	docker-compose logs --tail=10 -f etcd1 etcd2 etcd3

down:
	docker-compose down

logs:
	docker-compose logs --tail=10 etcd1 etcd2 etcd3

stage1: clean
	ln -s docker-compose-1.yaml docker-compose.override.yaml
	make up

stage2: clean
	ln -s docker-compose-2.yaml docker-compose.override.yaml
	make up

stage3: clean
	ln -s docker-compose-3.yaml docker-compose.override.yaml
	make up

exec:
	docker-compose exec etcd1 sh

health:
	docker-compose exec etcd1 etcdctl cluster-health
	docker-compose exec etcd2 etcdctl cluster-health
	docker-compose exec etcd3 etcdctl cluster-health

certs-clean:
	rm -f *.pem *.csr

nuke: clean stop

certs: 
	cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
	cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server server.json | cfssljson -bare server
	cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=peer etcd.json | cfssljson -bare etcd
	cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=client client.json | cfssljson -bare client