From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] ipoib: Ratelimit messages which can flood a host.
Date: Tue, 26 Jul 2016 21:00:22 +0300
Message-ID: <20160726180021.GA6144@yuval-lap.uk.oracle.com>
References: <1469543929-17659-1-git-send-email-kernel@kyup.com>
 <1469543929-17659-2-git-send-email-kernel@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469543929-17659-2-git-send-email-kernel-6AxghH7DbtA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 26, 2016 at 05:38:49PM +0300, Nikolay Borisov wrote:
> In case an infiniband outtage occurs the messages modified
> in this patchset can flood the host with a rate of 1 message per

s/patchset/patch

> ms which is a lot. Using the ratelimited version of ipoib_warn
> fixes the issue by limiting at most 10 messages in 5 seconds.
> 
> Signed-off-by: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 7d3281866ffc..dd5b4afbc00b 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1034,9 +1034,9 @@ static void ipoib_timeout(struct net_device *dev)
>  {
>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
>  
> -	ipoib_warn(priv, "transmit timeout: latency %d msecs\n",
> +	ipoib_warn_rl(priv, "transmit timeout: latency %d msecs\n",
>  		   jiffies_to_msecs(jiffies - dev->trans_start));
> -	ipoib_warn(priv, "queue stopped %d, tx_head %u, tx_tail %u\n",
> +	ipoib_warn_rl(priv, "queue stopped %d, tx_head %u, tx_tail %u\n",

So this is just to hide the hide the problem, the real question is what is
causing this to happen a lot.

>  		   netif_queue_stopped(dev),
>  		   priv->tx_head, priv->tx_tail);
>  	/* XXX reset QP, etc. */
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
