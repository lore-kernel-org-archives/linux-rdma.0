From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib_ipoib: CSUM support in connected mode
Date: Thu, 9 Oct 2014 23:13:34 +0300
Message-ID: <20141009201333.GA2651@yuval-lab>
References: <1412423147-8402-1-git-send-email-yuval.shaia@oracle.com>
 <56F82BF9-AD6E-4402-95E7-C4C92B104BB3@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56F82BF9-AD6E-4402-95E7-C4C92B104BB3-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 08, 2014 at 02:34:07PM -0400, Chuck Lever wrote:
> Hi Yuval-
>=20
> On Oct 4, 2014, at 7:45 AM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrot=
e:
>=20
> > This enhancement suggest the usage of IB CRC instead of CSUM in IPo=
IB CM.
> > IPoIB Connected Mode driver uses RC (Reliable Connection) which gua=
rantees the
> > corruption free delivery of the packet.
>=20
> Some na=C3=AFve questions:
>=20
> Is this interoperable with other IPoIB implementations, such as Solar=
is?
Yes, part of the implementation deals with how driver interact with leg=
acy peer and this includes Solaris as well as legacy Linux.
>=20
> Are there implications for IPv6, where checksumming is not optional?
> Maybe I misunderstood what is being replaced.
This is not a removal of checksumming, just replacement with other (and=
 better) mechanism.
