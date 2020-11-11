echo -e "\033[32;5mStarting Attack Logs \033[0m"
interface=eth0
dumpdir=/root/tcpdump
capturefile=/root/tcpdump/output.txt
 url='https://discordapp.com/api/webhooks/' ## Change this to your Webhook URL
while /bin/true; do
  pkt_old=`grep $interface: /proc/net/dev | cut -d :  -f2 | awk '{ print $2 }'`
  sleep 1
  pkt_new=`grep $interface: /proc/net/dev | cut -d :  -f2 | awk '{ print $2 }'`
 
  pkt=$(( $pkt_new - $pkt_old ))
  echo -ne "\r$pkt packets/s\033[0K"
 
  if [ $pkt -gt 2500 ]; then ## Attack alert will display after incoming traffic reach 2500 PPS
    echo "Attack Detected"
    curl -H "Content-Type: application/json" -X POST -d '{
      "embeds": [{
      	"inline": false,
        "title": "Attack Detected",
        "username": "Attack Alerts",
        "color": 15158332,
         "thumbnail": {
          "url": "https://cdn.discordapp.com/attachments/751555533009321997/762423318330081280/800px-Flag_of_the_United_Kingdom.svg.png"
        },
         "footer": {
            "text": "Server under a DDoS attack",
            "icon_url": "https://cdn.discordapp.com/attachments/751555533009321997/762423318330081280/800px-Flag_of_the_United_Kingdom.svg.png"
          },
    
        "description": "Detection of an attack ",
         "fields": [
      {
        "name": "***Server Provider***",
        "value": "``Put your Hosting Provider Here``",
        "inline": false
      },
      {
        "name": "***Alert Type***",
        "value": "``Under Attack!``",
        "inline": false
      },
      {
        "name": "***Location***",
        "value": ":flag_uk: ``United Kingdom``",
        "inline": false
      }
    ]
      }]
    }' $url
    echo "Paused for."
    sleep 220  ## The "Attack no longer detected" alert will display in 220 seconds
    curl -H "Content-Type: application/json" -X POST -d '{
      "embeds": [{
      	"inline": false,
        "title": "Attack no longer detected",
        "username": "Attack Detection",
        "color": 3066993,
         "thumbnail": {
          "url": "https://cdn.discordapp.com/attachments/751555533009321997/762423318330081280/800px-Flag_of_the_United_Kingdom.svg.png"
        },
         "footer": {
            "text": "Attack no longer detected",
            "icon_url": "https://cdn.discordapp.com/attachments/751555533009321997/762423318330081280/800px-Flag_of_the_United_Kingdom.svg.png"
          },    
          
        "description": "End of attack ",
         "fields": [
      {
        "name": "***Server Provider***",
        "value": "``Put your Hosting Provider here``",  // 
        "inline": false
      },
      {
        "name": "***Alert Type***",
        "value": "``Attack Finished``",
        "inline": false
      },
      {
        "name": "***Location***",
        "value": ":flag_uk: ``United Kingdom``",
        "inline": false
      }
    ]
      }]
    }' $url
  fi
done