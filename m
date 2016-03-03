From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2] IB/ipoib: Add handling for sending of skb with many
 frags
Date: Thu, 3 Mar 2016 10:11:08 -0500
Message-ID: <56D8540C.8010805@redhat.com>
References: <1455784674-8412-1-git-send-email-hans.westgaard.ry@oracle.com>
 <1456922668-24956-1-git-send-email-hans.westgaard.ry@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="W3WDKpUNvP5ahfrmGdxdsDIHirtFl9vQS"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456922668-24956-1-git-send-email-hans.westgaard.ry@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Christoph Lameter <cl@linux.com>, Erez Shitrit <erezsh@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Yuval Shaia <yuval.shaia@oracle.com>, Haakon Bugge <haakon.bugge@oracle.com>, Wei Lin Guay <wei.lin.guay@oracle.com>, Chuck Lever <chuck.lever@oracle.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Matan Barak <matanb@mellanox.com>, "open list:INFINIBAND SUBSYSTEM" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--W3WDKpUNvP5ahfrmGdxdsDIHirtFl9vQS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 03/02/2016 07:44 AM, Hans Westgaard Ry wrote:
> IPoIB converts skb-fragments to sge adding 1 extra sge when SG is enabl=
ed.
> Current codepath assumes that the max number of sge a device support
> is at least MAX_SKB_FRAGS+1, there is no interaction with upper layers
> to limit number of fragments in an skb if a device suports fewer
> sges. The assumptions also lead to requesting a fixed number of sge
> when IPoIB creates queue-pairs with SG enabled.
>=20
> A fallback/slowpath is implemented using skb_linearize to
> handle cases where the conversion would result in more sges than suppor=
ted.
>=20
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> Reviewed-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
> Reviewed-by: Wei Lin Guay <wei.lin.guay@oracle.com>

Thanks for the version 2 that handles both connected and disconnected
mode.  Applied.

> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h       |  2 ++
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c    | 23 +++++++++++++++++++++-=
-
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c    | 18 ++++++++++++++++++
>  drivers/infiniband/ulp/ipoib/ipoib_verbs.c |  5 ++++-
>  4 files changed, 45 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/=
ulp/ipoib/ipoib.h
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
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniba=
nd/ulp/ipoib/ipoib_cm.c
> index 917e46e..c8ed535 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -710,6 +710,7 @@ void ipoib_cm_send(struct net_device *dev, struct s=
k_buff *skb, struct ipoib_cm_
>  	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
>  	struct ipoib_tx_buf *tx_req;
>  	int rc;
> +	unsigned usable_sge =3D tx->max_send_sge - !!skb_headlen(skb);
> =20
>  	if (unlikely(skb->len > tx->mtu)) {
>  		ipoib_warn(priv, "packet len %d (> %d) too long to send, dropping\n"=
,
> @@ -719,7 +720,23 @@ void ipoib_cm_send(struct net_device *dev, struct =
sk_buff *skb, struct ipoib_cm_
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
> +		if (skb_shinfo(skb)->nr_frags > usable_sge) {
> +			ipoib_warn(priv, "too many frags after skb linearize\n");
> +			++dev->stats.tx_dropped;
> +			++dev->stats.tx_errors;
> +			dev_kfree_skb_any(skb);
> +			return;
> +		}
> +	}
>  	ipoib_dbg_data(priv, "sending packet: head 0x%x length %d connection =
0x%x\n",
>  		       tx->tx_head, skb->len, tx->qp->qp_num);
> =20
> @@ -1031,7 +1048,8 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct=
 net_device *dev, struct ipoib_
>  	struct ib_qp *tx_qp;
> =20
>  	if (dev->features & NETIF_F_SG)
> -		attr.cap.max_send_sge =3D MAX_SKB_FRAGS + 1;
> +		attr.cap.max_send_sge =3D
> +			min_t(u32, priv->ca->attrs.max_sge, MAX_SKB_FRAGS + 1);
> =20
>  	tx_qp =3D ib_create_qp(priv->pd, &attr);
>  	if (PTR_ERR(tx_qp) =3D=3D -EINVAL) {
> @@ -1040,6 +1058,7 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct=
 net_device *dev, struct ipoib_
>  		attr.create_flags &=3D ~IB_QP_CREATE_USE_GFP_NOIO;
>  		tx_qp =3D ib_create_qp(priv->pd, &attr);
>  	}
> +	tx->max_send_sge =3D attr.cap.max_send_sge;
>  	return tx_qp;
>  }
> =20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniba=
nd/ulp/ipoib/ipoib_ib.c
> index 5ea0c14..ee7a555 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -540,6 +540,7 @@ void ipoib_send(struct net_device *dev, struct sk_b=
uff *skb,
>  	struct ipoib_tx_buf *tx_req;
>  	int hlen, rc;
>  	void *phead;
> +	unsigned usable_sge =3D priv->max_send_sge - !!skb_headlen(skb);
> =20
>  	if (skb_is_gso(skb)) {
>  		hlen =3D skb_transport_offset(skb) + tcp_hdrlen(skb);
> @@ -563,6 +564,23 @@ void ipoib_send(struct net_device *dev, struct sk_=
buff *skb,
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
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infin=
iband/ulp/ipoib/ipoib_verbs.c
> index d48c5ba..b809c37 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> @@ -206,7 +206,8 @@ int ipoib_transport_dev_init(struct net_device *dev=
, struct ib_device *ca)
>  		init_attr.create_flags |=3D IB_QP_CREATE_NETIF_QP;
> =20
>  	if (dev->features & NETIF_F_SG)
> -		init_attr.cap.max_send_sge =3D MAX_SKB_FRAGS + 1;
> +		init_attr.cap.max_send_sge =3D
> +			min_t(u32, priv->ca->attrs.max_sge, MAX_SKB_FRAGS + 1);
> =20
>  	priv->qp =3D ib_create_qp(priv->pd, &init_attr);
>  	if (IS_ERR(priv->qp)) {
> @@ -233,6 +234,8 @@ int ipoib_transport_dev_init(struct net_device *dev=
, struct ib_device *ca)
>  	priv->rx_wr.next =3D NULL;
>  	priv->rx_wr.sg_list =3D priv->rx_sge;
> =20
> +	priv->max_send_sge =3D init_attr.cap.max_send_sge;
> +
>  	return 0;
> =20
>  out_free_send_cq:
>=20


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--W3WDKpUNvP5ahfrmGdxdsDIHirtFl9vQS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2FQMAAoJELgmozMOVy/d2LUP/1ANKW+IrOt2NESi/ain/7Qj
m62GUrgT+3ZS9OYOgJ/dpq6R0UMf0ItbgDx5IpdvJpAuqwzvFW2gi0jfdLLc3Z8C
wKgLYrv7+JR09NS8+OthGUMofhvfmIuhUEk4rOLvk4axvjiGVQLDhbbqhOw7bAI5
pWuPAKq3lgG5oCCQSfVXO1ZqFogEtINIHPzcXp3mVPHDhUw473/ShpJ1kKZpalg1
sCQySjPSajB7L9eCyl5f++ztXQyO1LXy3SgiYdE3KPDNqBMDr3RFVkblkrLSZuT6
q9wbEktxjlqgBXwWUApfX1qHQZtr5dqEoEVzAbZb0d3gMfXRH6yDwhOFoH2gJNPd
I7ilpCR/wz5GWyPlB4ElZy+WIifRgN9T8ZqMQ7fy110HDYVxxkDBn52XRgqfZy+y
Tz/QFkQOxW1MBRKgOuIgbygM95LM/NKcPOXeQ4pOK4Mbqf7/D//Ir/N6F2yj5nn4
q9frxX245yI1hASSr06+GfWzpTEOjySWkTl1fSOjm24fC4B4KAFo2K+PrgELAFAh
5FncG+IZAiHFyZ6xPmF5/LvTjKTcrUNwBO70ei72pIXs4CK5emlWYcWsHO0/7FTE
3S9lgrIzFHUWbSUYp3V7KNq2FahXC7ui4XOW1R4tiDetnmkLBDsfi8GKAbYvG4+p
VBC4UuGyLWP0oS3AkS+B
=0Ubx
-----END PGP SIGNATURE-----

--W3WDKpUNvP5ahfrmGdxdsDIHirtFl9vQS--
