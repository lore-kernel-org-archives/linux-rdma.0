From: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ipoib: clear nfct state on xmit
Date: Thu, 09 Feb 2017 18:33:15 +0100
Message-ID: <1486661595.2591.14.camel@redhat.com>
References: <b6fce27b7ffea97ee958578cc3cf0e8ae9393914.1486030684.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b6fce27b7ffea97ee958578cc3cf0e8ae9393914.1486030684.git.pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-02-09 at 18:24 +0100, Paolo Abeni wrote:
> the skbs can be held by the driver for a long time, so we need
> to clear any state on xmit to avoid hanging other subsystems.
> The skbs are already orphaned and dsts are dropped, later in ib/cm
> code, so we just need to clear the nf state.
> Do it early, while the ct entry is hopefully still hot in the
> cache.
> 
> Signed-off-by: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 3ce0765..cb4ddaa 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1050,6 +1050,9 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	struct ipoib_header *header;
>  	unsigned long flags;
>  
> +	/* we can held the skb for along time; avoid hanging ct */
> +	nf_reset(skb);
> +
>  	phdr = (struct ipoib_pseudo_header *) skb->data;
>  	skb_pull(skb, sizeof(*phdr));
>  	header = (struct ipoib_header *) skb->data;

I think this deserve a better explanation.

The following issue:

https://bugzilla.redhat.com/show_bug.cgi?id=1294415

is caused by xmit skbs carrying a notrack ct entry not being freed
by the device driver in a timely manner. Removing the ct module waits
for such entries refcount going to zero and hangs the kernel in busy
loop (for several minutes).

The relevant skbs are icmp6 packets (ND if I recall correctly, they
are multicast packets at the mac level).

Despite the above issue is reported against the bcrmfmac driver, it can
be reproduced even against the ipoib driver, with the following steps:

- ensure ipv6 is enabled on the target device, and firewalld is running
(e.g. the module nf_conntrack_ipv6 is loaded)
- assign a static ip to the device
- shut down the firewall (e.g. try to remove the module nf_conntrack)

I think that the root cause is that multicast packets can be kept in
the mcast queue for an unlimited amount of time, under certain
conditions (still under investigation), so probably a better fix could
be placed in the mcast handling code. 

Paolo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
