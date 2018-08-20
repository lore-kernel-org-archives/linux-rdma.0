From: Erez Shitrit <erezsh@dev.mellanox.co.il>
Subject: Re: [PATCH v2] avoid race condition between start_xmit and cm_rep_handler
Date: Mon, 20 Aug 2018 09:36:53 +0300
Message-ID: <CAAk-MO97rinpQXhyy7VZA6HWNwm94UuWAFnLFOSb4mj1wW4fQw@mail.gmail.com>
References: <1534541486-16263-1-git-send-email-aaron.s.knister@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1534541486-16263-1-git-send-email-aaron.s.knister@nasa.gov>
Sender: stable-owner@vger.kernel.org
To: Aaron Knister <aaron.s.knister@nasa.gov>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, John Fleck <john.fleck@intel.com>, Feras Daoud <ferasda@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi,

Did you check the option to hold the netif_tx_lock_xxx() in
ipoib_cm_rep_handler function (over the line
set_bit(IPOIB_FLAG_OPER_UP)) instead of in the send data path flow?

Thanks,

On Sat, Aug 18, 2018 at 12:31 AM, Aaron Knister
<aaron.s.knister@nasa.gov> wrote:
> Inside of start_xmit() the call to check if the connection is up and the
> queueing of the packets for later transmission is not atomic which
> leaves a window where cm_rep_handler can run, set the connection up,
> dequeue pending packets and leave the subsequently queued packets by
> start_xmit() sitting on neigh->queue until they're dropped when the
> connection is torn down. This only applies to connected mode. These
> dropped packets can really upset TCP, for example,  and cause
> multi-minute delays in transmission for open connections.
>
> Here's the code in start_xmit where we check to see if the connection
> is up:
>
>        if (ipoib_cm_get(neigh)) {
>                if (ipoib_cm_up(neigh)) {
>                        ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
>                        goto unref;
>                }
>        }
>
> The race occurs if cm_rep_handler execution occurs after the above
> connection check (specifically if it gets to the point where it acquires
> priv->lock to dequeue pending skb's) but before the below code snippet
> in start_xmit where packets are queued.
>
>        if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
>                push_pseudo_header(skb, phdr->hwaddr);
>                spin_lock_irqsave(&priv->lock, flags);
>                __skb_queue_tail(&neigh->queue, skb);
>                spin_unlock_irqrestore(&priv->lock, flags);
>        } else {
>                ++dev->stats.tx_dropped;
>                dev_kfree_skb_any(skb);
>        }
>
> The patch re-checks ipoib_cm_up with priv->lock held to avoid this
> race condition. Since odds are the conn should be up most of the time
> (and thus the connection *not* down most of the time) we don't hold the
> lock for the first check attempt to avoid a slowdown from unecessary
> locking for the majority of the packets transmitted during the
> connection's life.
>
> Signed-off-by: Aaron Knister <aaron.s.knister@nasa.gov>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 46 ++++++++++++++++++++++++++-----
>  1 file changed, 39 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 26cde95b..a950c916 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1093,6 +1093,21 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
>         spin_unlock_irqrestore(&priv->lock, flags);
>  }
>
> +static bool defer_neigh_skb(struct sk_buff *skb,
> +                           struct net_device *dev,
> +                           struct ipoib_neigh *neigh,
> +                           struct ipoib_pseudo_header *phdr)
> +{
> +       if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
> +               push_pseudo_header(skb, phdr->hwaddr);
> +               __skb_queue_tail(&neigh->queue, skb);
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
> +
>  static netdev_tx_t ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
>         struct ipoib_dev_priv *priv = ipoib_priv(dev);
> @@ -1101,6 +1116,7 @@ static netdev_tx_t ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
>         struct ipoib_pseudo_header *phdr;
>         struct ipoib_header *header;
>         unsigned long flags;
> +       bool deferred_pkt = true;
>
>         phdr = (struct ipoib_pseudo_header *) skb->data;
>         skb_pull(skb, sizeof(*phdr));
> @@ -1160,6 +1176,23 @@ static netdev_tx_t ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
>                         ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
>                         goto unref;
>                 }
> +               /*
> +                * Re-check ipoib_cm_up with priv->lock held to avoid
> +                * race condition between start_xmit and skb_dequeue in
> +                * cm_rep_handler. Since odds are the conn should be up
> +                * most of the time, we don't hold the lock for the
> +                * first check above
> +                */
> +               spin_lock_irqsave(&priv->lock, flags);
> +               if (ipoib_cm_up(neigh)) {
> +                       spin_unlock_irqrestore(&priv->lock, flags);
> +                       ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
> +               } else {
> +                       deferred_pkt = defer_neigh_skb(skb, dev, neigh, phdr);
> +                       spin_unlock_irqrestore(&priv->lock, flags);
> +               }
> +
> +               goto unref;
>         } else if (neigh->ah && neigh->ah->valid) {
>                 neigh->ah->last_send = rn->send(dev, skb, neigh->ah->ah,
>                                                 IPOIB_QPN(phdr->hwaddr));
> @@ -1168,17 +1201,16 @@ static netdev_tx_t ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
>                 neigh_refresh_path(neigh, phdr->hwaddr, dev);
>         }
>
> -       if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
> -               push_pseudo_header(skb, phdr->hwaddr);
> -               spin_lock_irqsave(&priv->lock, flags);
> -               __skb_queue_tail(&neigh->queue, skb);
> -               spin_unlock_irqrestore(&priv->lock, flags);
> -       } else {
> +       spin_lock_irqsave(&priv->lock, flags);
> +       deferred_pkt = defer_neigh_skb(skb, dev, neigh, phdr);
> +       spin_unlock_irqrestore(&priv->lock, flags);
> +
> +unref:
> +       if (!deferred_pkt) {
>                 ++dev->stats.tx_dropped;
>                 dev_kfree_skb_any(skb);
>         }
>
> -unref:
>         ipoib_neigh_put(neigh);
>
>         return NETDEV_TX_OK;
> --
> 2.12.3
>
