{% if request.target == "clash" or request.target == "clashr" %}

port: {{ default(global.clash.http_port, "7890") }}
socks-port: {{ default(global.clash.socks_port, "7891") }}
allow-lan: {{ default(global.clash.allow_lan, "true") }}
mode: Rule
log-level: {{ default(global.clash.log_level, "info") }}
external-controller: :9090

dns:
  enable: true
  use-hosts: true
  listen: 127.0.0.1:10053
  ipv6: true
  default-nameserver:
    - 223.5.5.5
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16
  fake-ip-filter:
    - '*.lan'
    - localhost.ptlogin2.qq.com
  nameserver-policy:
    'geosite:cn,private': 
      - https://223.5.5.5/dns-query
    'geosite:gfw': 
      - 'https://1.1.1.1/dns-query#proxy'
    'geosite:!cn': 
      - 'https://1.1.1.1/dns-query#proxy'
  nameserver:
    - https://223.5.5.5/dns-query
  fallback:
    - 'https://1.1.1.1/dns-query#proxy'
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

geodata-loader: memconservative

geo-auto-update: true

geo-update-interval: 24

geox-url:
  geoip: "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.dat"
  geosite: "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geosite.dat"
  mmdb: "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/country.mmdb"

{% if local.clash.new_field_name == "true" %}
proxies: ~
proxy-groups: ~
rules:
  # rule GEOSITE
  - GEOSITE,category-ads-all,🛑 全球拦截

  # - GEOSITE,icloud@cn,🎯 全球直连
  # - GEOSITE,apple@cn,🎯 全球直连
  # - GEOSITE,apple-cn,🎯 全球直连
  # - GEOSITE,google@cn,🎯 全球直连
  # - GEOSITE,microsoft@cn,🎯 全球直连
  - GEOSITE,geolocation-cn,🎯 全球直连

  - GEOSITE,facebook,🌍 国外代理
  - GEOSITE,youtube,🌍 国外代理
  - GEOSITE,google,🌍 国外代理
  - GEOSITE,microsoft,🌍 国外代理
  - GEOSITE,apple,🌍 国外代理
  - GEOSITE,icloud,🌍 国外代理
  - GEOSITE,geolocation-!cn,🌍 国外代理

  - GEOIP,private,🎯 全球直连,no-resolve
  - GEOIP,cn,🎯 全球直连
  - GEOIP,telegram,🌍 国外代理,no-resolve

  - MATCH,🐟 漏网之鱼


{% else %}
Proxy: ~
Proxy Group: ~
Rule: ~
{% endif %}

{% endif %}
