#!/bin/sh
#https://www.namecheap.com/support/knowledgebase/article.aspx/29/11/how-to-use-the-browser-to-dynamically-update-hosts-ip


#ip = Optional. If you don't specify any IP, the IP from which you are accessing this URL will be set for the domain.
#export EXTERNAL_IP=`wget -O - ifconfig.me/ip 2>/dev/null`

if [ -e ~/.namecheap_dynamic_dns ]; then
  . ~/.namecheap_dynamic_dns
fi

if [ "${NAMECHEAP_HOSTNAME}" = "" ]; then
  echo "no NAMECHEAP_HOSTNAME defined" 1>&2
  exit 1
fi

if [ "${NAMECHEAP_DOMAIN}" = "" ]; then
  echo "no NAMECHEAP_DOMAIN defined" 1>&2
  exit 1
fi

if [ "${NAMECHEAP_PASSWORD}" = "" ]; then 
  echo "no NAMECHEAP_PASSWORD defined" 1>&2
  exit 1
fi


if [ "${EXTERNAL_IP}" = "" ]; then
  export DDNS_URL="https://dynamicdns.park-your-domain.com/update?host=${NAMECHEAP_HOSTNAME}&domain=${NAMECHEAP_DOMAIN}&password=${NAMECHEAP_PASSWORD}"
else
  export DDNS_URL="https://dynamicdns.park-your-domain.com/update?host=${NAMECHEAP_HOSTNAME}&domain=${NAMECHEAP_DOMAIN}&password=${NAMECHEAP_PASSWORD}&ip=${EXTERNAL_IP}"
fi

echo "setting A record ${NAMECHEAP_HOSTNAME}.${NAMECHEAP_DOMAIN} pointed at ${EXTERNAL_IP}..."
echo "sending $DDNS_URL"
# wget the update url url and grep the response to see if there were no errors

n=0
until [ $n -ge $RETRIES ]; do
  wget --wait=5 -O -$DDNS_URL 2>/dev/null | grep -c "<ErrCount>0</ErrCount>" && break 
  #> /dev/null  
  n=$[$n+1]
  echo "retryiing"
  sleep 5
done

# TODO log the updated IP

if  (($n >= $RETRIES)); then
  echo "`date` [FAILURE]"
else
  echo "`date` [success]"
fi
