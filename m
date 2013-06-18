From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: config file lost
Date: Tue, 18 Jun 2013 14:57:29 +0300
Message-ID: <51C04B29.6040906@mellanox.com>
References: <51BDB769.70107@mellanox.com> <51BF591B.4090002@dev.mellanox.co.il> <51C02269.5050105@mellanox.com> <51C0424F.60307@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C0424F.60307-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 18/06/2013 14:19, Hal Rosenstock wrote:
> Is /etc/rdma a standard location in Linux ? Is it used by other RDMA upstream components ?

its used by RHEL packages, not upstream

>
> Also, opensm doesn't by default use this location for the config file. I expect that's dealt with by other scripts RedHat supplies.

yes, this is part of their specs I think
>
>> >so things are plug-and-play, or I need to hack that somehow?
> You would currently need to hack that.

How exactly? I'd like to build rpm from upstream opensm, generate config 
file and have the opensm service script to read this config and apply it 
for successive restarts or sig HUPs I send. Maybe you can come up with 
some patch, it will help


Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
