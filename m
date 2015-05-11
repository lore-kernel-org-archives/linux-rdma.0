From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/ipoib: Scatter-Gather support in connected mode
Date: Mon, 11 May 2015 11:15:54 +0200
Message-ID: <1431335754.25060.26.camel@opteya.com>
References: <1431244297-16371-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431244297-16371-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le dimanche 10 mai 2015 =C3=A0 00:51 -0700, Yuval Shaia a =C3=A9crit :
> By default, IPoIB-CM driver uses 64k MTU. Larger MTU gives better per=
formance.
> This MTU plus overhead puts the memory allocation for IP based packet=
s at 32
> 4k pages (order 5), which have to be contiguous.
> When the system memory under pressure, it was observed that allocatin=
g 128k
> contiguous physical memory is difficult and causes serious errors (su=
ch as
> system becomes unusable).

Please add an empty line to start a new paragraph.

> This enhancement resolve the issue by removing the physically contigu=
ous memory
> requirement using Scatter/Gather feature that exists in Linux stack.
>=20
> With this fix Scatter-Gather will be supported also in connected mode=
=2E
>=20
> This change reverts the some of the change made in commit e112373

use 12 hex-digits identifier: git config [--global] core.abbrev 12

See https://lkml.org/lkml/2010/10/28/287

