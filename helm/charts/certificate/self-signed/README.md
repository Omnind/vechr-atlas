# Create Self Signed Certificate

## * Create Local Certificate Authority

1. generate root CA key
```bash
openssl genrsa -des3 -out rootCA.key 2048
```

2. Generate root CA pem
```bash
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1825 -out rootCA.pem
```
```
Country Name: ID
Province: Jawa Barat
City: Cimahi
Organization Name: Company CA
Organization Unit Name: Certificate Authority
Common Name: app.company.com
Email: admin@company.com
```
3. Convert root CA pem to p7b so can be used in windows OS
```
openssl crl2pkcs7 -nocrl -certfile rootCA.pem -out rootCA.p7b
```

### * Create SSL for our application

1. Generate app.company.com key
```
openssl genrsa -out app.company.com.key 2048
```

2. Buat csr file untuk diajukan ke Certificate Authority Sebelumnya
```
openssl req -new -key app.company.com.key -out app.company.com.csr 
```
```
Country Name: ID
Province: Jawa Barat
City: Cimahi
Organization Name: company
Organization Unit Name: DevOps
Common Name: app.company.com
Email: admin@company.com

Challenge Password: your password
Optional	Company Name: company.com
```
3. Create config.txt file
```txt
authorityKeyIdentifier = keyid,issuer
basicConstraints = CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = app.company.com
```
4. Buat Certificate crt file untuk Aplikasi kita 
```bash
openssl x509 -req -in app.company.com.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out app.company.com.crt -days 365 -sha256 -extfile config.txt 
```

### * Import rootCA.pem in our browser or OS so we will have secure connection https

