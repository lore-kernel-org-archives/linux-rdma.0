From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib_ipoib: Scatter-Gather support in connected mode
Date: Sun, 22 Mar 2015 11:21:50 +0200
Message-ID: <20150322092149.GA5229@yuval-lab>
References: <1422357682-8934-1-git-send-email-yuval.shaia@oracle.com>
 <1422444987.3133.81.camel@opteya.com>
 <20150201070941.GA4778@yuval-lab>
 <20150315151616.GA3546@yuval-lab>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150315151616.GA3546@yuval-lab>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 15, 2015 at 05:16:16PM +0200, Yuval Shaia wrote:
> Hi,
> I didn't got any further comments on this one.
> Any idea why SG in CM is un-welcome?
By mistake I sent a private mail only.
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Your advice would be very appreciated.

Yuval
>=20
> I have one small fix to this patch but it is 99% ready.
>=20
> Yuval
>=20
> On Sun, Feb 01, 2015 at 09:09:42AM +0200, Yuval Shaia wrote:
> > On Wed, Jan 28, 2015 at 12:36:27PM +0100, Yann Droneaud wrote:
> > > Hi,
> > >=20
> > > Le mardi 27 janvier 2015 =E0 03:21 -0800, Yuval Shaia a =E9crit :
> > > > With this fix Scatter-Gather will be supported also in connecte=
d mode
> > > >=20
> > >=20
> > > Please explain the issue with current kernel and the advantage
> > > of the proposed fix in the commit message. Perhaps benchmarks
> > > against various HCAs would be welcome.
> > The benefits of using SG are well known.
> > I think the question should be the other way around - why not suppo=
rting SG in CM?
> >=20
> > I will add the following text to commit message:
> > By default, IPoIB-CM driver uses 64k MTU. Larger MTU gives better p=
erformance.
> > This MTU plus overhead puts the memory allocation for IP based pack=
ets at 32 4k pages (order 5), which have to be contiguous.
> > When the system memory under pressure, it was observed that allocat=
ing 128k contiguous physical memory is difficult and causes serious err=
ors (such as system becomes unusable).
> > This enhancement resolve the issue by removing the physically conti=
guous memory requirement using Scatter/Gather feature that exists in Li=
nux stack.
> > >=20
> > > > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > > ---
> > > >  drivers/infiniband/ulp/ipoib/ipoib.h      |    8 +--
> > > >  drivers/infiniband/ulp/ipoib/ipoib_cm.c   |  107 +++++++++++++=
++++++++++------
> > > >  drivers/infiniband/ulp/ipoib/ipoib_ib.c   |    3 +-
> > > >  drivers/infiniband/ulp/ipoib/ipoib_main.c |    3 +-
> > > >  4 files changed, 91 insertions(+), 30 deletions(-)
> > > >=20
> > > > diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/inf=
iniband/ulp/ipoib/ipoib.h
> > > > index d7562be..fb42834 100644
> > > > --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> > > > +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> > > > @@ -170,11 +170,6 @@ struct ipoib_tx_buf {
> > > >  	u64		mapping[MAX_SKB_FRAGS + 1];
> > > >  };
> > > > =20
> > > > -struct ipoib_cm_tx_buf {
> > > > -	struct sk_buff *skb;
> > > > -	u64		mapping;
> > > > -};
> > > > -
> > > >  struct ib_cm_id;
> > > > =20
> > > >  struct ipoib_cm_data {
> > > > @@ -233,7 +228,7 @@ struct ipoib_cm_tx {
> > > >  	struct net_device   *dev;
> > > >  	struct ipoib_neigh  *neigh;
> > > >  	struct ipoib_path   *path;
> > > > -	struct ipoib_cm_tx_buf *tx_ring;
> > > > +	struct ipoib_tx_buf *tx_ring;
> > > >  	unsigned	     tx_head;
> > > >  	unsigned	     tx_tail;
> > > >  	unsigned long	     flags;
> > > > @@ -496,6 +491,7 @@ int ipoib_mcast_stop_thread(struct net_devi=
ce *dev, int flush);
> > > > =20
> > > >  void ipoib_mcast_dev_down(struct net_device *dev);
> > > >  void ipoib_mcast_dev_flush(struct net_device *dev);
> > > > +int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf=
 *tx_req);
> > > > =20
> > > >  #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
> > > >  struct ipoib_mcast_iter *ipoib_mcast_iter_init(struct net_devi=
ce *dev);
> > > > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/=
infiniband/ulp/ipoib/ipoib_cm.c
> > > > index 933efce..056e4d2 100644
> > > > --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > > > +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > > > @@ -88,6 +88,31 @@ static void ipoib_cm_dma_unmap_rx(struct ipo=
ib_dev_priv *priv, int frags,
> > > >  		ib_dma_unmap_page(priv->ca, mapping[i + 1], PAGE_SIZE, DMA_F=
ROM_DEVICE);
> > > >  }
> > > > =20
> > > > +static void ipoib_cm_dma_unmap_tx(struct ipoib_dev_priv *priv,
> > > > +				  struct ipoib_tx_buf *tx_req)
> > > > +{
> > > > +	struct sk_buff *skb;
> > > > +	int i, offs;
> > > > +
> > > > +	skb =3D tx_req->skb;
> > > > +	if (skb_shinfo(skb)->nr_frags) {
> > > > +		offs =3D 0;
> > > > +		if (skb_headlen(skb)) {
> > > > +			ib_dma_unmap_single(priv->ca, tx_req->mapping[0],
> > > > +					    skb_headlen(skb), DMA_TO_DEVICE);
> > > > +			offs =3D 1;
> > > > +		}
> > > > +		for (i =3D 0; i < skb_shinfo(skb)->nr_frags; ++i) {
> > > > +			const skb_frag_t *frag =3D &skb_shinfo(skb)->frags[i];
> > > > +
> > > > +			ib_dma_unmap_single(priv->ca, tx_req->mapping[i + offs],
> > > > +					    skb_frag_size(frag), DMA_TO_DEVICE);
> > > > +		}
> > > > +	} else
> > > > +		ib_dma_unmap_single(priv->ca, tx_req->mapping[0], skb->len,
> > > > +				    DMA_TO_DEVICE);
> > > > +}
> > > > +
> > > >  static int ipoib_cm_post_receive_srq(struct net_device *dev, i=
nt id)
> > > >  {
> > > >  	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> > > > @@ -707,11 +732,39 @@ static inline int post_send(struct ipoib_=
dev_priv *priv,
> > > >  	return ib_post_send(tx->qp, &priv->tx_wr, &bad_wr);
> > > >  }
> > > > =20
> > > > +static inline int post_send_sg(struct ipoib_dev_priv *priv,
> > > > +			       struct ipoib_cm_tx *tx,
> > > > +			       unsigned int wr_id,
> > > > +			       struct sk_buff *skb,
> > > > +			       u64 mapping[MAX_SKB_FRAGS + 1])
> > > > +{
> > > > +	struct ib_send_wr *bad_wr;
> > > > +	int i, off;
> > > > +	skb_frag_t *frags =3D skb_shinfo(skb)->frags;
> > > > +	int nr_frags =3D skb_shinfo(skb)->nr_frags;
> > > > +
> > > > +	if (skb_headlen(skb)) {
> > > > +		priv->tx_sge[0].addr =3D mapping[0];
> > > > +		priv->tx_sge[0].length =3D skb_headlen(skb);
> > > > +		off =3D 1;
> > > > +	} else
> > > > +		off =3D 0;
> > > > +
> > > > +	for (i =3D 0; i < nr_frags; ++i) {
> > > > +		priv->tx_sge[i + off].addr =3D mapping[i + off];
> > > > +		priv->tx_sge[i + off].length =3D frags[i].size;
> > > > +	}
> > > > +	priv->tx_wr.num_sge =3D nr_frags + off;
> > > > +	priv->tx_wr.wr_id =3D wr_id | IPOIB_OP_CM;
> > > > +
> > > > +	return ib_post_send(tx->qp, &priv->tx_wr, &bad_wr);
> > > > +}
> > > > +
> > > >  void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb=
, struct ipoib_cm_tx *tx)
> > > >  {
> > > >  	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> > > > -	struct ipoib_cm_tx_buf *tx_req;
> > > > -	u64 addr;
> > > > +	struct ipoib_tx_buf *tx_req;
> > > > +	u64 addr =3D 0;
> > > >  	int rc;
> > > > =20
> > > >  	if (unlikely(skb->len > tx->mtu)) {
> > > > @@ -735,24 +788,37 @@ void ipoib_cm_send(struct net_device *dev=
, struct sk_buff *skb, struct ipoib_cm_
> > > >  	 */
> > > >  	tx_req =3D &tx->tx_ring[tx->tx_head & (ipoib_sendq_size - 1)]=
;
> > > >  	tx_req->skb =3D skb;
> > > > -	addr =3D ib_dma_map_single(priv->ca, skb->data, skb->len, DMA=
_TO_DEVICE);
> > > > -	if (unlikely(ib_dma_mapping_error(priv->ca, addr))) {
> > > > -		++dev->stats.tx_errors;
> > > > -		dev_kfree_skb_any(skb);
> > > > -		return;
> > > > -	}
> > > > =20
> > > > -	tx_req->mapping =3D addr;
> > > > +	if (skb_shinfo(skb)->nr_frags) {
> > > > +		if (unlikely(ipoib_dma_map_tx(priv->ca, tx_req))) {
> > > > +			++dev->stats.tx_errors;
> > > > +			dev_kfree_skb_any(skb);
> > > > +			return;
> > > > +		}
> > > > +		rc =3D post_send_sg(priv, tx, tx->tx_head &
> > > > +				  (ipoib_sendq_size - 1),
> > > > +				  skb, tx_req->mapping);
> > > > +	} else {
> > > > +		addr =3D ib_dma_map_single(priv->ca, skb->data, skb->len,
> > > > +					 DMA_TO_DEVICE);
> > > > +		if (unlikely(ib_dma_mapping_error(priv->ca, addr))) {
> > > > +			++dev->stats.tx_errors;
> > > > +			dev_kfree_skb_any(skb);
> > > > +			return;
> > > > +		}
> > > > +
> > > > +		tx_req->mapping[0] =3D addr;
> > > > =20
> > > > -	skb_orphan(skb);
> > > > -	skb_dst_drop(skb);
> > > > +		skb_orphan(skb);
> > > > +		skb_dst_drop(skb);
> > > > =20
> > > > -	rc =3D post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - =
1),
> > > > -		       addr, skb->len);
> > > > +		rc =3D post_send(priv, tx, tx->tx_head & (ipoib_sendq_size -=
 1),
> > > > +			       addr, skb->len);
> > > > +	}
> > > >  	if (unlikely(rc)) {
> > > >  		ipoib_warn(priv, "post_send failed, error %d\n", rc);
> > > >  		++dev->stats.tx_errors;
> > > > -		ib_dma_unmap_single(priv->ca, addr, skb->len, DMA_TO_DEVICE)=
;
> > > > +		ipoib_cm_dma_unmap_tx(priv, tx_req);
> > > >  		dev_kfree_skb_any(skb);
> > > >  	} else {
> > > >  		dev->trans_start =3D jiffies;
> > > > @@ -777,7 +843,7 @@ void ipoib_cm_handle_tx_wc(struct net_devic=
e *dev, struct ib_wc *wc)
> > > >  	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> > > >  	struct ipoib_cm_tx *tx =3D wc->qp->qp_context;
> > > >  	unsigned int wr_id =3D wc->wr_id & ~IPOIB_OP_CM;
> > > > -	struct ipoib_cm_tx_buf *tx_req;
> > > > +	struct ipoib_tx_buf *tx_req;
> > > >  	unsigned long flags;
> > > > =20
> > > >  	ipoib_dbg_data(priv, "cm send completion: id %d, status: %d\n=
",
> > > > @@ -791,7 +857,7 @@ void ipoib_cm_handle_tx_wc(struct net_devic=
e *dev, struct ib_wc *wc)
> > > > =20
> > > >  	tx_req =3D &tx->tx_ring[wr_id];
> > > > =20
> > > > -	ib_dma_unmap_single(priv->ca, tx_req->mapping, tx_req->skb->l=
en, DMA_TO_DEVICE);
> > > > +	ipoib_cm_dma_unmap_tx(priv, tx_req);
> > > > =20
> > > >  	/* FIXME: is this right? Shouldn't we only increment on succe=
ss? */
> > > >  	++dev->stats.tx_packets;
> > > > @@ -1036,6 +1102,9 @@ static struct ib_qp *ipoib_cm_create_tx_q=
p(struct net_device *dev, struct ipoib_
> > > > =20
> > > >  	struct ib_qp *tx_qp;
> > > > =20
> > > > +	if (dev->features & NETIF_F_SG)
> > > > +		attr.cap.max_send_sge =3D MAX_SKB_FRAGS + 1;
> > > > +
> > > >  	tx_qp =3D ib_create_qp(priv->pd, &attr);
> > > >  	if (PTR_ERR(tx_qp) =3D=3D -EINVAL) {
> > > >  		ipoib_warn(priv, "can't use GFP_NOIO for QPs on device %s, u=
sing GFP_KERNEL\n",
> > > > @@ -1170,7 +1239,7 @@ err_tx:
> > > >  static void ipoib_cm_tx_destroy(struct ipoib_cm_tx *p)
> > > >  {
> > > >  	struct ipoib_dev_priv *priv =3D netdev_priv(p->dev);
> > > > -	struct ipoib_cm_tx_buf *tx_req;
> > > > +	struct ipoib_tx_buf *tx_req;
> > > >  	unsigned long begin;
> > > > =20
> > > >  	ipoib_dbg(priv, "Destroy active connection 0x%x head 0x%x tai=
l 0x%x\n",
> > > > @@ -1197,8 +1266,7 @@ timeout:
> > > > =20
> > > >  	while ((int) p->tx_tail - (int) p->tx_head < 0) {
> > > >  		tx_req =3D &p->tx_ring[p->tx_tail & (ipoib_sendq_size - 1)];
> > > > -		ib_dma_unmap_single(priv->ca, tx_req->mapping, tx_req->skb->=
len,
> > > > -				    DMA_TO_DEVICE);
> > > > +		ipoib_cm_dma_unmap_tx(priv, tx_req);
> > > >  		dev_kfree_skb_any(tx_req->skb);
> > > >  		++p->tx_tail;
> > > >  		netif_tx_lock_bh(p->dev);
> > > > @@ -1455,7 +1523,6 @@ static void ipoib_cm_stale_task(struct wo=
rk_struct *work)
> > > >  	spin_unlock_irq(&priv->lock);
> > > >  }
> > > > =20
> > > > -
> > >=20
> > > No need to remove this line.
> > >=20
> > > >  static ssize_t show_mode(struct device *d, struct device_attri=
bute *attr,
> > > >  			 char *buf)
> > > >  {
> > > > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/=
infiniband/ulp/ipoib/ipoib_ib.c
> > > > index 72626c3..9e11447 100644
> > > > --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> > > > +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> > > > @@ -312,8 +312,7 @@ repost:
> > > >  			   "for buf %d\n", wr_id);
> > > >  }
> > > > =20
> > > > -static int ipoib_dma_map_tx(struct ib_device *ca,
> > > > -			    struct ipoib_tx_buf *tx_req)
> > > > +int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf=
 *tx_req)
> > > >  {
> > > >  	struct sk_buff *skb =3D tx_req->skb;
> > > >  	u64 *mapping =3D tx_req->mapping;
> > > > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/driver=
s/infiniband/ulp/ipoib/ipoib_main.c
> > > > index 58b5aa3..f9314c6 100644
> > > > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > @@ -190,7 +190,7 @@ static netdev_features_t ipoib_fix_features=
(struct net_device *dev, netdev_featu
> > > >  	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> > > > =20
> > > >  	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
> > > > -		features &=3D ~(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO);
> > > > +		features &=3D ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
> > > > =20
> > > >  	return features;
> > > >  }
> > > > @@ -233,7 +233,6 @@ int ipoib_set_mode(struct net_device *dev, =
const char *buf)
> > > >  			   "will cause multicast packet drops\n");
> > > >  		netdev_update_features(dev);
> > > >  		rtnl_unlock();
> > > > -		priv->tx_wr.send_flags &=3D ~IB_SEND_IP_CSUM;
> > >=20
> > > Sure about this removal ? I don't see it related to scatter-gathe=
r.
> > >=20
> > > > =20
> > > >  		ipoib_flush_paths(dev);
> > > >  		rtnl_lock();
> > >=20
> > > Regards.
> > >=20
> > > --=20
> > > Yann Droneaud
> > > OPTEYA
> > >=20
> > >=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