> ("IPoIB/cm: Reduce connected mode TX object size)".
>=20
> The ability to use SG in IPoIB CM is possible because the coupling
> between NETIF_F_SG and NETIF_F_CSUM was removed in commit ec5f061

likewise.

> ("net: Kill link between CSUM and SG features.")
>=20

Commit message is way better than the initial one[1], thanks a lot for
all the explanation.

[1]
http://marc.info/?i=3D1422357682-8934-1-git-send-email-yuval.shaia@orac=
le.com
http://mid.gmane.org/1422357682-8934-1-git-send-email-yuval.shaia@oracl=
e.com


> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v2: Enhance commit log message
>=20
> I'd like to thank John Sobecki <john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> and=20
> Christian Marie <christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org> for helping me with reviewing t=
his patch.
> I will be glad if you can ACK it.
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h      |    4 +-
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c   |  107 +++++++++++++++++++=
++++------
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c   |    3 +-
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 +-
>  4 files changed, 92 insertions(+), 24 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniban=
d/ulp/ipoib/ipoib.h
> index bd94b0a..372c8a2 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -239,7 +239,7 @@ struct ipoib_cm_tx {
>  	struct net_device   *dev;
>  	struct ipoib_neigh  *neigh;
>  	struct ipoib_path   *path;
> -	struct ipoib_cm_tx_buf *tx_ring;
> +	struct ipoib_tx_buf *tx_ring;
>  	unsigned	     tx_head;
>  	unsigned	     tx_tail;
>  	unsigned long	     flags;
> @@ -504,6 +504,8 @@ int ipoib_mcast_stop_thread(struct net_device *de=
v);
>  void ipoib_mcast_dev_down(struct net_device *dev);
>  void ipoib_mcast_dev_flush(struct net_device *dev);
> =20
> +int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf *tx_r=
eq);
> +
>  #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
>  struct ipoib_mcast_iter *ipoib_mcast_iter_init(struct net_device *de=
v);
>  int ipoib_mcast_iter_next(struct ipoib_mcast_iter *iter);
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infini=
band/ulp/ipoib/ipoib_cm.c
> index 56959ad..eae106e 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -88,6 +88,31 @@ static void ipoib_cm_dma_unmap_rx(struct ipoib_dev=
_priv *priv, int frags,
>  		ib_dma_unmap_page(priv->ca, mapping[i + 1], PAGE_SIZE, DMA_FROM_DE=
VICE);
>  }
> =20
> +static void ipoib_cm_dma_unmap_tx(struct ipoib_dev_priv *priv,
> +				  struct ipoib_tx_buf *tx_req)
> +{
> +	struct sk_buff *skb;
> +	int i, offs;
> +
> +	skb =3D tx_req->skb;
> +	if (skb_shinfo(skb)->nr_frags) {
> +		offs =3D 0;
> +		if (skb_headlen(skb)) {
> +			ib_dma_unmap_single(priv->ca, tx_req->mapping[0],
> +					    skb_headlen(skb), DMA_TO_DEVICE);
> +			offs =3D 1;

I would have use a pointer instead of an index:

                         mapping =3D &tx_req->mapping[1];

> +		}
                 else
                         mapping =3D &tx_req->mapping[0];

> +		for (i =3D 0; i < skb_shinfo(skb)->nr_frags; ++i) {
                                                               , mappin=
g ++

> +			const skb_frag_t *frag =3D &skb_shinfo(skb)->frags[i];
> +
> +			ib_dma_unmap_page(priv->ca, tx_req->mapping[i + offs],

                                                             mapping

> +					  skb_frag_size(frag), DMA_TO_DEVICE);
> +		}
> +	} else
> +		ib_dma_unmap_single(priv->ca, tx_req->mapping[0], skb->len,
> +				    DMA_TO_DEVICE);

See below, I think scatter/gather can be the default to keep a single
code path.

> +}
> +
>  static int ipoib_cm_post_receive_srq(struct net_device *dev, int id)
>  {
>  	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> @@ -707,11 +732,39 @@ static inline int post_send(struct ipoib_dev_pr=
iv *priv,
>  	return ib_post_send(tx->qp, &priv->tx_wr, &bad_wr);
>  }
> =20
> +static inline int post_send_sg(struct ipoib_dev_priv *priv,
> +			       struct ipoib_cm_tx *tx,
> +			       unsigned int wr_id,
> +			       struct sk_buff *skb,
> +			       u64 mapping[MAX_SKB_FRAGS + 1])
> +{
> +	struct ib_send_wr *bad_wr;
> +	int i, off;
> +	skb_frag_t *frags =3D skb_shinfo(skb)->frags;
> +	int nr_frags =3D skb_shinfo(skb)->nr_frags;
> +
> +	if (skb_headlen(skb)) {
> +		priv->tx_sge[0].addr =3D mapping[0];
> +		priv->tx_sge[0].length =3D skb_headlen(skb);
> +		off =3D 1;

Same here, I would prefer a pointer instead of using offset.

                 sge =3D &tx_sge[1];
                 mapping++;

> +	} else
> +		off =3D 0;
                 sge =3D &tx_sge[0];

> +
> +	for (i =3D 0; i < nr_frags; ++i) {
> +		priv->tx_sge[i + off].addr =3D mapping[i + off];
> +		priv->tx_sge[i + off].length =3D frags[i].size;

                 sge->addr =3D *mapping;
                 sge->length =3D *frags;

                 mapping ++;
                 frags ++;
                 sge ++;

> +	}
> +	priv->tx_wr.num_sge =3D nr_frags + off;
> +	priv->tx_wr.wr_id =3D wr_id | IPOIB_OP_CM;
> +
> +	return ib_post_send(tx->qp, &priv->tx_wr, &bad_wr);
> +}
> +
>  void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, stru=
ct ipoib_cm_tx *tx)
>  {
>  	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> -	struct ipoib_cm_tx_buf *tx_req;
> -	u64 addr;
> +	struct ipoib_tx_buf *tx_req;
> +	u64 addr =3D 0;
>  	int rc;
> =20
>  	if (unlikely(skb->len > tx->mtu)) {
> @@ -735,24 +788,37 @@ void ipoib_cm_send(struct net_device *dev, stru=
ct sk_buff *skb, struct ipoib_cm_
>  	 */
>  	tx_req =3D &tx->tx_ring[tx->tx_head & (ipoib_sendq_size - 1)];
>  	tx_req->skb =3D skb;
> -	addr =3D ib_dma_map_single(priv->ca, skb->data, skb->len, DMA_TO_DE=
VICE);
> -	if (unlikely(ib_dma_mapping_error(priv->ca, addr))) {
> -		++dev->stats.tx_errors;
> -		dev_kfree_skb_any(skb);
> -		return;
> -	}
> =20
> -	tx_req->mapping =3D addr;
> +	if (skb_shinfo(skb)->nr_frags) {
> +		if (unlikely(ipoib_dma_map_tx(priv->ca, tx_req))) {
> +			++dev->stats.tx_errors;
> +			dev_kfree_skb_any(skb);
> +			return;
> +		}
> +		rc =3D post_send_sg(priv, tx, tx->tx_head &
> +				  (ipoib_sendq_size - 1),
> +				  skb, tx_req->mapping);
> +	} else {
> +		addr =3D ib_dma_map_single(priv->ca, skb->data, skb->len,
> +					 DMA_TO_DEVICE);

Is there any advantage to keep a separate path to handle single
fragment ? If not, I believe it would be better (simpler) to use
post_send_sg() in all case as it would remove code here and in=20
ipoib_cm_dma_unmap_tx().

> +		if (unlikely(ib_dma_mapping_error(priv->ca, addr))) {
> +			++dev->stats.tx_errors;
> +			dev_kfree_skb_any(skb);
> +			return;
> +		}
> +
> +		tx_req->mapping[0] =3D addr;
> =20
> -	skb_orphan(skb);
> -	skb_dst_drop(skb);
> +		skb_orphan(skb);
> +		skb_dst_drop(skb);
> =20
> -	rc =3D post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
> -		       addr, skb->len);
> +		rc =3D post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
> +			       addr, skb->len);
> +	}
>  	if (unlikely(rc)) {
>  		ipoib_warn(priv, "post_send failed, error %d\n", rc);
>  		++dev->stats.tx_errors;
> -		ib_dma_unmap_single(priv->ca, addr, skb->len, DMA_TO_DEVICE);
> +		ipoib_cm_dma_unmap_tx(priv, tx_req);
>  		dev_kfree_skb_any(skb);
>  	} else {
>  		dev->trans_start =3D jiffies;
> @@ -777,7 +843,7 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev=
, struct ib_wc *wc)
>  	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
>  	struct ipoib_cm_tx *tx =3D wc->qp->qp_context;
>  	unsigned int wr_id =3D wc->wr_id & ~IPOIB_OP_CM;
> -	struct ipoib_cm_tx_buf *tx_req;
> +	struct ipoib_tx_buf *tx_req;
>  	unsigned long flags;
> =20
>  	ipoib_dbg_data(priv, "cm send completion: id %d, status: %d\n",
> @@ -791,7 +857,7 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev=
, struct ib_wc *wc)
> =20
>  	tx_req =3D &tx->tx_ring[wr_id];
> =20
> -	ib_dma_unmap_single(priv->ca, tx_req->mapping, tx_req->skb->len, DM=
A_TO_DEVICE);
> +	ipoib_cm_dma_unmap_tx(priv, tx_req);
> =20
>  	/* FIXME: is this right? Shouldn't we only increment on success? */
>  	++dev->stats.tx_packets;
> @@ -1036,6 +1102,9 @@ static struct ib_qp *ipoib_cm_create_tx_qp(stru=
ct net_device *dev, struct ipoib_
> =20
>  	struct ib_qp *tx_qp;
> =20
> +	if (dev->features & NETIF_F_SG)
> +		attr.cap.max_send_sge =3D MAX_SKB_FRAGS + 1;
> +
>  	tx_qp =3D ib_create_qp(priv->pd, &attr);
>  	if (PTR_ERR(tx_qp) =3D=3D -EINVAL) {
>  		ipoib_warn(priv, "can't use GFP_NOIO for QPs on device %s, using G=
=46P_KERNEL\n",
> @@ -1170,7 +1239,7 @@ err_tx:
>  static void ipoib_cm_tx_destroy(struct ipoib_cm_tx *p)
>  {
>  	struct ipoib_dev_priv *priv =3D netdev_priv(p->dev);
> -	struct ipoib_cm_tx_buf *tx_req;
> +	struct ipoib_tx_buf *tx_req;
>  	unsigned long begin;
> =20
>  	ipoib_dbg(priv, "Destroy active connection 0x%x head 0x%x tail 0x%x=
\n",
> @@ -1197,8 +1266,7 @@ timeout:
> =20
>  	while ((int) p->tx_tail - (int) p->tx_head < 0) {
>  		tx_req =3D &p->tx_ring[p->tx_tail & (ipoib_sendq_size - 1)];
> -		ib_dma_unmap_single(priv->ca, tx_req->mapping, tx_req->skb->len,
> -				    DMA_TO_DEVICE);
> +		ipoib_cm_dma_unmap_tx(priv, tx_req);
>  		dev_kfree_skb_any(tx_req->skb);
>  		++p->tx_tail;
>  		netif_tx_lock_bh(p->dev);
> @@ -1455,7 +1523,6 @@ static void ipoib_cm_stale_task(struct work_str=
uct *work)
>  	spin_unlock_irq(&priv->lock);
>  }
> =20
> -

useless white space change !

>  static ssize_t show_mode(struct device *d, struct device_attribute *=
attr,
>  			 char *buf)
>  {
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infini=
band/ulp/ipoib/ipoib_ib.c
> index 63b92cb..f886055 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -263,8 +263,7 @@ repost:
>  			   "for buf %d\n", wr_id);
>  }
> =20
> -static int ipoib_dma_map_tx(struct ib_device *ca,
> -			    struct ipoib_tx_buf *tx_req)
> +int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf *tx_r=
eq)
>  {
>  	struct sk_buff *skb =3D tx_req->skb;
>  	u64 *mapping =3D tx_req->mapping;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infi=
niband/ulp/ipoib/ipoib_main.c
> index 9e1b203..4ee2784 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -190,7 +190,7 @@ static netdev_features_t ipoib_fix_features(struc=
t net_device *dev, netdev_featu
>  	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> =20
>  	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
> -		features &=3D ~(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO);
> +		features &=3D ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
> =20
>  	return features;
>  }

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
