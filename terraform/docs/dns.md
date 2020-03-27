# DNS Setup

Various Terraform modules in this project make some basic assumptions about DNS that allow it to function:
- The DNS entries for each public cloud are managed by their respective DNS services (AWS Route53, GCP Cloud DNS, Azure DNS)
- You have already set up delegation from your root domain registrar to each public cloud you wish to use
- Modules are free to create DNS entries in whatever delegated domain it is to create environments in
- DNS is publicly resolvable so ACME DNS solving can be used for certificates

For example, this is the structure of the domains used to test the modules:

![architecture](dns-structure.png)

The DNS for `paasify.org` itself is managed in GoDaddy, with a sub-domain for each cloud delegated to that clouds DNS service.