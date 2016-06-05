From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/7] IB/IPoIB: Don't update neigh validity for
 unresolved entries
Date: Mon, 6 Jun 2016 00:10:16 +0300
Message-ID: <CAJ3xEMgYKnVh4JECrCSBUYmyCr4s-zxWhMywMVTQPZswLvF61A@mail.gmail.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org> <1465042524-25852-3-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042524-25852-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 4, 2016 at 3:15 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> ipoib_neigh_get whenever tries to access specific neigh updates its
> "alive" variable member, the neigh now considered as updated and won't
> be cleaned by the GC process even if it needs to be resolved again.

Erez,

After reading the above few times, I think you wanted to say something like:

Whenever ipoib_neigh_get tries to access a specific neigh, it updates
the "alive" variable member. The neigh now considered as updated and
won't be cleaned by the GC process even if it needs to be resolved
again.

correct?





> Fixes: b63b70d87741 ("IPoIB: Use a private hash table for path lookup in xmit path")
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 2d7c163..c558c32 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1206,7 +1206,9 @@ struct ipoib_neigh *ipoib_neigh_get(struct net_device *dev, u8 *daddr)
>                                 neigh = NULL;
>                                 goto out_unlock;
>                         }
> -                       neigh->alive = jiffies;
> +
> +                       if (likely(skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE))
> +                               neigh->alive = jiffies;

why testing the queue len makes things right?

>                         goto out_unlock;
>                 }
>         }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
