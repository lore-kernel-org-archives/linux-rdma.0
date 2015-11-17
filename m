From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Change sendq threshold size
Date: Tue, 17 Nov 2015 08:45:08 +0200
Message-ID: <CAAk-MO_AjkaktRRXEPWSGTqf6t2F_0xS8OFVh_8PN4tyYRMZSQ@mail.gmail.com>
References: <1447700076-795-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447700076-795-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 16, 2015 at 8:54 PM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Expecting half of the queue to be empty before reopening netif_queue seems
> too high.
> With this fix threshold will be 90%.

Is this backed by tests? why not 75% or 25%?

The origin reason for keeping the queue closed till half of the
completions returned was according to the the reason that the HW in
some cases doesn't keep pace with heavy TX flow, so it was good to
stop the kernel from sending till the HW cleans all the waiting
completions.
If the trash hold will be high (90%) we will see many close/open of
the queue under long flow of traffic, which can lead to more back
pressure to the kernel and to lower bw or higher latency at the end.

(If you have tests that show the opposite, please share.)

>
> Suggested-By: Ajaykumar Hotchandani <ajaykumar.hotchandani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h      |    4 ++++
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c   |    8 ++++----
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c   |    4 ++--
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |    5 +++++
>  4 files changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
> index edc5b85..9dd97ac 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -115,6 +115,9 @@ enum {
>         IPOIB_RTNL_CHILD          = 2,
>  };
>
> +/* Wake queue in case tx_outstanding go below 90% of sendq size */
> +#define IPOIB_TX_RING_LOW_TH_FACTOR    90
> +
>  #define        IPOIB_OP_RECV   (1ul << 31)
>  #ifdef CONFIG_INFINIBAND_IPOIB_CM
>  #define        IPOIB_OP_CM     (1ul << 30)
> @@ -767,6 +770,7 @@ static inline void ipoib_unregister_debugfs(void) { }
>         ipoib_printk(KERN_WARNING, priv, format , ## arg)
>
>  extern int ipoib_sendq_size;
> +extern int ipoib_sendq_low_th;
>  extern int ipoib_recvq_size;
>
>  extern struct ib_sa_client ipoib_sa_client;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> index c78dc16..446f394 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -796,9 +796,9 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
>         netif_tx_lock(dev);
>
>         ++tx->tx_tail;
> -       if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
> +       if (unlikely(--priv->tx_outstanding == ipoib_sendq_low_th) &&
>             netif_queue_stopped(dev) &&
> -           test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
> +           likely(test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags)))
>                 netif_wake_queue(dev);
>
>         if (wc->status != IB_WC_SUCCESS &&
> @@ -1198,9 +1198,9 @@ timeout:
>                 dev_kfree_skb_any(tx_req->skb);
>                 ++p->tx_tail;
>                 netif_tx_lock_bh(p->dev);
> -               if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
> +               if (unlikely(--priv->tx_outstanding == ipoib_sendq_low_th) &&
>                     netif_queue_stopped(p->dev) &&
> -                   test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
> +                   likely(test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags)))
>                         netif_wake_queue(p->dev);
>                 netif_tx_unlock_bh(p->dev);
>         }
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index d266667..6f12009 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -397,9 +397,9 @@ static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
>         dev_kfree_skb_any(tx_req->skb);
>
>         ++priv->tx_tail;
> -       if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
> +       if (unlikely(--priv->tx_outstanding == ipoib_sendq_low_th) &&
>             netif_queue_stopped(dev) &&
> -           test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
> +           likely(test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags)))
>                 netif_wake_queue(dev);
>
>         if (wc->status != IB_WC_SUCCESS &&
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index babba05..8f2f8fc 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -62,6 +62,7 @@ MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_VERSION(DRV_VERSION);
>
>  int ipoib_sendq_size __read_mostly = IPOIB_TX_RING_SIZE;
> +int ipoib_sendq_low_th __read_mostly;
>  int ipoib_recvq_size __read_mostly = IPOIB_RX_RING_SIZE;
>
>  module_param_named(send_queue_size, ipoib_sendq_size, int, 0444);
> @@ -2001,6 +2002,10 @@ static int __init ipoib_init_module(void)
>         ipoib_sendq_size = roundup_pow_of_two(ipoib_sendq_size);
>         ipoib_sendq_size = min(ipoib_sendq_size, IPOIB_MAX_QUEUE_SIZE);
>         ipoib_sendq_size = max3(ipoib_sendq_size, 2 * MAX_SEND_CQE, IPOIB_MIN_QUEUE_SIZE);
> +       /* Let's do it once so no need to recalculate on every send cycle */
> +       ipoib_sendq_low_th = (ipoib_sendq_size * IPOIB_TX_RING_LOW_TH_FACTOR /
> +                             100);
> +
>  #ifdef CONFIG_INFINIBAND_IPOIB_CM
>         ipoib_max_conn_qp = min(ipoib_max_conn_qp, IPOIB_CM_MAX_CONN_QP);
>  #endif
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
