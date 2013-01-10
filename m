From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH FIXES for 3.8] mlx4: Fix advertizement of wrong PF context
 behaviour
Date: Thu, 10 Jan 2013 17:25:16 +0200
Message-ID: <50EEDD5C.4070504@mellanox.com>
References: <1357831115-10603-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357831115-10603-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/01/2013 17:18, Or Gerlitz wrote:
> Commit 08ff32352 "mlx4: 64-byte CQE/EQE support" introduced a regression under
> which older guest VF drivers failed to load even when 64-byte EQEs/CQEs are
> disabled, since the PF wrongly advertizes the new context behaviour anyway,

Roland, when testing this patch under old/new guest kernels, with a host 
kernel based on your git tree
/ for-next branch I noted that the branch is behind 3.8-rc1, e.g I 
stepped on issue in the tap driver which is  fixed on commit 
76fe45812a3b134c39170ca32dfd4b7217d33145 "tuntap: reset network header 
before calling skb_get_rxhash()"
so you need to update it for enabling testing with it... For my tests I 
just applied this patch (thanks! Michael)

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
