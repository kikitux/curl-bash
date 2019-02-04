# curl-bash

## consul

### consul-1server
[consul-1server/consul.sh](https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.sh)

input:
- variable `IFACE` the interface to bind

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.sh | bash 
```


vagrant
```ruby
config.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.sh"
```

### consul-client
[consul-client/consul.sh](https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-client/consul.sh)

input:
- variable `IFACE` the interface to bind

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-client/consul.sh | bash
```


vagrant
```ruby
config.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-client/consul.sh"
```


## vault

### vault-dev
[vault-dev/vault.sh](https://raw.githubusercontent.com/kikitux/curl-bash/master/vault-dev/vault.sh)

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/vault-dev/vault.sh | bash
```

vagrant
```ruby
config.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/vault-dev/vault.sh"
```

## provision

### docker
[provision/docker](https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/docker.sh)

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/docker.sh | sudo bash
```

vagrant
```ruby
config.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/docker.sh"
```
