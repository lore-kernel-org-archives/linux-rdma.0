From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] IB/ipoib: Scatter-Gather support in connected mode
Date: Tue, 7 Jul 2015 13:59:30 -0400
Message-ID: <BDB20E3A-9A11-4A2E-B926-584B09F31B59@redhat.com>
References: <1434363017-22612-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: multipart/signed; boundary="Apple-Mail=_12780F94-87E3-4073-B896-1A9C74843C77"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434363017-22612-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_12780F94-87E3-4073-B896-1A9C74843C77
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Jun 15, 2015, at 6:10 AM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> =
wrote:
>=20
> By default, IPoIB-CM driver uses 64k MTU. Larger MTU gives better
> performance.
> This MTU plus overhead puts the memory allocation for IP based packets =
at
> 32 4k pages (order 5), which have to be contiguous.
> When the system memory under pressure, it was observed that allocating =
128k
> contiguous physical memory is difficult and causes serious errors =
(such as
> system becomes unusable).
>=20
> This enhancement resolve the issue by removing the physically =
contiguous
> memory requirement using Scatter/Gather feature that exists in Linux =
stack.
>=20
> With this fix Scatter-Gather will be supported also in connected mode.
>=20
> This change reverts some of the change made in commit e112373fd6aa
> ("IPoIB/cm: Reduce connected mode TX object size)".
>=20
> The ability to use SG in IPoIB CM is possible because the coupling
> between NETIF_F_SG and NETIF_F_CSUM was removed in commit
> ec5f06156423 ("net: Kill link between CSUM and SG features.")
>=20
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Acked-by: Christian Marie <christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org>
> ---
> v4:
> * Use 12 hex-digits commit identifier
> * Add Acked-by: Christian Marie <christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org>
> * Merge ipoib_cm_dma_unmap_tx and ipoib_dma_unmap_tx
> * Take out common code from ud's post_send and cm's post_send
> v3:
> * Add an empty line to start a new paragraph
> v2:
> * Enhance commit log message
> =E2=80=94

This showed up on list just as I was leaving for PTO.  Normally, I would =
not like to take a patch this large in an RC, but I was waiting on this =
and we *just* tagged rc1, so I=E2=80=99m going to take it for 4.2.

> drivers/infiniband/ulp/ipoib/ipoib.h      |    8 +++++-
> drivers/infiniband/ulp/ipoib/ipoib_cm.c   |   33 =
++++++++++-------------
> drivers/infiniband/ulp/ipoib/ipoib_ib.c   |   41 =
+++++++++++++++++-----------
> drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 +-
> 4 files changed, 47 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h =
b/drivers/infiniband/ulp/ipoib/ipoib.h
> index bd94b0a..2c0f79f 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -239,7 +239,7 @@ struct ipoib_cm_tx {
> 	struct net_device   *dev;
> 	struct ipoib_neigh  *neigh;
> 	struct ipoib_path   *path;
> -	struct ipoib_cm_tx_buf *tx_ring;
> +	struct ipoib_tx_buf *tx_ring;
> 	unsigned	     tx_head;
> 	unsigned	     tx_tail;
> 	unsigned long	     flags;
> @@ -504,6 +504,12 @@ int ipoib_mcast_stop_thread(struct net_device =
*dev);
> void ipoib_mcast_dev_down(struct net_device *dev);
> void ipoib_mcast_dev_flush(struct net_device *dev);
>=20
> +int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf =
*tx_req);
> +void ipoib_dma_unmap_tx(struct ipoib_dev_priv *priv,
> +			struct ipoib_tx_buf *tx_req);
> +inline void ipoib_build_sge(struct ipoib_dev_priv *priv,
> +			    struct ipoib_tx_buf *tx_req);
> +
> #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
> struct ipoib_mcast_iter *ipoib_mcast_iter_init(struct net_device =
*dev);
> int ipoib_mcast_iter_next(struct ipoib_mcast_iter *iter);
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c =
b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> index cf32a77..ee39be6 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -694,14 +694,12 @@ repost:
> static inline int post_send(struct ipoib_dev_priv *priv,
> 			    struct ipoib_cm_tx *tx,
> 			    unsigned int wr_id,
> -			    u64 addr, int len)
> +			    struct ipoib_tx_buf *tx_req)
> {
> 	struct ib_send_wr *bad_wr;
>=20
> -	priv->tx_sge[0].addr          =3D addr;
> -	priv->tx_sge[0].length        =3D len;
> +	ipoib_build_sge(priv, tx_req);
>=20
> -	priv->tx_wr.num_sge	=3D 1;
> 	priv->tx_wr.wr_id	=3D wr_id | IPOIB_OP_CM;
>=20
> 	return ib_post_send(tx->qp, &priv->tx_wr, &bad_wr);
> @@ -710,8 +708,7 @@ static inline int post_send(struct ipoib_dev_priv =
*priv,
> void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct =
ipoib_cm_tx *tx)
> {
> 	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> -	struct ipoib_cm_tx_buf *tx_req;
> -	u64 addr;
> +	struct ipoib_tx_buf *tx_req;
> 	int rc;
>=20
> 	if (unlikely(skb->len > tx->mtu)) {
> @@ -735,24 +732,21 @@ void ipoib_cm_send(struct net_device *dev, =
struct sk_buff *skb, struct ipoib_cm_
> 	 */
> 	tx_req =3D &tx->tx_ring[tx->tx_head & (ipoib_sendq_size - 1)];
> 	tx_req->skb =3D skb;
> -	addr =3D ib_dma_map_single(priv->ca, skb->data, skb->len, =
DMA_TO_DEVICE);
> -	if (unlikely(ib_dma_mapping_error(priv->ca, addr))) {
> +
> +	if (unlikely(ipoib_dma_map_tx(priv->ca, tx_req))) {
> 		++dev->stats.tx_errors;
> 		dev_kfree_skb_any(skb);
> 		return;
> 	}
>=20
> -	tx_req->mapping =3D addr;
> -
> 	skb_orphan(skb);
> 	skb_dst_drop(skb);
>=20
> -	rc =3D post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
> -		       addr, skb->len);
> +	rc =3D post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1), =
tx_req);
> 	if (unlikely(rc)) {
> 		ipoib_warn(priv, "post_send failed, error %d\n", rc);
> 		++dev->stats.tx_errors;
> -		ib_dma_unmap_single(priv->ca, addr, skb->len, =
DMA_TO_DEVICE);
> +		ipoib_dma_unmap_tx(priv, tx_req);
> 		dev_kfree_skb_any(skb);
> 	} else {
> 		dev->trans_start =3D jiffies;
> @@ -777,7 +771,7 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, =
struct ib_wc *wc)
> 	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> 	struct ipoib_cm_tx *tx =3D wc->qp->qp_context;
> 	unsigned int wr_id =3D wc->wr_id & ~IPOIB_OP_CM;
> -	struct ipoib_cm_tx_buf *tx_req;
> +	struct ipoib_tx_buf *tx_req;
> 	unsigned long flags;
>=20
> 	ipoib_dbg_data(priv, "cm send completion: id %d, status: %d\n",
> @@ -791,7 +785,7 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, =
struct ib_wc *wc)
>=20
> 	tx_req =3D &tx->tx_ring[wr_id];
>=20
> -	ib_dma_unmap_single(priv->ca, tx_req->mapping, tx_req->skb->len, =
DMA_TO_DEVICE);
> +	ipoib_dma_unmap_tx(priv, tx_req);
>=20
> 	/* FIXME: is this right? Shouldn't we only increment on success? =
*/
> 	++dev->stats.tx_packets;
> @@ -1036,6 +1030,9 @@ static struct ib_qp =
*ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
>=20
> 	struct ib_qp *tx_qp;
>=20
> +	if (dev->features & NETIF_F_SG)
> +		attr.cap.max_send_sge =3D MAX_SKB_FRAGS + 1;
> +
> 	tx_qp =3D ib_create_qp(priv->pd, &attr);
> 	if (PTR_ERR(tx_qp) =3D=3D -EINVAL) {
> 		ipoib_warn(priv, "can't use GFP_NOIO for QPs on device =
%s, using GFP_KERNEL\n",
> @@ -1170,7 +1167,7 @@ err_tx:
> static void ipoib_cm_tx_destroy(struct ipoib_cm_tx *p)
> {
> 	struct ipoib_dev_priv *priv =3D netdev_priv(p->dev);
> -	struct ipoib_cm_tx_buf *tx_req;
> +	struct ipoib_tx_buf *tx_req;
> 	unsigned long begin;
>=20
> 	ipoib_dbg(priv, "Destroy active connection 0x%x head 0x%x tail =
0x%x\n",
> @@ -1197,8 +1194,7 @@ timeout:
>=20
> 	while ((int) p->tx_tail - (int) p->tx_head < 0) {
> 		tx_req =3D &p->tx_ring[p->tx_tail & (ipoib_sendq_size - =
1)];
> -		ib_dma_unmap_single(priv->ca, tx_req->mapping, =
tx_req->skb->len,
> -				    DMA_TO_DEVICE);
> +		ipoib_dma_unmap_tx(priv, tx_req);
> 		dev_kfree_skb_any(tx_req->skb);
> 		++p->tx_tail;
> 		netif_tx_lock_bh(p->dev);
> @@ -1455,7 +1451,6 @@ static void ipoib_cm_stale_task(struct =
work_struct *work)
> 	spin_unlock_irq(&priv->lock);
> }
>=20
> -
> static ssize_t show_mode(struct device *d, struct device_attribute =
*attr,
> 			 char *buf)
> {
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c =
b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 63b92cb..5e6dc43 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -263,8 +263,7 @@ repost:
> 			   "for buf %d\n", wr_id);
> }
>=20
> -static int ipoib_dma_map_tx(struct ib_device *ca,
> -			    struct ipoib_tx_buf *tx_req)
> +int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf =
*tx_req)
> {
> 	struct sk_buff *skb =3D tx_req->skb;
> 	u64 *mapping =3D tx_req->mapping;
> @@ -305,8 +304,8 @@ partial_error:
> 	return -EIO;
> }
>=20
> -static void ipoib_dma_unmap_tx(struct ib_device *ca,
> -			       struct ipoib_tx_buf *tx_req)
> +void ipoib_dma_unmap_tx(struct ipoib_dev_priv *priv,
> +			struct ipoib_tx_buf *tx_req)
> {
> 	struct sk_buff *skb =3D tx_req->skb;
> 	u64 *mapping =3D tx_req->mapping;
> @@ -314,7 +313,8 @@ static void ipoib_dma_unmap_tx(struct ib_device =
*ca,
> 	int off;
>=20
> 	if (skb_headlen(skb)) {
> -		ib_dma_unmap_single(ca, mapping[0], skb_headlen(skb), =
DMA_TO_DEVICE);
> +		ib_dma_unmap_single(priv->ca, mapping[0], =
skb_headlen(skb),
> +				    DMA_TO_DEVICE);
> 		off =3D 1;
> 	} else
> 		off =3D 0;
> @@ -322,8 +322,8 @@ static void ipoib_dma_unmap_tx(struct ib_device =
*ca,
> 	for (i =3D 0; i < skb_shinfo(skb)->nr_frags; ++i) {
> 		const skb_frag_t *frag =3D &skb_shinfo(skb)->frags[i];
>=20
> -		ib_dma_unmap_page(ca, mapping[i + off], =
skb_frag_size(frag),
> -				  DMA_TO_DEVICE);
> +		ib_dma_unmap_page(priv->ca, mapping[i + off],
> +				  skb_frag_size(frag), DMA_TO_DEVICE);
> 	}
> }
>=20
> @@ -389,7 +389,7 @@ static void ipoib_ib_handle_tx_wc(struct =
net_device *dev, struct ib_wc *wc)
>=20
> 	tx_req =3D &priv->tx_ring[wr_id];
>=20
> -	ipoib_dma_unmap_tx(priv->ca, tx_req);
> +	ipoib_dma_unmap_tx(priv, tx_req);
>=20
> 	++dev->stats.tx_packets;
> 	dev->stats.tx_bytes +=3D tx_req->skb->len;
> @@ -507,13 +507,9 @@ void ipoib_send_comp_handler(struct ib_cq *cq, =
void *dev_ptr)
> 	mod_timer(&priv->poll_timer, jiffies);
> }
>=20
> -static inline int post_send(struct ipoib_dev_priv *priv,
> -			    unsigned int wr_id,
> -			    struct ib_ah *address, u32 qpn,
> -			    struct ipoib_tx_buf *tx_req,
> -			    void *head, int hlen)
> +inline void ipoib_build_sge(struct ipoib_dev_priv *priv,
> +			    struct ipoib_tx_buf *tx_req)
> {
> -	struct ib_send_wr *bad_wr;
> 	int i, off;
> 	struct sk_buff *skb =3D tx_req->skb;
> 	skb_frag_t *frags =3D skb_shinfo(skb)->frags;
> @@ -532,6 +528,19 @@ static inline int post_send(struct ipoib_dev_priv =
*priv,
> 		priv->tx_sge[i + off].length =3D =
skb_frag_size(&frags[i]);
> 	}
> 	priv->tx_wr.num_sge	     =3D nr_frags + off;
> +}
> +
> +static inline int post_send(struct ipoib_dev_priv *priv,
> +			    unsigned int wr_id,
> +			    struct ib_ah *address, u32 qpn,
> +			    struct ipoib_tx_buf *tx_req,
> +			    void *head, int hlen)
> +{
> +	struct ib_send_wr *bad_wr;
> +	struct sk_buff *skb =3D tx_req->skb;
> +
> +	ipoib_build_sge(priv, tx_req);
> +
> 	priv->tx_wr.wr_id 	     =3D wr_id;
> 	priv->tx_wr.wr.ud.remote_qpn =3D qpn;
> 	priv->tx_wr.wr.ud.ah 	     =3D address;
> @@ -617,7 +626,7 @@ void ipoib_send(struct net_device *dev, struct =
sk_buff *skb,
> 		ipoib_warn(priv, "post_send failed, error %d\n", rc);
> 		++dev->stats.tx_errors;
> 		--priv->tx_outstanding;
> -		ipoib_dma_unmap_tx(priv->ca, tx_req);
> +		ipoib_dma_unmap_tx(priv, tx_req);
> 		dev_kfree_skb_any(skb);
> 		if (netif_queue_stopped(dev))
> 			netif_wake_queue(dev);
> @@ -868,7 +877,7 @@ int ipoib_ib_dev_stop(struct net_device *dev)
> 			while ((int) priv->tx_tail - (int) priv->tx_head =
< 0) {
> 				tx_req =3D &priv->tx_ring[priv->tx_tail =
&
> 							=
(ipoib_sendq_size - 1)];
> -				ipoib_dma_unmap_tx(priv->ca, tx_req);
> +				ipoib_dma_unmap_tx(priv, tx_req);
> 				dev_kfree_skb_any(tx_req->skb);
> 				++priv->tx_tail;
> 				--priv->tx_outstanding;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c =
b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 9e1b203..4ee2784 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -190,7 +190,7 @@ static netdev_features_t ipoib_fix_features(struct =
net_device *dev, netdev_featu
> 	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
>=20
> 	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
> -		features &=3D ~(NETIF_F_SG | NETIF_F_IP_CSUM | =
NETIF_F_TSO);
> +		features &=3D ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
>=20
> 	return features;
> }
> --
> 1.7.1
>=20

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_12780F94-87E3-4073-B896-1A9C74843C77
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVnBOCAAoJELgmozMOVy/d9dIP/13WVmtLgCaLyVJTBf6Mm6D1
edzwbrshHnQpRzHO1ylPrOMx/cpF7jUwQS+Duw9HhYMsaion5JdeBe+cB4+/2LlY
JXxMsUL6oHqnigy+ooumUvQsxWOF4t1ramk5FAXdvjMIEvNsm/qKer17RJNJ+S5o
1BpgBukBuqxC1WvrN50Af5nQXW6NNDb1rlKIADSlsPAG57SPP88EtkSmW33NoPFv
KL9WPh/JhdNJU7K+i0LnR1OrXa4/M9o6CNg+1/y8R9QLXwSmBcD94yM6EI35FnsM
SeHxG+u01Wr0aKTEGazyVM+5faTYYwwXOgEqTJCn0SKolbyC4Cmp6vVPYDmMWMlX
Qx3h2K9b1Gp3CqgrCGahwJKO4pM4gzWoVmr0zetpC2Kf6ld0e8PIrRPEmOO/LoUy
zG41So6xWvuMdAy/IoZzz8jQwRaL8loGigbVRlfXmpXrcVDxIWMvOQ1xclb356I3
MZOr8ZEI7Rg6wUTbtaWSIqX3MEHbKIR04KGO9+WAiCdVk3qtlTc06ATa5LZoEX/K
OWjrdtFNq1opKzU3H4aiMvg+5LzdJSU/sb/0g8FmiOTCXtFxnRkJYfIgu0Qhp8vw
gWmpsdDiWPftiqy+BmJfB8sR5ZqpjiFApNMfcHvdluwK2HT3olnbSRfbfFI6CDqo
ZV15lAeg2Kfg4HScebi6
=nQcr
-----END PGP SIGNATURE-----

--Apple-Mail=_12780F94-87E3-4073-B896-1A9C74843C77--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
