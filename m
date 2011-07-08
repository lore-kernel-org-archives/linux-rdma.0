From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: opensm logs can go anywhere in size?
Date: Fri, 8 Jul 2011 12:20:30 +0300
Message-ID: <20110708092030.GA7420@calypso.voltaire.com>
References: <4E157735.1040901@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E157735.1040901-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or,

On 12:07 Thu 07 Jul     , Or Gerlitz wrote:
> Hi Alex,
> 
> I just noted that opensm logs can go anywhere in size when one of my
> nodes had no space left on device after the opensm log level was raised...
> 
> I see that the rpm provided with RHEL6 is setting an
> /etc/logrotate.d/opensm
> entry which is a copy of ./scripts/opensm.logrotate from the opensm
> git saying
> 
> /var/log/opensm.log {
>     missingok
>     notifempty
>     copytruncate
>     weekly
>     compress
> }
> 
> this lacks size limitation, isn't that?
> 
> I opened ofa bz ticket #2280 to track that,
> 

It's a good point. What should be the limit? 1MB, 10MB, 100MB? How many
history files (rotate) should be kept?
Moreover, this flooding would also happen if you don't enable logroatate, so
should we enable some default limit to opensm log (--log_limit)?

-- Alex.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