The good part is that no module will be affected by it as the driver wi=
ll fake checksumming to upper networking layer.
>=20
> What happens if IPoIB uses UD instead of RC?
You mean CM-UD?=20
>=20
> When IPoIB traffic is routed off the IB fabric, isn=E2=80=99t end-to-=
end checksumming
> lost because the router node has to fabricate an IP checksum that was=
n=E2=80=99t
> provided by the sender?
Yes, it is lost.
This feature should be disabled in such setups.
This feature can be used only in LAN.
>=20
>=20
>=20
> > InfiniBand uses 32b CRC which provides stronger data integrity prot=
ection
> > compare to 16b IP Checksum.
> > So, there is no added value that IP Checksum provides in the IB wor=
ld.
> > The proposal is to tell that network stack that IPoIB-CM supports I=
P Checksum
> > offload.
> > This enables Linux to save the time of checksum calculation of IPoI=
B CM packets.
> > Network sends the IP packet without adding the IP Checksum to the h=
eader.
> > On the receive side, IPoIB driver again tells the network stack tha=
t IP
> > Checksum is good for the incoming packets and network stack avoids =
the IP
> > Checksum calculations.
> > During connection establishment the driver determine if the other e=
nd supports
> > IB CRC as checksum.
> > This is done so driver will be able to calculate checksum before tr=
ansmiting
> > the packet in case the other end does not support this feature.
> > A support for fragmented skb is added to transmit path.
> >=20
> > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> > drivers/infiniband/ulp/ipoib/ipoib.h      |   25 ++++++
> > drivers/infiniband/ulp/ipoib/ipoib_cm.c   |  117 ++++++++++++++++++=
++++++----
> > drivers/infiniband/ulp/ipoib/ipoib_ib.c   |    3 +-
> > drivers/infiniband/ulp/ipoib/ipoib_main.c |   19 ++++-
> > 4 files changed, 143 insertions(+), 21 deletions(-)
> >=20
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infinib=
and/ulp/ipoib/ipoib.h
> > index 0ed9aed..6fedf83 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> > @@ -100,6 +100,7 @@ enum {
> > 	IPOIB_FLAG_AUTO_MODER     =3D 13, /*indicates moderation is runnin=
g*/
> > 	/*indicates if event handler was registered*/
> > 	IPOIB_FLAG_EVENTS_REGISTERED    =3D 14,
> > +	IPOIB_FLAG_CSUM		  =3D 15,
> >=20
> > 	IPOIB_MAX_BACKOFF_SECONDS =3D 16,
> >=20
> > @@ -192,9 +193,28 @@ struct ipoib_pmtu_update {
> >=20
> > struct ib_cm_id;
> >=20
> > +#define IPOIB_CM_PROTO_SIG		0x2211
> > +#define IPOIB_CM_PROTO_VER		(1UL << 12)
> > +
> > +static inline int ipoib_cm_check_proto_sig(u16 proto_sig)
> > +{
> > +	return proto_sig & IPOIB_CM_PROTO_SIG;
> > +};
> > +
> > +static inline int ipoib_cm_check_proto_ver(u16 caps)
> > +{
> > +	return caps & IPOIB_CM_PROTO_VER;
> > +};
> > +
> > +enum ipoib_cm_data_caps {
> > +	IPOIB_CM_CAPS_IBCRC_AS_CSUM	=3D 1UL << 0,
> > +};
> > +
> > struct ipoib_cm_data {
> > 	__be32 qpn; /* High byte MUST be ignored on receive */
> > 	__be32 mtu;
> > +	__be16 sig; /* must be IPOIB_CM_PROTO_SIG */
> > +	__be16 caps; /* 4 bits proto ver and 12 bits capabilities */
> > };
> >=20
> > /*
> > @@ -241,6 +261,7 @@ struct ipoib_cm_rx {
> > 	int			recv_count;
> > 	u32			qpn;
> > 	int index; /* For ring counters */
> > +	u16			caps;
> > };
> >=20
> > struct ipoib_cm_tx {
> > @@ -255,6 +276,7 @@ struct ipoib_cm_tx {
> > 	unsigned	     tx_tail;
> > 	unsigned long	     flags;
> > 	u32		     mtu;
> > +	u16		     caps;
> > };
> >=20
> > struct ipoib_cm_rx_buf {
> > @@ -558,6 +580,8 @@ void ipoib_del_neighs_by_gid(struct net_device =
*dev, u8 *gid);
> > extern struct workqueue_struct *ipoib_workqueue;
> > extern struct workqueue_struct *ipoib_auto_moder_workqueue;
> >=20
> > +extern int cm_ibcrc_as_csum;
> > +
> > /* functions */
> >=20
> > int ipoib_poll(struct napi_struct *napi, int budget);
> > @@ -613,6 +637,7 @@ int ipoib_mcast_stop_thread(struct net_device *=
dev, int flush);
> >=20
> > void ipoib_mcast_dev_down(struct net_device *dev);
> > void ipoib_mcast_dev_flush(struct net_device *dev);
> > +int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf *tx=
_req);
> >=20
> > #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
> > struct ipoib_mcast_iter *ipoib_mcast_iter_init(struct net_device *d=
ev);
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infi=
niband/ulp/ipoib/ipoib_cm.c
> > index db0303e..553569a 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > @@ -436,9 +436,16 @@ static int ipoib_cm_send_rep(struct net_device=
 *dev, struct ib_cm_id *cm_id,
> > 	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> > 	struct ipoib_cm_data data =3D {};
> > 	struct ib_cm_rep_param rep =3D {};
> > +	u16 caps =3D 0;
> > +
> > +	caps |=3D IPOIB_CM_PROTO_VER;
> > +	if (cm_ibcrc_as_csum)
> > +		caps |=3D IPOIB_CM_CAPS_IBCRC_AS_CSUM;
> >=20
> > 	data.qpn =3D cpu_to_be32(priv->qp->qp_num);
> > 	data.mtu =3D cpu_to_be32(IPOIB_CM_BUF_SIZE);
> > +	data.sig =3D cpu_to_be16(IPOIB_CM_PROTO_SIG);
> > +	data.caps =3D cpu_to_be16(caps);
> >=20
> > 	rep.private_data =3D &data;
> > 	rep.private_data_len =3D sizeof data;
> > @@ -458,6 +465,7 @@ static int ipoib_cm_req_handler(struct ib_cm_id=
 *cm_id, struct ib_cm_event *even
> > 	struct ipoib_cm_data *data =3D event->private_data;
> > 	unsigned psn;
> > 	int ret;
> > +	struct ipoib_cm_data *cm_data;
> >=20
> > 	ipoib_dbg(priv, "REQ arrived\n");
> > 	p =3D kzalloc(sizeof *p, GFP_KERNEL);
> > @@ -480,6 +488,13 @@ static int ipoib_cm_req_handler(struct ib_cm_i=
d *cm_id, struct ib_cm_event *even
> > 		goto err_qp;
> > 	}
> >=20
> > +	cm_data =3D (struct ipoib_cm_data *)event->private_data;
> > +	ipoib_dbg(priv, "Otherend sig=3D0x%x\n", be16_to_cpu(cm_data->sig=
));
> > +	if (ipoib_cm_check_proto_sig(be16_to_cpu(cm_data->sig)) &&
> > +	    ipoib_cm_check_proto_ver(be16_to_cpu(cm_data->caps)))
> > +		p->caps =3D be16_to_cpu(cm_data->caps);
> > +	ipoib_dbg(priv, "Otherend caps=3D0x%x\n", p->caps);
> > +
> > 	psn =3D random32() & 0xffffff;
> > 	ret =3D ipoib_cm_modify_rx_qp(dev, cm_id, p->qp, psn);
> > 	if (ret)
> > @@ -696,6 +711,9 @@ copied:
> >         if (skb->dev->priv_flags & IFF_EIPOIB_VIF)
> > 		set_skb_oob_cb_data(skb, wc, NULL);
> >=20
> > +	if (cm_ibcrc_as_csum)
> > +		skb->ip_summed =3D CHECKSUM_UNNECESSARY;
> > +
> > 	netif_receive_skb(skb);
> >=20
> > repost:
> > @@ -732,14 +750,43 @@ static inline int post_send(struct ipoib_dev_=
priv *priv,
> > 	return ib_post_send(tx->qp, &send_ring->tx_wr, &bad_wr);
> > }
> >=20
> > +static inline int post_send_sg(struct ipoib_dev_priv *priv,
> > +			       struct ipoib_cm_tx *tx,
> > +			       unsigned int wr_id,
> > +			       struct sk_buff *skb,
> > +			       u64 mapping[MAX_SKB_FRAGS + 1],
> > +			       struct ipoib_send_ring *send_ring)
> > +{
> > +	struct ib_send_wr *bad_wr;
> > +	int i, off;
> > +	skb_frag_t *frags =3D skb_shinfo(skb)->frags;
> > +	int nr_frags =3D skb_shinfo(skb)->nr_frags;
> > +	if (skb_headlen(skb)) {
> > +		send_ring->tx_sge[0].addr =3D mapping[0];
> > +		send_ring->tx_sge[0].length =3D skb_headlen(skb);
> > +		off =3D 1;
> > +	} else
> > +		off =3D 0;
> > +
> > +	for (i =3D 0; i < nr_frags; ++i) {
> > +		send_ring->tx_sge[i + off].addr =3D mapping[i + off];
> > +		send_ring->tx_sge[i + off].length =3D frags[i].size;
> > +	}
> > +	send_ring->tx_wr.num_sge =3D nr_frags + off;
> > +	send_ring->tx_wr.wr_id =3D wr_id | IPOIB_OP_CM;
> > +
> > +	return ib_post_send(tx->qp, &send_ring->tx_wr, &bad_wr);
> > +}
> > +
> > void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, str=
uct ipoib_cm_tx *tx)
> > {
> > 	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> > 	struct ipoib_cm_tx_buf *tx_req;
> > -	u64 addr;
> > +	u64 addr =3D 0;
> > 	int rc;
> > 	struct ipoib_send_ring *send_ring;
> > 	u16 queue_index;
> > +	struct ipoib_tx_buf sg_tx_req;
> >=20
> > 	queue_index =3D skb_get_queue_mapping(skb);
> > 	send_ring =3D priv->send_ring + queue_index;
> > @@ -768,26 +815,45 @@ void ipoib_cm_send(struct net_device *dev, st=
ruct sk_buff *skb, struct ipoib_cm_
> > 	tx_req =3D &tx->tx_ring[tx->tx_head & (ipoib_sendq_size - 1)];
> > 	tx_req->skb =3D skb;
> >=20
> > -	if (skb->len < ipoib_inline_thold && !skb_shinfo(skb)->nr_frags) =
{
> > -		addr =3D (u64) skb->data;
> > -		send_ring->tx_wr.send_flags |=3D IB_SEND_INLINE;
> > -		tx_req->is_inline =3D 1;
> > -	} else {
> > -		addr =3D ib_dma_map_single(priv->ca, skb->data,
> > -			skb->len, DMA_TO_DEVICE);
> > -		if (unlikely(ib_dma_mapping_error(priv->ca, addr))) {
> > -			++send_ring->stats.tx_errors;
> > +	/* Calculate checksum if we support ibcrc_as_csum but peer does n=
ot */
> > +	if ((skb->ip_summed !=3D CHECKSUM_NONE) && cm_ibcrc_as_csum &&
> > +	    !(tx->caps & IPOIB_CM_CAPS_IBCRC_AS_CSUM))
> > +		skb_checksum_help(skb);
> > +
> > +	if (skb_shinfo(skb)->nr_frags) {
> > +		sg_tx_req.skb =3D skb;
> > +		if (unlikely(ipoib_dma_map_tx(priv->ca, &sg_tx_req))) {
> > +			++dev->stats.tx_errors;
> > 			dev_kfree_skb_any(skb);
> > 			return;
> > 		}
> > -
> > -		tx_req->mapping =3D addr;
> > 		tx_req->is_inline =3D 0;
> > -		send_ring->tx_wr.send_flags &=3D ~IB_SEND_INLINE;
> > -	}
> > +		rc =3D post_send_sg(priv, tx, tx->tx_head &
> > +				  (ipoib_sendq_size - 1),
> > +				  skb, sg_tx_req.mapping, send_ring);
> > +	} else {
> > +		if (skb->len < ipoib_inline_thold &&
> > +		    !skb_shinfo(skb)->nr_frags) {
> > +			addr =3D (u64) skb->data;
> > +			send_ring->tx_wr.send_flags |=3D IB_SEND_INLINE;
> > +			tx_req->is_inline =3D 1;
> > +		} else {
> > +			addr =3D ib_dma_map_single(priv->ca, skb->data,
> > +				skb->len, DMA_TO_DEVICE);
> > +			if (unlikely(ib_dma_mapping_error(priv->ca, addr))) {
> > +				++send_ring->stats.tx_errors;
> > +				dev_kfree_skb_any(skb);
> > +				return;
> > +			}
> >=20
> > -	rc =3D post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
> > -		       addr, skb->len, send_ring);
> > +			tx_req->mapping =3D addr;
> > +			tx_req->is_inline =3D 0;
> > +			send_ring->tx_wr.send_flags &=3D ~IB_SEND_INLINE;
> > +		}
> > +
> > +		rc =3D post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
> > +			       addr, skb->len, send_ring);
> > +	}
> > 	if (unlikely(rc)) {
> > 		ipoib_warn(priv, "%s: post_send failed, error %d queue_index: %d =
skb->len: %d\n",
> > 			   __func__, rc, queue_index, skb->len);
> > @@ -1012,6 +1078,7 @@ static int ipoib_cm_rep_handler(struct ib_cm_=
id *cm_id, struct ib_cm_event *even
> > 	struct ib_qp_attr qp_attr;
> > 	int qp_attr_mask, ret;
> > 	struct sk_buff *skb;
> > +	struct ipoib_cm_data *cm_data;
> >=20
> > 	p->mtu =3D be32_to_cpu(data->mtu);
> >=20
> > @@ -1021,6 +1088,13 @@ static int ipoib_cm_rep_handler(struct ib_cm=
_id *cm_id, struct ib_cm_event *even
> > 		return -EINVAL;
> > 	}
> >=20
> > +	cm_data =3D (struct ipoib_cm_data *)event->private_data;
> > +	ipoib_dbg(priv, "Otherend sig=3D0x%x\n", be16_to_cpu(cm_data->sig=
));
> > +	if (ipoib_cm_check_proto_sig(be16_to_cpu(cm_data->sig)) &&
> > +	    ipoib_cm_check_proto_ver(be16_to_cpu(cm_data->caps)))
> > +		p->caps =3D be16_to_cpu(cm_data->caps);
> > +	ipoib_dbg(priv, "Otherend caps=3D0x%x\n", p->caps);
> > +
> > 	qp_attr.qp_state =3D IB_QPS_RTR;
> > 	ret =3D ib_cm_init_qp_attr(cm_id, &qp_attr, &qp_attr_mask);
> > 	if (ret) {
> > @@ -1105,6 +1179,9 @@ static struct ib_qp *ipoib_cm_create_tx_qp(st=
ruct net_device *dev, struct ipoib_
> >=20
> > 	spin_unlock_irqrestore(&priv->lock, flags);
> >=20
> > +	if (dev->features & NETIF_F_SG)
> > +		attr.cap.max_send_sge =3D MAX_SKB_FRAGS + 1;
> > +
> > 	return ib_create_qp(priv->pd, &attr);
> > }
> >=20
> > @@ -1116,9 +1193,16 @@ static int ipoib_cm_send_req(struct net_devi=
ce *dev,
> > 	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> > 	struct ipoib_cm_data data =3D {};
> > 	struct ib_cm_req_param req =3D {};
> > +	u16 caps =3D 0;
> > +
> > +	caps |=3D IPOIB_CM_PROTO_VER;
> > +	if (cm_ibcrc_as_csum)
> > +		caps |=3D IPOIB_CM_CAPS_IBCRC_AS_CSUM;
> >=20
> > 	data.qpn =3D cpu_to_be32(priv->qp->qp_num);
> > 	data.mtu =3D cpu_to_be32(IPOIB_CM_BUF_SIZE);
> > +	data.sig =3D cpu_to_be16(IPOIB_CM_PROTO_SIG);
> > +	data.caps =3D cpu_to_be16(caps);
> >=20
> > 	req.primary_path		=3D pathrec;
> > 	req.alternate_path		=3D NULL;
> > @@ -1594,7 +1678,6 @@ static void ipoib_cm_stale_task(struct work_s=
truct *work)
> > 	spin_unlock_irq(&priv->lock);
> > }
> >=20
> > -
> > static ssize_t show_mode(struct device *d, struct device_attribute =
*attr,
> > 			 char *buf)
> > {
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infi=
niband/ulp/ipoib/ipoib_ib.c
> > index 9e7d824..28f36dd 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> > @@ -349,8 +349,7 @@ repost:
> > 			   "for buf %d\n", wr_id);
> > }
> >=20
> > -static int ipoib_dma_map_tx(struct ib_device *ca,
> > -			    struct ipoib_tx_buf *tx_req)
> > +int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf *tx=
_req)
> > {
> > 	struct sk_buff *skb =3D tx_req->skb;
> > 	u64 *mapping =3D tx_req->mapping;
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/in=
finiband/ulp/ipoib/ipoib_main.c
> > index dcf18df..b17c7ab 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > @@ -69,6 +69,12 @@ module_param_named(debug_level, ipoib_debug_leve=
l, int, 0644);
> > MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0 (default=
: 0) (0-1)");
> > #endif
> >=20
> > +int cm_ibcrc_as_csum;
> > +
> > +module_param_named(cm_ibcrc_as_csum, cm_ibcrc_as_csum, int, 0444);
> > +MODULE_PARM_DESC(cm_ibcrc_as_csum, "Indicates whether to utilize I=
B-CRC as "
> > +		 "CSUM in connected mode,(default: 0)");
> > +
> > struct ipoib_path_iter {
> > 	struct net_device *dev;
> > 	struct ipoib_path  path;
> > @@ -195,7 +201,12 @@ static netdev_features_t ipoib_fix_features(st=
ruct net_device *dev, netdev_featu
> > 	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> >=20
> > 	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
> > -		features &=3D ~(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO);
> > +		if (cm_ibcrc_as_csum && (test_bit(IPOIB_FLAG_CSUM,
> > +						  &priv->flags)))
> > +			dev->features |=3D NETIF_F_IP_CSUM | NETIF_F_SG;
> > +		else
> > +			features &=3D ~(NETIF_F_SG | NETIF_F_IP_CSUM |
> > +				      NETIF_F_TSO);
> >=20
> > 	return features;
> > }
> > @@ -249,7 +260,11 @@ int ipoib_set_mode(struct net_device *dev, con=
st char *buf)
> >=20
> > 		send_ring =3D priv->send_ring;
> > 		for (i =3D 0; i < priv->num_tx_queues; i++) {
> > -			send_ring->tx_wr.send_flags &=3D ~IB_SEND_IP_CSUM;
> > +			if (cm_ibcrc_as_csum && (test_bit(IPOIB_FLAG_CSUM,
> > +							  &priv->flags)))
> > +				send_ring->tx_wr.send_flags |=3D IB_SEND_IP_CSUM;
> > +			else
> > +				send_ring->tx_wr.send_flags &=3D ~IB_SEND_IP_CSUM;
> > 			send_ring++;
> > 		}
> >=20
> > --=20
> > 1.7.1
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> Chuck Lever
> chuck[dot]lever[at]oracle[dot]com
>=20
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
