# DNS Setup

Various Terraform modules in this project make some basic assumptions about DNS that allow it to function:
- The DNS entries for each public cloud are managed by their respective DNS services (AWS Route53, GCP Cloud DNS, Azure DNS)
- You have already set up delegation from your root domain registrar to each public cloud you wish to use
- Modules are free to create DNS entries in whatever delegated domain it is to create environments in
- DNS is publicly resolvable so ACME DNS solving can be used for certificates

For example, this is the structure of the domains used to test the modules:

![architecture](dns-structure.png)

In this setup:
- The root domain `paasify.org` is registered and managed in GoDaddy
- A sub-domain for each cloud has been manually created and delegated via NS records
- The Terraform modules will then create sub-domains, such as `env1.aws.paasify.org` from these cloud-specific zones