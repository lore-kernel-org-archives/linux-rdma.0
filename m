From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: optimized the function ipoib_mcast_alloc
Date: Mon, 2 Nov 2015 12:08:24 +0200
Message-ID: <CAAk-MO-sNJnA+=9ApizAspWY7eZJ-pNWMUTFD4HFcUs7+YaUgQ@mail.gmail.com>
References: <1446359029-6261-1-git-send-email-saurabh.truth@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446359029-6261-1-git-send-email-saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 1, 2015 at 8:23 AM, Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> ipoib_mcast_alloc is called only in atomic context,
> hence removing the extra check.
>
> Signed-off-by: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> ---
> Hi,
> Even if in future, if there are some functions expected to call it in normal context(not atomic),
> we can pass the GFP_KERNEL or GFP_ATOMIC directly to function call instead of passing 0 and 1,
> which later again need to be compared in order to change it to GFP_KERNEL and GFP_ATOMIC.
> Please let me know if there are better ways to improve it.
>
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index d750a86..15d35be 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -132,12 +132,11 @@ void ipoib_mcast_free(struct ipoib_mcast *mcast)
>         kfree(mcast);
>  }
>
> -static struct ipoib_mcast *ipoib_mcast_alloc(struct net_device *dev,
> -                                            int can_sleep)
> +static struct ipoib_mcast *ipoib_mcast_alloc(struct net_device *dev)
>  {
>         struct ipoib_mcast *mcast;
>
> -       mcast = kzalloc(sizeof *mcast, can_sleep ? GFP_KERNEL : GFP_ATOMIC);
> +       mcast = kzalloc(sizeof *mcast, GFP_ATOMIC);
>         if (!mcast)
>                 return NULL;
>
> @@ -573,7 +572,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
>         if (!priv->broadcast) {
>                 struct ipoib_mcast *broadcast;
>
> -               broadcast = ipoib_mcast_alloc(dev, 0);
> +               broadcast = ipoib_mcast_alloc(dev);
>                 if (!broadcast) {
>                         ipoib_warn(priv, "failed to allocate broadcast group\n");
>                         /*
> @@ -728,7 +727,7 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
>                         ipoib_dbg_mcast(priv, "setting up send only multicast group for %pI6\n",
>                                         mgid);
>
> -                       mcast = ipoib_mcast_alloc(dev, 0);
> +                       mcast = ipoib_mcast_alloc(dev);
>                         if (!mcast) {
>                                 ipoib_warn(priv, "unable to allocate memory "
>                                            "for multicast structure\n");
> @@ -886,7 +885,7 @@ void ipoib_mcast_restart_task(struct work_struct *work)
>                         ipoib_dbg_mcast(priv, "adding multicast entry for mgid %pI6\n",
>                                         mgid.raw);
>
> -                       nmcast = ipoib_mcast_alloc(dev, 0);
> +                       nmcast = ipoib_mcast_alloc(dev);
>                         if (!nmcast) {
>                                 ipoib_warn(priv, "unable to allocate memory for multicast structure\n");
>                                 continue;
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
