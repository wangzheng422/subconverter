FROM docker.io/tindy2013/subconverter:latest

COPY base/base/clash_base.tpl /base/base/

COPY base/rules/wzh /base/rules

COPY base/pref.toml /base/

EXPOSE 25500