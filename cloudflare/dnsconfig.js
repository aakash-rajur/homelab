var REG_NONE = NewRegistrar("none");
var DSP_CLOUDFLARE = NewDnsProvider("cloudflare");

D("{{ root_domain }}", REG_NONE, DnsProvider(DSP_CLOUDFLARE), NO_PURGE,
  CNAME("*", "{{ cloudflare_tunnel_id }}.cfargotunnel.com.", CF_PROXY_ON),
  END);