For Example: </br>
[In MAC](https://support.apple.com/en-in/guide/keychain-access/kyca2431/mac)</br>
[In Chrome](https://docs.vmware.com/en/VMware-Adapter-for-SAP-Landscape-Management/2.1.0/Installation-and-Administration-Guide-for-VLA-Administrators/GUID-D60F08AD-6E54-4959-A272-458D08B8B038.html)
### * Create Secret In our kubernetes, for example NATS
```bash
#KONG
kubectl create secret generic nats-client-tls --from-file=tls.crt=./app.company.com.crt --from-file=tls.key=./app.company.com.key --from-file=ca.crt=./rootCA.pem
# KONG
kubectl create secret tls kong-vechr-cert --cert=./app.company.com.crt --key=./app.company.com.key
```
###  * Create Secret In our kubernetes yaml
```
cat app.company.com.crt | base64
cat app.company.com.key | base64
```
```yaml
apiVersion: v1
data:
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURKakNDQWc2Z0F3SUJBZ0lKQUw2Y3R2bk9zMzlUTUEwR0NTcUdTSWIzRFFFQkJRVUFNQll4RkRBU0JnTlYKQkFNVEMyWnZieTVpWVhJdVkyOXRNQjRYRFRFNE1USXhOREUxTWpJeU1Gb1hEVEU1TVRJeE5ERTFNakl5TUZvdwpGakVVTUJJR0ExVUVBeE1MWm05dkxtSmhjaTVqYjIwd2dnRWlNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUJEd0F3CmdnRUtBb0lCQVFDbWVsQTNqVy9NZ2REejJNazMwbXZ4K2VOSHJkQlIwMEJ4ZUR1VjBjYWVFUGNFa2RmSnk5V28KaTFpSXV1V04vZGV6UEhyTWMxenBPNGtzbWU5NThRZVFCWjNmVThWeGpRYktmb1JzNnhQUlNKZVVSckVCcWE4SQpUSXpEVVdaUTAwQ2xsa1dOejE4dDYvVjJycWxJd1VvaTVZWHloOVJsaWR4MjZRaXJBcFFFaXZDY2QzdUExc3AwCkUxRXdIVGxVdzFqSE9Eb3BLZGxaRndmcWhFSHNmYjZvLzJFb1A1MXMwY2JuTld6MHNsUjhhejdzOExVYnhBWnkKQkNQdDY1Z2VhT3hYWWUxaWhLYzN4SE4wYSsxMXpBYUdDMnpTemdOcEVWeFFJQ3lZdVZld3dNb0FrcHNkdGEybwpnMnFTaDZQZzRHeFFabzRwejIwN0c2SkFUaFIyNENiTEFnTUJBQUdqZHpCMU1CMEdBMVVkRGdRV0JCU3NBcUZoCkpPS0xZaXNHTkNVRGU4N1VWRkp0UERCR0JnTlZIU01FUHpBOWdCU3NBcUZoSk9LTFlpc0dOQ1VEZTg3VVZGSnQKUEtFYXBCZ3dGakVVTUJJR0ExVUVBeE1MWm05dkxtSmhjaTVqYjIyQ0NRQytuTGI1enJOL1V6QU1CZ05WSFJNRQpCVEFEQVFIL01BMEdDU3FHU0liM0RRRUJCUVVBQTRJQkFRQU1wcDRLSEtPM2k1NzR3dzZ3eU1pTExHanpKYXI4Cm8xbHBBa3BJR3FMOHVnQWg5d2ZNQWhsYnhJcWZJRHlqNWQ3QlZIQlc1UHZweHpKV3pWbmhPOXMrdzdWRTlNVHUKWlJHSXVRMjdEeExueS9DVjVQdmJUSTBrcjcwYU9FcGlvTWYyUVUvaTBiN1B2ajJoeEJEMVZTVkd0bHFTSVpqUAo0VXZQYk1yTWZUWmJka1pIbG1SUjJmbW4zK3NTVndrZTRhWXlENVVHNnpBVitjd3BBbkZWS25VR0d3TkpVMjA4CmQrd3J2UUZ5bi9kcVBKTEdlNTkvODY4WjFCcFIxRmJYMitUVW4yWTExZ0dkL0J4VmlzeGJ0b29GQkhlVDFLbnIKTTZCVUhEeFNvWVF0VnJWSDRJMWh5UGRkdmhPczgwQkQ2K01Dd203OXE2UExaclVKOURGbFl2VTAKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
  tls.key: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBcG5wUU40MXZ6SUhRODlqSk45SnI4Zm5qUjYzUVVkTkFjWGc3bGRIR25oRDNCSkhYCnljdlZxSXRZaUxybGpmM1hzeng2ekhOYzZUdUpMSm52ZWZFSGtBV2QzMVBGY1kwR3luNkViT3NUMFVpWGxFYXgKQWFtdkNFeU13MUZtVU5OQXBaWkZqYzlmTGV2MWRxNnBTTUZLSXVXRjhvZlVaWW5jZHVrSXF3S1VCSXJ3bkhkNwpnTmJLZEJOUk1CMDVWTU5ZeHpnNktTblpXUmNINm9SQjdIMitxUDloS0QrZGJOSEc1elZzOUxKVWZHcys3UEMxCkc4UUdjZ1FqN2V1WUhtanNWMkh0WW9Tbk44UnpkR3Z0ZGN3R2hndHMwczREYVJGY1VDQXNtTGxYc01ES0FKS2IKSGJXdHFJTnFrb2VqNE9Cc1VHYU9LYzl0T3h1aVFFNFVkdUFteXdJREFRQUJBb0lCQUMvSitzOEhwZWxCOXJhWgpLNkgvb0ljVTRiNkkwYjA3ZEV0ZVpWUnJwS1ZwWDArTGdqTm1kUTN0K2xzOXMzbmdQWlF4TDFzVFhyK0JISzZWCi9kMjJhQ0pheW1mNmh6cENib21nYWVsT1RpRU13cDZJOEhUMnZjMFhGRzFaSjVMYUlidW0rSTV0MGZlL3ZYWDEKUzVrY0Mya2JGQ2w3L21lcmZJTVNBQy8vREhpRTUyV1QydEIrQk01U2FMV3p4cDhFa3NwNkxWN3ZwYmR4dGtrTwpkZ1A4QjkwWlByck5SdUN5ekRwRUkvMnhBY24yVzNidlBqRGpoTjBXdlhTbTErVk9DcXNqOEkrRkxoUzZJemVuCm1MUkFZNnpWVGpZV05TU2J3dTRkbnNmNElIOEdiQkZJajcrdlN5YVNVTEZiVGJzY3ZzQ3I1MUszbWt2bEVMVjgKaWsvMlJoa0NnWUVBMFpmV2xUTjR2alh2T0FjU1RUU3MwMFhIRWh6QXFjOFpUTEw2S1d4YkxQVFJNaXBEYklEbQp6b3BiMGNTemxlTCtNMVJCY3dqMk5HcUNodXcyczBaNTQyQVhSZXdteG1EcWJaWkFQY0UzbERQNW5wNGRpTFRCClZaMFY4UExSYjMrd2tUdE83VThJZlY1alNNdmRDTWtnekI4dU1yQ1VMYnhxMXlVUGtLdGpJdThDZ1lFQXkxYWMKWjEyZC9HWWFpQjJDcWpuN0NXZE5YdGhFS2dOYUFob21nNlFMZmlKakVLajk3SExKalFabFZ0b3kra1RrdTJjZAp0Wm1zUi9IU042YmZLbEpxckpUWWkzY2E1TGY4a3NxR0Z5Y0x1MXo3cmN6K1lUaEVWSFIyOVkrVHVWYXRDTnkzCklCOGNUQW1ORWlVMlVHR2VKeUllME44Z1VZRXRCYzFaMEg2QWllVUNnWUFETDIrUGJPelUxelQvZ1B3Q09GNjQKQjBOelB3U2VrQXN1WXpueUR6ZURnMlQ2Z2pIc0lEbGh3akNMQzVZL0hPZ0lGNnUyOTlmbURBaFh6SmM0T2tYMwo4cW5uNGlMa3VPeFhKZ1ZyNnRmUlpNalNaRXpHbXhpbEdISVE2MS9MZGdGVTg3WExYWHdmaTZPdW80cUVhNm9YCjhCRmZxOWRVcXB4bEVLY2Y1N3JsK1FLQmdGbjVSaFc2NS9oU0diVlhFWVZQU0pSOW9FK3lkRjcrd3FvaGRoOVQKekQ0UTZ6THBCQXJITkFYeDZZK0gxM3pFVlUzVEwrTTJUM1E2UGFHZ2Rpa2M5TlRPdkE3aU1nVTRvRXMzMENPWQpoR2x3bUhEc1B6YzNsWXlsU0NvYVVPeDJ2UFFwN2VJSndoU25PVVBwTVdKWi80Z2pZZTFjZmNseTFrQTJBR0x3ClJ1STlBb0dCQU14aGFJSUdwTGdmcHk0K24rai9BSWhJUUhLZFRCNVBqaGx0WWhqZittK011UURwK21OeTVMbzEKT0FRc0Q0enZ1b3VxeHlmQlFQZlllYThvcm4vTDE3WlJyc3lSNHlhS1M3cDVQYmJKQlNlcTc5Z0g5ZUNIQkxMbQo0aThCUFh0K0NmWktMQzg3NTNHSHVpOG91V25scUZ0NGxMQUlWaGJZQmtUbURZSWo4Q0NaCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==
kind: Secret
metadata:
  name: kong-vechr-cert-dev
  namespace: default
type: kubernetes.io/tls
```