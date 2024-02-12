{% if request.target == "clash" or request.target == "clashr" %}

port: {{ default(global.clash.http_port, "7890") }}
socks-port: {{ default(global.clash.socks_port, "7891") }}
allow-lan: {{ default(global.clash.allow_lan, "true") }}
mode: Rule
log-level: {{ default(global.clash.log_level, "info") }}
external-controller: :9090

dns:
  enable: true
  prefer-h3: true
  listen: 0.0.0.0:10053
  ipv6: true
  default-nameserver:
    - 223.5.5.5
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16
  fake-ip-filter:
    - '*.lan'
    - localhost.ptlogin2.qq.com
  nameserver-policy:
    'geosite:cn': https://223.5.5.5/dns-query
  nameserver:
    - https://223.5.5.5/dns-query
  fallback:
    - https://1.1.1.1/dns-query
  proxy-server-nameserver:
    - https://223.5.5.5/dns-query
  fallback-filter:
    geoip: true
    geoip-code: CN
    geosite:
      - gfw
    ipcidr:
      - 240.0.0.0/4
    domain:
      - '+.google.com'
      - '+.facebook.com'
      - '+.youtube.com'


profile:
  store-fake-ip: true
  # 储存 fakeip 映射表，域名再次发生连接时，使用原有映射地址

unified-delay: true

tcp-concurrent: true

global-client-fingerprint: chrome

geodata-mode: true 

{% if local.clash.new_field_name == "true" %}
proxies: ~
proxy-groups: ~
rules: ~
{% else %}
Proxy: ~
Proxy Group: ~
Rule: ~
{% endif %}

{% endif %}
