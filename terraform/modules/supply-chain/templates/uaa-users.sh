set -e

uaac target ${uaa_url} --skip-ssl-validation

uaac token client get ${uaa_client_id} -s ${uaa_client_secret}

# Concourse
uaac client add concourse-client --scope openid,roles,uaa.user \
  --authorized_grant_types refresh_token,password,authorization_code \
  --redirect_uri "https://${concourse_domain}/sky/issuer/callback" \
  --authorities clients.read,clients.secret,uaa.resource,scim.write,openid,scim.read \
  --autoapprove true \
  --secret "${secret}"

# Harbor (UAA)
uaac client add harbor-client --scope openid \
  --authorized_grant_types client_credentials,password,refresh_token \
  --redirect_uri "https://${harbor_domain}  https://${harbor_domain}/*" \
  --secret "${secret}" \
  --autoapprove true \
  --authorities clients.read,clients.secret,uaa.resource,scim.write,openid,scim.read

# Harbor (OIDC)
uaac client add harbor-oidc --scope openid,roles,uaa.user \
  --authorized_grant_types refresh_token,password,authorization_code \
  --redirect_uri "https://${harbor_domain}/c/oidc/callback" \
  --authorities clients.read,clients.secret,uaa.resource,scim.write,openid,scim.read \
  --autoapprove true \
  --secret "${secret}"

# Spinnaker
uaac client add "spinnaker-client" \
  --scope openid,uaa.user,uaa.resource \
  --authorized_grant_types password,refresh_token,authorization_code,client_credentials \
  --redirect_uri "https://${spinnaker_gate_domain}/login" \
  --autoapprove true \
  --secret "${secret}" \
  --authorities uaa.resource

# Prometheus
uaac client add prometheus-client \
  --scope openid,roles,uaa.user \
  --authorized_grant_types refresh_token,password,authorization_code \
  --redirect_uri "https://${prometheus_domain}/oauth2/callback" \
  --authorities clients.read,clients.secret,uaa.resource,scim.write,openid,scim.read \
  --autoapprove true \
  --secret "${secret}"

# Prometheus
uaac client add grafana-client \
  --scope openid,roles,uaa.user \
  --authorized_grant_types refresh_token,password,authorization_code \
  --redirect_uri "https://${grafana_domain}/login/generic_oauth " \
  --authorities clients.read,clients.secret,uaa.resource,scim.write,openid,scim.read \
  --autoapprove true \
  --secret "${secret}"

# Pivotal Build Service
uaac client add pivotal_build_service_cli --scope="openid" --secret="" \
    --authorized_grant_types="password,refresh_token" --access_token_validity 600 --refresh_token_validity 21600

uaac user add ${username} -p ${password} --emails ${username}@localhost