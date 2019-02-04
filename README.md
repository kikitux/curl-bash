# curl-bash

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
