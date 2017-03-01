From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] ipoib: clean ib tx ring periodically
Date: Wed, 1 Mar 2017 09:28:33 +0200
Message-ID: <CAAk-MO_J2JL9YvNEV24LJik8qGKrBHBW+2NtzAOL+QEve1CMJg@mail.gmail.com>
References: <589591340739f0ceeea9ca449b6de3df01caadc4.1487259121.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <589591340739f0ceeea9ca449b6de3df01caadc4.1487259121.git.pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 16, 2017 at 5:35 PM, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The skbs transmitted via ipoib_send() are freed only if there are
> 16 or more outstanding work requests or if the send queue is full.
>
> If there is very little networking activity, the transmitted skbs
> can be held by the device driver for an unlimited amount of time,
> starving other subsystems.
>
> E.g. assuming the ipv6 is enabled, with the following sequence:
>
> systemctl start firewalld
> modprobe ib_ipoib
> ip addr add dev ib0 fc00::1/64
> systemctl stop firewalld
>
> a cpu will hang: rmmod conntrack will keep a core busy
> spinning for nf_conntrack_untracked going to 0, since some ICMP6
> ND packets are generated and transmitted when the ipv6 address
> is attached to the device, and such packets get a notrack ct
> entry.
>
> This change address the issue introducing a periodic timer performing
> "garbage collection" on the send ring at low frequency (once every
> second).
>
> This new timer runs independently from the currently used poll_timer,
> so that no additional delay is introduced to clean the ring after
> errors or ring full event.

Hi,

Adding a new timer is not the required solution, it is a w/a over the
TX part in the ipoib driver.
The real solution, IMHO, is to use the napi mechanism for the TX in a
similar way as it done in the RX. (as it done in many network drivers)

We (Mellanox) are planning to send such solution in the next few days.

Thanks,

>
> Reported-by: Thomas Cameron <tcameron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Fixes: f56bcd801356 ("IPoIB: Use separate CQ for UD send completions")
> Signed-off-by: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h    |  2 ++
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c | 35 +++++++++++++++++++++++++++------
>  2 files changed, 31 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
> index da12717..3b5039b 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -402,6 +402,8 @@ struct ipoib_dev_priv {
>         u64     hca_caps;
>         struct ipoib_ethtool_st ethtool;
>         struct timer_list poll_timer;
> +       struct timer_list tx_gc_timer;
> +       unsigned long drain_tx_cq_stamp;
>         unsigned max_send_sge;
>         bool sm_fullmember_sendonly_support;
>  };
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 5038f9d..e565848 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -490,13 +490,20 @@ void ipoib_ib_completion(struct ib_cq *cq, void *dev_ptr)
>         napi_schedule(&priv->napi);
>  }
>
> +static void __drain_tx_cq(struct ipoib_dev_priv *priv)
> +{
> +       while (poll_tx(priv))
> +               ; /* nothing */
> +
> +       priv->drain_tx_cq_stamp = jiffies;
> +}
> +
>  static void drain_tx_cq(struct net_device *dev)
>  {
>         struct ipoib_dev_priv *priv = netdev_priv(dev);
>
>         netif_tx_lock(dev);
> -       while (poll_tx(priv))
> -               ; /* nothing */
> +       __drain_tx_cq(priv);
>
>         if (netif_queue_stopped(dev))
>                 mod_timer(&priv->poll_timer, jiffies + 1);
> @@ -637,8 +644,7 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
>         }
>
>         if (unlikely(priv->tx_outstanding > MAX_SEND_CQE))
> -               while (poll_tx(priv))
> -                       ; /* nothing */
> +               __drain_tx_cq(priv);
>  }
>
>  static void __ipoib_reap_ah(struct net_device *dev)
> @@ -697,6 +703,19 @@ static void ipoib_ib_tx_timer_func(unsigned long ctx)
>         drain_tx_cq((struct net_device *)ctx);
>  }
>
> +static void ipoib_tx_gc_timer_func(unsigned long ctx)
> +{
> +       struct net_device *dev = (struct net_device *)ctx;
> +       struct ipoib_dev_priv *priv = netdev_priv(dev);
> +
> +       netif_tx_lock(dev);
> +       if (time_after(jiffies, priv->drain_tx_cq_stamp + HZ))
> +               __drain_tx_cq(priv);
> +       netif_tx_unlock(dev);
> +
> +       mod_timer(&priv->tx_gc_timer, jiffies + HZ);
> +}
> +
>  int ipoib_ib_dev_open(struct net_device *dev)
>  {
>         struct ipoib_dev_priv *priv = netdev_priv(dev);
> @@ -834,8 +853,7 @@ void ipoib_drain_cq(struct net_device *dev)
>                 }
>         } while (n == IPOIB_NUM_WC);
>
> -       while (poll_tx(priv))
> -               ; /* nothing */
> +       __drain_tx_cq(priv);
>
>         local_bh_enable();
>  }
> @@ -906,6 +924,7 @@ int ipoib_ib_dev_stop(struct net_device *dev)
>
>  timeout:
>         del_timer_sync(&priv->poll_timer);
> +       del_timer_sync(&priv->tx_gc_timer);
>         qp_attr.qp_state = IB_QPS_RESET;
>         if (ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE))
>                 ipoib_warn(priv, "Failed to modify QP to RESET state\n");
> @@ -932,6 +951,10 @@ int ipoib_ib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
>
>         setup_timer(&priv->poll_timer, ipoib_ib_tx_timer_func,
>                     (unsigned long) dev);
> +       setup_timer(&priv->tx_gc_timer, ipoib_tx_gc_timer_func,
> +                   (unsigned long) dev);
> +       mod_timer(&priv->tx_gc_timer, jiffies + HZ);
> +       priv->drain_tx_cq_stamp = jiffies;
>
>         if (dev->flags & IFF_UP) {
>                 if (ipoib_ib_dev_open(dev)) {
> --
> 2.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
