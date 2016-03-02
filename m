From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/ipoib: Add handling for sending of skb with many
 frags
Date: Wed, 2 Mar 2016 19:03:36 +0200
Message-ID: <20160302170334.GA32200@yuval-lap.uk.oracle.com>
References: <1455784674-8412-1-git-send-email-hans.westgaard.ry@oracle.com>
 <1456922668-24956-1-git-send-email-hans.westgaard.ry@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456922668-24956-1-git-send-email-hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Haakon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Wei Lin Guay <wei.lin.guay-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On Wed, Mar 02, 2016 at 01:44:28PM +0100, Hans Westgaard Ry wrote:
> IPoIB converts skb-fragments to sge adding 1 extra sge when SG is ena=
bled.
> Current codepath assumes that the max number of sge a device support
> is at least MAX_SKB_FRAGS+1, there is no interaction with upper layer=
s
> to limit number of fragments in an skb if a device suports fewer
> sges. The assumptions also lead to requesting a fixed number of sge
> when IPoIB creates queue-pairs with SG enabled.
>=20
> A fallback/slowpath is implemented using skb_linearize to
> handle cases where the conversion would result in more sges than supp=
orted.
>=20
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: H=E5kon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Wei Lin Guay <wei.lin.guay-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h       |  2 ++
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c    | 23 ++++++++++++++++++++=
+--
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c    | 18 ++++++++++++++++++
>  drivers/infiniband/ulp/ipoib/ipoib_verbs.c |  5 ++++-
>  4 files changed, 45 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniban=
d/ulp/ipoib/ipoib.h
> index a6f3eab..85be0de 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -244,6 +244,7 @@ struct ipoib_cm_tx {
>  	unsigned	     tx_tail;
>  	unsigned long	     flags;
>  	u32		     mtu;
> +	unsigned             max_send_sge;
>  };
> =20
>  struct ipoib_cm_rx_buf {
> @@ -390,6 +391,7 @@ struct ipoib_dev_priv {
>  	int	hca_caps;
>  	struct ipoib_ethtool_st ethtool;
>  	struct timer_list poll_timer;
> +	unsigned max_send_sge;
>  };
> =20
>  struct ipoib_ah {
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infini=
band/ulp/ipoib/ipoib_cm.c
> index 917e46e..c8ed535 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -710,6 +710,7 @@ void ipoib_cm_send(struct net_device *dev, struct=
 sk_buff *skb, struct ipoib_cm_
>  	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
>  	struct ipoib_tx_buf *tx_req;
>  	int rc;
> +	unsigned usable_sge =3D tx->max_send_sge - !!skb_headlen(skb);
> =20
>  	if (unlikely(skb->len > tx->mtu)) {
>  		ipoib_warn(priv, "packet len %d (> %d) too long to send, dropping\=
n",
> @@ -719,7 +720,23 @@ void ipoib_cm_send(struct net_device *dev, struc=
t sk_buff *skb, struct ipoib_cm_
>  		ipoib_cm_skb_too_long(dev, skb, tx->mtu - IPOIB_ENCAP_LEN);
>  		return;
>  	}
> -
> +	if (skb_shinfo(skb)->nr_frags > usable_sge) {
> +		if (skb_linearize(skb) < 0) {
> +			ipoib_warn(priv, "skb could not be linearized\n");
> +			++dev->stats.tx_dropped;
> +			++dev->stats.tx_errors;
> +			dev_kfree_skb_any(skb);
> +			return;
> +		}
> +		/* Does skb_linearize return ok without reducing nr_frags? */
Per our offline chat, i think that it might that nr_frags will still be=
 > 0
> +		if (skb_shinfo(skb)->nr_frags > usable_sge) {
> +			ipoib_warn(priv, "too many frags after skb linearize\n");
> +			++dev->stats.tx_dropped;
> +			++dev->stats.tx_errors;
> +			dev_kfree_skb_any(skb);
> +			return;
> +		}
> +	}
>  	ipoib_dbg_data(priv, "sending packet: head 0x%x length %d connectio=
n 0x%x\n",
>  		       tx->tx_head, skb->len, tx->qp->qp_num);
> =20
> @@ -1031,7 +1048,8 @@ static struct ib_qp *ipoib_cm_create_tx_qp(stru=
ct net_device *dev, struct ipoib_
>  	struct ib_qp *tx_qp;
> =20
>  	if (dev->features & NETIF_F_SG)
> -		attr.cap.max_send_sge =3D MAX_SKB_FRAGS + 1;
> +		attr.cap.max_send_sge =3D
> +			min_t(u32, priv->ca->attrs.max_sge, MAX_SKB_FRAGS + 1);
> =20
>  	tx_qp =3D ib_create_qp(priv->pd, &attr);
>  	if (PTR_ERR(tx_qp) =3D=3D -EINVAL) {
> @@ -1040,6 +1058,7 @@ static struct ib_qp *ipoib_cm_create_tx_qp(stru=
ct net_device *dev, struct ipoib_
>  		attr.create_flags &=3D ~IB_QP_CREATE_USE_GFP_NOIO;
>  		tx_qp =3D ib_create_qp(priv->pd, &attr);
>  	}
> +	tx->max_send_sge =3D attr.cap.max_send_sge;
>  	return tx_qp;
>  }
> =20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infini=
band/ulp/ipoib/ipoib_ib.c
> index 5ea0c14..ee7a555 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -540,6 +540,7 @@ void ipoib_send(struct net_device *dev, struct sk=
_buff *skb,
>  	struct ipoib_tx_buf *tx_req;
>  	int hlen, rc;
>  	void *phead;
> +	unsigned usable_sge =3D priv->max_send_sge - !!skb_headlen(skb);
> =20
>  	if (skb_is_gso(skb)) {
>  		hlen =3D skb_transport_offset(skb) + tcp_hdrlen(skb);
> @@ -563,6 +564,23 @@ void ipoib_send(struct net_device *dev, struct s=
k_buff *skb,
>  		phead =3D NULL;
>  		hlen  =3D 0;
>  	}
> +	if (skb_shinfo(skb)->nr_frags > usable_sge) {
> +		if (skb_linearize(skb) < 0) {
> +			ipoib_warn(priv, "skb could not be linearized\n");
> +			++dev->stats.tx_dropped;
> +			++dev->stats.tx_errors;
> +			dev_kfree_skb_any(skb);
> +			return;
> +		}
> +		/* Does skb_linearize return ok without reducing nr_frags? */
> +		if (skb_shinfo(skb)->nr_frags > usable_sge) {
> +			ipoib_warn(priv, "too many frags after skb linearize\n");
> +			++dev->stats.tx_dropped;
> +			++dev->stats.tx_errors;
> +			dev_kfree_skb_any(skb);
> +			return;
> +		}
> +	}
> =20
>  	ipoib_dbg_data(priv, "sending packet, length=3D%d address=3D%p qpn=3D=
0x%06x\n",
>  		       skb->len, address, qpn);
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/inf=
iniband/ulp/ipoib/ipoib_verbs.c
> index d48c5ba..b809c37 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> @@ -206,7 +206,8 @@ int ipoib_transport_dev_init(struct net_device *d=
ev, struct ib_device *ca)
>  		init_attr.create_flags |=3D IB_QP_CREATE_NETIF_QP;
> =20
>  	if (dev->features & NETIF_F_SG)
> -		init_attr.cap.max_send_sge =3D MAX_SKB_FRAGS + 1;
> +		init_attr.cap.max_send_sge =3D
> +			min_t(u32, priv->ca->attrs.max_sge, MAX_SKB_FRAGS + 1);
> =20
>  	priv->qp =3D ib_create_qp(priv->pd, &init_attr);
>  	if (IS_ERR(priv->qp)) {
> @@ -233,6 +234,8 @@ int ipoib_transport_dev_init(struct net_device *d=
ev, struct ib_device *ca)
>  	priv->rx_wr.next =3D NULL;
>  	priv->rx_wr.sg_list =3D priv->rx_sge;
> =20
> +	priv->max_send_sge =3D init_attr.cap.max_send_sge;
> +
>  	return 0;
> =20
>  out_free_send_cq:
> --=20
> 2.4.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
