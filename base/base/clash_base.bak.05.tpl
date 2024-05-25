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
    - https://223.5.5.5/dns-query
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16
  fake-ip-filter:
    - "*"
    - "+.lan"
    - "+.local"
  nameserver:
    - https://223.5.5.5/dns-query
  nameserver-policy:
    'rule-set:microsoft-cn,apple-cn,google-cn,games-cn': [https://223.5.5.5/dns-query]
    'rule-set:cn,private': [https://223.5.5.5/dns-query]
    'rule-set:proxy': ['https://1.1.1.1/dns-query#🌍国外代理']


profile:
  store-fake-ip: true
  # 储存 fakeip 映射表，域名再次发生连接时，使用原有映射地址
  store-selected: true

unified-delay: false

tcp-concurrent: true

global-client-fingerprint: chrome

{% if local.clash.new_field_name == "true" %}
proxies: ~
proxy-groups: ~

rule-providers:
  ads:
    type: http
    behavior: domain
    format: text
    url: "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@clash-ruleset/ads.list"
    interval: 86400

  applications:
    type: http
    behavior: classical
    format: text
    url: "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@clash-ruleset/applications.list"
    interval: 86400

  private:
    type: http
    behavior: domain
    format: text
    url: "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@clash-ruleset/private.list"
    interval: 86400

  microsoft-cn:
    type: http
    behavior: domain
    format: text
    url: "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@clash-ruleset/microsoft-cn.list"
    interval: 86400

  apple-cn:
    type: http
    behavior: domain
    format: text
    url: "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@clash-ruleset/apple-cn.list"
    interval: 86400

  google-cn:
    type: http
    behavior: domain
    format: text
    url: "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@clash-ruleset/google-cn.list"
    interval: 86400

  games-cn:
    type: http
    behavior: domain
    format: text
    url: "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@clash-ruleset/games-cn.list"
    interval: 86400

  networktest:
    type: http
    behavior: classical
    format: text
    url: "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@clash-ruleset/networktest.list"
    interval: 86400

  proxy:
    type: http
    behavior: domain
    format: text
    url: "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@clash-ruleset/proxy.list"
    interval: 86400

  cn:
    type: http
    behavior: domain
    format: text
    url: "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@clash-ruleset/cn.list"
    interval: 86400

  telegramip:
    type: http
    behavior: ipcidr
    format: text
    url: "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@clash-ruleset/telegramip.list"
    interval: 86400

  privateip:
    type: http
    behavior: ipcidr
    format: text
    url: "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@clash-ruleset/privateip.list"
    interval: 86400

  cnip:
    type: http
    behavior: ipcidr
    format: text
    url: "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@clash-ruleset/cnip.list"
    interval: 86400

rules:

  - RULE-SET,ads,🛑全球拦截
  # - RULE-SET,applications,🎯全球直连
  - RULE-SET,private,🎯全球直连
  - RULE-SET,microsoft-cn,🎯全球直连
  - RULE-SET,apple-cn,🎯全球直连
  # - RULE-SET,google-cn,🎯全球直连
  - RULE-SET,games-cn,🎯全球直连
  - RULE-SET,networktest,🎯全球直连
  - RULE-SET,proxy,🌍国外代理
  - RULE-SET,cn,🎯全球直连
  - RULE-SET,telegramip,🌍国外代理
  - RULE-SET,privateip,🎯全球直连,no-resolve
  - RULE-SET,cnip,🎯全球直连

  - DOMAIN-SUFFIX,demo-gpu.wzhlab.top,🎯全球直连

  # - MATCH,🐟漏网之鱼


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
                "detour": "🌍国外代理"
            },
            {
                "tag": "dns_direct",
                "address": "https://223.5.5.5/dns-query",
                "detour": "DIRECT"
            },
            {
                "tag": "dns_fakeip",
                "address": "fakeip"
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
                  "rule_set": [
                        "microsoft-cn",
                        "apple-cn",
                        "google-cn",
                        "games-cn",
                        "cn",
                        "private"
                  ],
                  "query_type": [
                        "A",
                        "AAAA"
                  ],
                  "server": "dns_direct"
            },
            {
                  "rule_set": [
                        "proxy"
                  ],
                  "query_type": [
                        "A",
                        "AAAA"
                  ],
                  "server": "dns_fakeip",
                  "rewrite_ttl": 1
            }
        ],
        "final": "dns_direct",
        "strategy": "prefer_ipv4",
        "independent_cache": true,
        "reverse_mapping": true,
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
            "sniff_override_destination": true,
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
            { "protocol": [ "dns" ], "outbound": "dns-out" },
            { "rule_set": [ "ads" ], "outbound": "🛑全球拦截" },
            { "rule_set": [ "private" ], "outbound": "🎯全球直连" },
            { "rule_set": [ "microsoft-cn" ], "outbound": "🎯全球直连" },
            { "rule_set": [ "apple-cn" ], "outbound": "🎯全球直连" },
            { "rule_set": [ "games-cn" ], "outbound": "🎯全球直连" },
            { "rule_set": [ "networktest" ], "outbound": "🎯全球直连" },
            { "rule_set": [ "applications" ], "outbound": "🎯全球直连" },
            { "rule_set": [ "proxy" ], "outbound": "🌍国外代理" },
            { "rule_set": [ "cn" ], "outbound": "🎯全球直连" },
            { "rule_set": [ "telegramip" ], "outbound": "🌍国外代理" },
            { "rule_set": [ "privateip" ], "outbound": "🎯全球直连" },
            { "rule_set": [ "cnip" ], "outbound": "🎯全球直连" },
          {
            "ip_is_private": true,
            "outbound": "🎯全球直连"
          }
        ],
        "rule_set": [
          {
            "tag": "ads",
            "type": "remote",
            "format": "binary",
            "url": "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@sing-box-ruleset/ads.srs",
            "download_detour": "DIRECT"
          },
          {
            "tag": "private",
            "type": "remote",
            "format": "binary",
            "url": "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@sing-box-ruleset/private.srs",
            "download_detour": "DIRECT"
          },
          {
            "tag": "microsoft-cn",
            "type": "remote",
            "format": "binary",
            "url": "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@sing-box-ruleset/microsoft-cn.srs",
            "download_detour": "DIRECT"
          },
          {
            "tag": "apple-cn",
            "type": "remote",
            "format": "binary",
            "url": "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@sing-box-ruleset/apple-cn.srs",
            "download_detour": "DIRECT"
          },
          {
            "tag": "google-cn",
            "type": "remote",
            "format": "binary",
            "url": "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@sing-box-ruleset/google-cn.srs",
            "download_detour": "DIRECT"
          },
          {
            "tag": "games-cn",
            "type": "remote",
            "format": "binary",
            "url": "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@sing-box-ruleset/games-cn.srs",
            "download_detour": "DIRECT"
          },
          {
            "tag": "networktest",
            "type": "remote",
            "format": "binary",
            "url": "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@sing-box-ruleset/networktest.srs",
            "download_detour": "DIRECT"
          },
          {
            "tag": "applications",
            "type": "remote",
            "format": "binary",
            "url": "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@sing-box-ruleset/applications.srs",
            "download_detour": "DIRECT"
          },
          {
            "tag": "proxy",
            "type": "remote",
            "format": "binary",
            "url": "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@sing-box-ruleset/proxy.srs",
            "download_detour": "DIRECT"
          },
          {
            "tag": "cn",
            "type": "remote",
            "format": "binary",
            "url": "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@sing-box-ruleset/cn.srs",
            "download_detour": "DIRECT"
          },
          {
            "tag": "telegramip",
            "type": "remote",
            "format": "binary",
            "url": "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@sing-box-ruleset/telegramip.srs",
            "download_detour": "DIRECT"
          },
          {
            "tag": "privateip",
            "type": "remote",
            "format": "binary",
            "url": "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@sing-box-ruleset/privateip.srs",
            "download_detour": "DIRECT"
          },
          {
            "tag": "cnip",
            "type": "remote",
            "format": "binary",
            "url": "https://cdn.jsdelivr.net/gh/DustinWin/ruleset_geodata@sing-box-ruleset/cnip.srs",
            "download_detour": "DIRECT"
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
