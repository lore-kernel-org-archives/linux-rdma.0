From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/8] IPoIB: Make the carrier_on_task race aware
Date: Mon, 18 Aug 2014 16:26:40 -0700
Message-ID: <CABgxfbE6edfZZ58=mTvhGqWSkCxsik0XuQPR0L-yayze=803cg@mail.gmail.com>
References: <cover.1407885724.git.dledford@redhat.com>
	<d05cdce70f1312f35f8be2d14bafd2a06809b137.1407885724.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d05cdce70f1312f35f8be2d14bafd2a06809b137.1407885724.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 12, 2014 at 4:38 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> We blindly assume that we can just take the rtnl lock and that will
> prevent races with downing this interface.  Unfortunately, that's not
> the case.  In ipoib_mcast_stop_thread() we will call flush_workqueue()
> in an attempt to clear out all remaining instances of ipoib_join_task.
> But, since this task is put on the same workqueue as the join task, the
> flush_workqueue waits on this thread too.  But this thread is deadlocked
> on the rtnl lock.  The better thing here is to use trylock and loop on
> that until we either get the lock or we see that FLAG_ADMIN_UP has
> been cleared, in which case we don't need to do anything anyway and we
> just return.
>
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index a0a42859f12..7e9cd39b5ef 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -353,18 +353,27 @@ void ipoib_mcast_carrier_on_task(struct work_struct *work)
>                                                    carrier_on_task);
>         struct ib_port_attr attr;
>
> -       /*
> -        * Take rtnl_lock to avoid racing with ipoib_stop() and
> -        * turning the carrier back on while a device is being
> -        * removed.
> -        */
>         if (ib_query_port(priv->ca, priv->port, &attr) ||
>             attr.state != IB_PORT_ACTIVE) {
>                 ipoib_dbg(priv, "Keeping carrier off until IB port is active\n");
>                 return;
>         }
>
> -       rtnl_lock();
> +       /*
> +        * Take rtnl_lock to avoid racing with ipoib_stop() and
> +        * turning the carrier back on while a device is being
> +        * removed.  However, ipoib_stop() will attempt to flush
> +        * the workqueue while holding the rtnl lock, so loop
> +        * on trylock until either we get the lock or we see
> +        * FLAG_ADMIN_UP go away as that signals that we are bailing
> +        * and can safely ignore the carrier on work
> +        */
> +       while (!rtnl_trylock()) {
> +               if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
> +                       return;
> +               else
> +                       msleep(20);
> +       }


I always think rtnl lock is too big for this purpose... and that 20 ms
is not ideal either. Could we have a new IPOIB private mutex used by
ipoib_stop() and this section of code ? So something like:

ipoib_stop()
{    .....
     mutex_lock(&something_new);
     clear_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
     ...
     mutex_unlock(&something_new);
     return 0;
}

Then the loop would become:

// this while-loop will be very short - since we either get the mutex
quickly or "return" quickly.
 while (!mutex_trylock(&something_new)) {
              if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
                      return;
 }


>         if (!ipoib_cm_admin_enabled(priv->dev))
>                 dev_set_mtu(priv->dev, min(priv->mcast_mtu, priv->admin_mtu));
>         netif_carrier_on(priv->dev);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
