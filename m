From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: opensm logs can go anywhere in size?
Date: Thu, 7 Jul 2011 12:07:01 +0300
Message-ID: <4E157735.1040901@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

I just noted that opensm logs can go anywhere in size when one of my
nodes had no space left on device after the opensm log level was raised...

I see that the rpm provided with RHEL6 is setting an  
/etc/logrotate.d/opensm
entry which is a copy of ./scripts/opensm.logrotate from the opensm git 
saying

/var/log/opensm.log {
     missingok
     notifempty
     copytruncate
     weekly
     compress
}

this lacks size limitation, isn't that?

I opened ofa bz ticket #2280 to track that,

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
