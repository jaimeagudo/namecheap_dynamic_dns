Namecheap.com dynamic dns client script
===================================

A script which will update an A record for any namecheap domain with dynamic DNS enabled.  The intended use case is to run this script periodically via a cron job from home servers to mimic the behavior of a router with dyndns configured. See [namecheap.com](https://www.namecheap.com/support/knowledgebase/article.aspx/29/11/how-to-use-the-browser-to-dynamically-update-hosts-ip) of up to date details


Install
=======

```
sudo wget -O /usr/local/bin/update_namecheap_dynamic_dns.sh https://raw.github.com/jaimeagudo/namecheap_dynamic_dns/master/update_namecheap_dynamic_dns.sh
sudo chmod 775 /usr/local/bin/update_namecheap_dynamic_dns.sh
```

Configuration
=============

You need to setup these environments variables somehow. They can either be set in `~/.namecheap_dynamic_dns`, or at your convenience before running the script:

```
NAMECHEAP_PASSWORD=[your password]
NAMECHEAP_HOSTNAME=[your hostname]
NAMECHEAP_DOMAIN=[your domain name]
RETRIES=[number of retries just in case]
```

Setup a crontab task with `crontab -e` like

```
*/15 * * * * /usr/local/bin/update_namecheap_dynamic_dns.sh
```
