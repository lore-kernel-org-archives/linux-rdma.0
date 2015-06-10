From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3] IB/ipoib: Scatter-Gather support in connected mode
Date: Wed, 10 Jun 2015 12:55:15 +0300
Message-ID: <CAAk-MO8bpMeKorrG9ZgV0ZmtEYNiQR7igPMTYoPwWMoawyRQOw@mail.gmail.com>
References: <1431338642-22812-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431338642-22812-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 11, 2015 at 1:04 PM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> By default, IPoIB-CM driver uses 64k MTU. Larger MTU gives better performance.
> This MTU plus overhead puts the memory allocation for IP based packets at 32
> 4k pages (order 5), which have to be contiguous.
> When the system memory under pressure, it was observed that allocating 128k
> contiguous physical memory is difficult and causes serious errors (such as
> system becomes unusable).
>
> This enhancement resolve the issue by removing the physically contiguous memory
> requirement using Scatter/Gather feature that exists in Linux stack.
>
> With this fix Scatter-Gather will be supported also in connected mode.
>
> This change reverts the some of the change made in commit
> e112373fd6aa280bd2cbc0d5cc3809115325a1be
> ("IPoIB/cm: Reduce connected mode TX object size)".
>
> The ability to use SG in IPoIB CM is possible because the coupling
> between NETIF_F_SG and NETIF_F_CSUM was removed in commit
> ec5f061564238892005257c83565a0b58ec79295
> ("net: Kill link between CSUM and SG features.")
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v2: Enhance commit log message
>
> I'd like to thank John Sobecki <john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> and
> Christian Marie <christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org> for helping me with reviewing this patch.
> I will be glad if you can ACK it.
>
> v3: Add an empty line to start a new paragraph and use 12 hex-digits identifier
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h      |    4 +-
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c   |  107 +++++++++++++++++++++++------
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c   |    3 +-
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 +-
>  4 files changed, 92 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
> index bd94b0a..372c8a2 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -239,7 +239,7 @@ struct ipoib_cm_tx {
>         struct net_device   *dev;
>         struct ipoib_neigh  *neigh;
>         struct ipoib_path   *path;
> -       struct ipoib_cm_tx_buf *tx_ring;
> +       struct ipoib_tx_buf *tx_ring;
>         unsigned             tx_head;
>         unsigned             tx_tail;
>         unsigned long        flags;
> @@ -504,6 +504,8 @@ int ipoib_mcast_stop_thread(struct net_device *dev);
>  void ipoib_mcast_dev_down(struct net_device *dev);
>  void ipoib_mcast_dev_flush(struct net_device *dev);
>
> +int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf *tx_req);
> +
>  #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
>  struct ipoib_mcast_iter *ipoib_mcast_iter_init(struct net_device *dev);
>  int ipoib_mcast_iter_next(struct ipoib_mcast_iter *iter);
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> index 56959ad..eae106e 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -88,6 +88,31 @@ static void ipoib_cm_dma_unmap_rx(struct ipoib_dev_priv *priv, int frags,
>                 ib_dma_unmap_page(priv->ca, mapping[i + 1], PAGE_SIZE, DMA_FROM_DEVICE);
>  }
>
> +static void ipoib_cm_dma_unmap_tx(struct ipoib_dev_priv *priv,
> +                                 struct ipoib_tx_buf *tx_req)
> +{
> +       struct sk_buff *skb;
> +       int i, offs;
> +
> +       skb = tx_req->skb;
> +       if (skb_shinfo(skb)->nr_frags) {
> +               offs = 0;
> +               if (skb_headlen(skb)) {
> +                       ib_dma_unmap_single(priv->ca, tx_req->mapping[0],
> +                                           skb_headlen(skb), DMA_TO_DEVICE);
> +                       offs = 1;
> +               }
> +               for (i = 0; i < skb_shinfo(skb)->nr_frags; ++i) {
> +                       const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
> +
> +                       ib_dma_unmap_page(priv->ca, tx_req->mapping[i + offs],
> +                                         skb_frag_size(frag), DMA_TO_DEVICE);
> +               }
> +       } else
> +               ib_dma_unmap_single(priv->ca, tx_req->mapping[0], skb->len,
> +                                   DMA_TO_DEVICE);
> +}
> +
>  static int ipoib_cm_post_receive_srq(struct net_device *dev, int id)
>  {
>         struct ipoib_dev_priv *priv = netdev_priv(dev);
> @@ -707,11 +732,39 @@ static inline int post_send(struct ipoib_dev_priv *priv,
>         return ib_post_send(tx->qp, &priv->tx_wr, &bad_wr);
>  }
>
> +static inline int post_send_sg(struct ipoib_dev_priv *priv,
> +                              struct ipoib_cm_tx *tx,
> +                              unsigned int wr_id,
> +                              struct sk_buff *skb,
> +                              u64 mapping[MAX_SKB_FRAGS + 1])
> +{
> +       struct ib_send_wr *bad_wr;
> +       int i, off;
> +       skb_frag_t *frags = skb_shinfo(skb)->frags;
> +       int nr_frags = skb_shinfo(skb)->nr_frags;
> +
> +       if (skb_headlen(skb)) {
> +               priv->tx_sge[0].addr = mapping[0];
> +               priv->tx_sge[0].length = skb_headlen(skb);
> +               off = 1;
> +       } else
> +               off = 0;
> +
> +       for (i = 0; i < nr_frags; ++i) {
> +               priv->tx_sge[i + off].addr = mapping[i + off];
> +               priv->tx_sge[i + off].length = frags[i].size;
> +       }
> +       priv->tx_wr.num_sge = nr_frags + off;
> +       priv->tx_wr.wr_id = wr_id | IPOIB_OP_CM;
> +
> +       return ib_post_send(tx->qp, &priv->tx_wr, &bad_wr);
> +}
> +
>  void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_tx *tx)
>  {
>         struct ipoib_dev_priv *priv = netdev_priv(dev);
> -       struct ipoib_cm_tx_buf *tx_req;
> -       u64 addr;
> +       struct ipoib_tx_buf *tx_req;
> +       u64 addr = 0;
>         int rc;
>
>         if (unlikely(skb->len > tx->mtu)) {
> @@ -735,24 +788,37 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
>          */
>         tx_req = &tx->tx_ring[tx->tx_head & (ipoib_sendq_size - 1)];
>         tx_req->skb = skb;
> -       addr = ib_dma_map_single(priv->ca, skb->data, skb->len, DMA_TO_DEVICE);
> -       if (unlikely(ib_dma_mapping_error(priv->ca, addr))) {
> -               ++dev->stats.tx_errors;
> -               dev_kfree_skb_any(skb);
> -               return;
> -       }
>
> -       tx_req->mapping = addr;
> +       if (skb_shinfo(skb)->nr_frags) {
> +               if (unlikely(ipoib_dma_map_tx(priv->ca, tx_req))) {
> +                       ++dev->stats.tx_errors;
> +                       dev_kfree_skb_any(skb);
> +                       return;
> +               }

I think you should call  skb_orphan(skb) and skb_dst_drop(skb) before
queuing the packet for sending.
(like it done in the else part below)

> +               rc = post_send_sg(priv, tx, tx->tx_head &
> +                                 (ipoib_sendq_size - 1),
> +                                 skb, tx_req->mapping);
> +       } else {
> +               addr = ib_dma_map_single(priv->ca, skb->data, skb->len,
> +                                        DMA_TO_DEVICE);
> +               if (unlikely(ib_dma_mapping_error(priv->ca, addr))) {
> +                       ++dev->stats.tx_errors;
> +                       dev_kfree_skb_any(skb);
> +                       return;
> +               }
> +
> +               tx_req->mapping[0] = addr;
>
> -       skb_orphan(skb);
> -       skb_dst_drop(skb);
> +               skb_orphan(skb);
> +               skb_dst_drop(skb);
>
> -       rc = post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
> -                      addr, skb->len);
> +               rc = post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
> +                              addr, skb->len);
> +       }
>         if (unlikely(rc)) {
>                 ipoib_warn(priv, "post_send failed, error %d\n", rc);
>                 ++dev->stats.tx_errors;
> -               ib_dma_unmap_single(priv->ca, addr, skb->len, DMA_TO_DEVICE);
> +               ipoib_cm_dma_unmap_tx(priv, tx_req);
>                 dev_kfree_skb_any(skb);
>         } else {
>                 dev->trans_start = jiffies;
> @@ -777,7 +843,7 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
>         struct ipoib_dev_priv *priv = netdev_priv(dev);
>         struct ipoib_cm_tx *tx = wc->qp->qp_context;
>         unsigned int wr_id = wc->wr_id & ~IPOIB_OP_CM;
> -       struct ipoib_cm_tx_buf *tx_req;
> +       struct ipoib_tx_buf *tx_req;
>         unsigned long flags;
>
>         ipoib_dbg_data(priv, "cm send completion: id %d, status: %d\n",
> @@ -791,7 +857,7 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
>
>         tx_req = &tx->tx_ring[wr_id];
>
> -       ib_dma_unmap_single(priv->ca, tx_req->mapping, tx_req->skb->len, DMA_TO_DEVICE);
> +       ipoib_cm_dma_unmap_tx(priv, tx_req);
>
>         /* FIXME: is this right? Shouldn't we only increment on success? */
>         ++dev->stats.tx_packets;
> @@ -1036,6 +1102,9 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
>
>         struct ib_qp *tx_qp;
>
> +       if (dev->features & NETIF_F_SG)
> +               attr.cap.max_send_sge = MAX_SKB_FRAGS + 1;
> +
>         tx_qp = ib_create_qp(priv->pd, &attr);
>         if (PTR_ERR(tx_qp) == -EINVAL) {
>                 ipoib_warn(priv, "can't use GFP_NOIO for QPs on device %s, using GFP_KERNEL\n",
> @@ -1170,7 +1239,7 @@ err_tx:
>  static void ipoib_cm_tx_destroy(struct ipoib_cm_tx *p)
>  {
>         struct ipoib_dev_priv *priv = netdev_priv(p->dev);
> -       struct ipoib_cm_tx_buf *tx_req;
> +       struct ipoib_tx_buf *tx_req;
>         unsigned long begin;
>
>         ipoib_dbg(priv, "Destroy active connection 0x%x head 0x%x tail 0x%x\n",
> @@ -1197,8 +1266,7 @@ timeout:
>
>         while ((int) p->tx_tail - (int) p->tx_head < 0) {
>                 tx_req = &p->tx_ring[p->tx_tail & (ipoib_sendq_size - 1)];
> -               ib_dma_unmap_single(priv->ca, tx_req->mapping, tx_req->skb->len,
> -                                   DMA_TO_DEVICE);
> +               ipoib_cm_dma_unmap_tx(priv, tx_req);
>                 dev_kfree_skb_any(tx_req->skb);
>                 ++p->tx_tail;
>                 netif_tx_lock_bh(p->dev);
> @@ -1455,7 +1523,6 @@ static void ipoib_cm_stale_task(struct work_struct *work)
>         spin_unlock_irq(&priv->lock);
>  }
>
> -
>  static ssize_t show_mode(struct device *d, struct device_attribute *attr,
>                          char *buf)
>  {
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 63b92cb..f886055 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -263,8 +263,7 @@ repost:
>                            "for buf %d\n", wr_id);
>  }
>
> -static int ipoib_dma_map_tx(struct ib_device *ca,
> -                           struct ipoib_tx_buf *tx_req)
> +int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf *tx_req)
>  {
>         struct sk_buff *skb = tx_req->skb;
>         u64 *mapping = tx_req->mapping;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 9e1b203..4ee2784 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -190,7 +190,7 @@ static netdev_features_t ipoib_fix_features(struct net_device *dev, netdev_featu
>         struct ipoib_dev_priv *priv = netdev_priv(dev);
>
>         if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
> -               features &= ~(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO);
> +               features &= ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
>
>         return features;
>  }
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
