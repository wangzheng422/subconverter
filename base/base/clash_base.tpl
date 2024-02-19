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
    'geosite:geolocation-cn,private': 
      - https://223.5.5.5/dns-query
    'geosite:gfw': 
      - 'https://1.1.1.1/dns-query#🌍国外代理'
    'geosite:geolocation-!cn': 
      - 'https://1.1.1.1/dns-query#🌍国外代理'
  nameserver:
    - https://223.5.5.5/dns-query
  fallback:
    - 'https://1.1.1.1/dns-query#🌍国外代理'
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
  - GEOSITE,category-ads-all,🛑全球拦截

  # - GEOSITE,icloud@cn,🎯全球直连
  # - GEOSITE,apple@cn,🎯全球直连
  # - GEOSITE,apple-cn,🎯全球直连
  # - GEOSITE,google@cn,🎯全球直连
  # - GEOSITE,microsoft@cn,🎯全球直连
  - GEOSITE,geolocation-cn,🎯全球直连

  - GEOSITE,facebook,🌍国外代理
  - GEOSITE,youtube,🌍国外代理
  - GEOSITE,google,🌍国外代理
  - GEOSITE,microsoft,🌍国外代理
  - GEOSITE,apple,🌍国外代理
  - GEOSITE,icloud,🌍国外代理
  - GEOSITE,geolocation-!cn,🌍国外代理

  - GEOIP,private,🎯全球直连,no-resolve
  - GEOIP,cn,🎯全球直连
  - GEOIP,telegram,🌍国外代理,no-resolve

  - MATCH,🐟漏网之鱼


{% else %}
Proxy: ~
Proxy Group: ~
Rule: ~
{% endif %}

{% endif %}
{% if request.target == "singbox" %}

{
    "log": {
        "disabled": false,
        "level": "info",
        "timestamp": true
    },
    "dns": {
        "servers": [
            {
                "tag": "dns_proxy",
                "address": "https://1.1.1.1/dns-query",
                "address_resolver": "dns_resolver",
                "detour": "🌍国外代理"
            },
            {
                "tag": "dns_direct",
                "address": "https://223.5.5.5/dns-query",
                "address_resolver": "dns_resolver",
                "detour": "DIRECT"
            },
            {
                "tag": "dns_fakeip",
                "address": "fakeip"
            },
            {
                "tag": "dns_resolver",
                "address": "223.5.5.5",
                "detour": "DIRECT"
            },
            {
                "tag": "block",
                "address": "rcode://success"
            }
        ],
        "rules": [
            {
                "outbound": [
                    "any"
                ],
                "server": "dns_direct"
            },
            {
              "inbound": "tun",
              "query_type": [
                "A",
                "AAAA"
              ],
              "server": "fakeip",
              "rewrite_ttl": 1
            },
            {
                "rule_set": "geolocation-!cn",
                "server": "dns_proxy"
            },
            {
              "rule_set": "cn",
              "server": "dns_direct"
            }
        ],
        "final": "dns_direct",
        "independent_cache": true,
        "fakeip": {
            "enabled": true,
            {% if default(request.singbox.ipv6, "") == "1" %}
            "inet6_range": "fc00::\/18",
            {% endif %}
            "inet4_range": "198.18.0.0\/15"
        }
    },
    "inbounds": [
        {
            "type": "mixed",
            "tag": "mixed-in",
            {% if bool(default(global.singbox.allow_lan, "")) %}
            "listen": "0.0.0.0",
            {% else %}
            "listen": "127.0.0.1",
            {% endif %}
            "listen_port": {{ default(global.singbox.mixed_port, "2080") }}
        },
        {
            "type": "tun",
            "tag": "tun-in",
            "inet4_address": "172.19.0.1/30",
            {% if default(request.singbox.ipv6, "") == "1" %}
            "inet6_address": "fdfe:dcba:9876::1/126",
            {% endif %}
            "auto_route": true,
            "strict_route": true,
            "stack": "system",
            "sniff": true,
            "platform": {
              "http_proxy": {
                "enabled": true,
                "server": "127.0.0.1",
                "server_port": 2080
              }
            }
        }
    ],
    "outbounds": [],
    "route": {
        "rules": [
          {
            "ip_is_private": true,
            "outbound": "🎯全球直连"
          },
          {
            "rule_set": "cn",
            "outbound": "🎯全球直连"
          },
          {
            "rule_set": "geolocation-!cn",
            "outbound": "🌍国外代理"
          }
        ],
        "rule_set": [
            {
              "tag": "cn",
              "type": "remote",
              "format": "binary",
              "url": "https://github.com/MetaCubeX/meta-rules-dat/raw/sing/geo-lite/mixed/cn.srs",
              "download_detour": "🌍国外代理"
            },
            {
              "tag": "geolocation-!cn",
              "type": "remote",
              "format": "binary",
              "url": "https://github.com/MetaCubeX/meta-rules-dat/raw/sing/geo/geosite/geolocation-!cn.srs",
              "download_detour": "🌍国外代理"
            }
        ],
        "auto_detect_interface": true
    },
    "experimental": {
        "cache_file": {
            "enabled": true,
            "store_fakeip": true
        }
    }
}

{% endif %}
