# acmechallenge

Run

```
openssl dhparam -out ./dhparam.pem
```

```
openssl genrsa 4096 > ./account.key
```

```
mkdir -p /var/www/challenges
```

Add to nginx server

```
location /.well-known/acme-challenge/ {
  alias /var/www/challenges/;
  try_files $uri =404;
}
```

nginx snippet

```
location /.well-known/acme-challenge/ {
  alias /var/www/challenges/;
  try_files $uri =404;
}
```
