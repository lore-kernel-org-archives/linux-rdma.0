From: "Christian Benvenuti (benve)" <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 2/2] IB/core: Add generic function to extract IB speed
 from netdev
Date: Tue, 13 Jun 2017 08:07:48 +0000
Message-ID: <e58c9e7782774aa1b710b779c44f918d@XCH-RCD-017.cisco.com>
References: <20170611054450.7221-1-yuval.shaia@oracle.com>
 <20170611054450.7221-3-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170611054450.7221-3-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org" <sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Yuval Shaia [mailto:yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> Sent: Saturday, June 10, 2017 10:45 PM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org;
> somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; Christian
> Benvenuti (benve); Dave Goodell (dgoodell); monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org;
> leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org;
> dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org;
> bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org; yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org;
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH v3 2/2] IB/core: Add generic function to extract IB speed=
 from
> netdev
>=20
> Logic of retrieving netdev speed from net_device and translating it to IB=
 speed
> is implemented in rxe, in usnic and in bnxt drivers.
>=20
> Define new function which merges all.
>=20
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Minor nit in ib_get_eth_speed().

For the usnic bits:
Reviewed-by: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

> ---
> v0 -> v1:
> 	* Invite usnic to the party.
> v1 -> v2:
> 	* Utilize __ethtool_get_link_ksettings
> 	* Rename to ib_get_eth_speed
> 	* Add some validation checks
> 	* Implement get_netdev in usnic
> v2 -> v3:
> 	* Split to two separate patches
> ---
>  drivers/infiniband/core/verbs.c              | 55 ++++++++++++++++++++++=
++++++
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c     | 49 ++--------------------=
---
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 31 +++-------------
>  drivers/infiniband/sw/rxe/rxe_verbs.c        | 53 +++-------------------=
-----
>  include/rdma/ib_verbs.h                      |  1 +
>  5 files changed, 71 insertions(+), 118 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/ve=
rbs.c
> index 4792f52..19e6b78 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1253,6 +1253,61 @@ int ib_resolve_eth_dmac(struct ib_device *device, =
 }
> EXPORT_SYMBOL(ib_resolve_eth_dmac);
>=20
> +int ib_get_eth_speed(struct ib_device *dev, u8 port_num, u8 *speed, u8
> +*width) {
> +	int rc;
> +	u32 netdev_speed;
> +	struct net_device *netdev;
> +	struct ethtool_link_ksettings lksettings;
> +
> +	if (rdma_port_get_link_layer(dev, port_num) !=3D IB_LINK_LAYER_ETHERNET=
)
> +		return -EINVAL;
> +
> +	if (!dev->get_netdev)
> +		return -EINVAL;

-EOPNOTSUPP ?

> +	netdev =3D dev->get_netdev(dev, port_num);
> +	if (!netdev)
> +		return -EINVAL;
> +
> +	rtnl_lock();
> +	rc =3D __ethtool_get_link_ksettings(netdev, &lksettings);
> +	rtnl_unlock();
> +
> +	dev_put(netdev);
> +
> +	if (!rc) {
> +		netdev_speed =3D lksettings.base.speed;
> +	} else {
> +		netdev_speed =3D SPEED_1000;
> +		pr_warn("%s speed is unknown, defaulting to %d\n", netdev->name,
> +			netdev_speed);
> +	}
> +
> +	if (netdev_speed <=3D SPEED_1000) {
> +		*width =3D IB_WIDTH_1X;
> +		*speed =3D IB_SPEED_SDR;
> +	} else if (netdev_speed <=3D SPEED_10000) {
> +		*width =3D IB_WIDTH_1X;
> +		*speed =3D IB_SPEED_FDR10;
> +	} else if (netdev_speed <=3D SPEED_20000) {
> +		*width =3D IB_WIDTH_4X;
> +		*speed =3D IB_SPEED_DDR;
> +	} else if (netdev_speed <=3D SPEED_25000) {
> +		*width =3D IB_WIDTH_1X;
> +		*speed =3D IB_SPEED_EDR;
> +	} else if (netdev_speed <=3D SPEED_40000) {
> +		*width =3D IB_WIDTH_4X;
> +		*speed =3D IB_SPEED_FDR10;
> +	} else {
> +		*width =3D IB_WIDTH_4X;
> +		*speed =3D IB_SPEED_EDR;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ib_get_eth_speed);
> +
>  int ib_modify_qp(struct ib_qp *qp,
>  		 struct ib_qp_attr *qp_attr,
>  		 int qp_attr_mask)
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index 7ba9e69..d0e0f90 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -181,50 +181,6 @@ int bnxt_re_modify_device(struct ib_device *ibdev,
>  	return 0;
>  }
>=20
> -static void __to_ib_speed_width(struct net_device *netdev, u8 *speed, u8
> *width) -{
> -	struct ethtool_link_ksettings lksettings;
> -	u32 espeed;
> -
> -	if (netdev->ethtool_ops && netdev->ethtool_ops->get_link_ksettings) {
> -		memset(&lksettings, 0, sizeof(lksettings));
> -		rtnl_lock();
> -		netdev->ethtool_ops->get_link_ksettings(netdev, &lksettings);
> -		rtnl_unlock();
> -		espeed =3D lksettings.base.speed;
> -	} else {
> -		espeed =3D SPEED_UNKNOWN;
> -	}
> -	switch (espeed) {
> -	case SPEED_1000:
> -		*speed =3D IB_SPEED_SDR;
> -		*width =3D IB_WIDTH_1X;
> -		break;
> -	case SPEED_10000:
> -		*speed =3D IB_SPEED_QDR;
> -		*width =3D IB_WIDTH_1X;
> -		break;
> -	case SPEED_20000:
> -		*speed =3D IB_SPEED_DDR;
> -		*width =3D IB_WIDTH_4X;
> -		break;
> -	case SPEED_25000:
> -		*speed =3D IB_SPEED_EDR;
> -		*width =3D IB_WIDTH_1X;
> -		break;
> -	case SPEED_40000:
> -		*speed =3D IB_SPEED_QDR;
> -		*width =3D IB_WIDTH_4X;
> -		break;
> -	case SPEED_50000:
> -		break;
> -	default:
> -		*speed =3D IB_SPEED_SDR;
> -		*width =3D IB_WIDTH_1X;
> -		break;
> -	}
> -}
> -
>  /* Port */
>  int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
>  		       struct ib_port_attr *port_attr) @@ -266,8 +222,9 @@ int
> bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
>  	 * IB stack to avoid race in the NETDEV_UNREG path
>  	 */
>  	if (test_bit(BNXT_RE_FLAG_IBDEV_REGISTERED, &rdev->flags))
> -		__to_ib_speed_width(rdev->netdev, &port_attr->active_speed,
> -				    &port_attr->active_width);
> +		if (!ib_get_eth_speed(ibdev, port_num, &port_attr->active_speed,
> +				      &port_attr->active_width))
> +			return -EINVAL;
>  	return 0;
>  }
>=20
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> index f9dc1e80..e5f57dd 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> @@ -226,27 +226,6 @@ static void qp_grp_destroy(struct usnic_ib_qp_grp *q=
p_grp)
>  	spin_unlock(&vf->lock);
>  }
>=20
> -static void eth_speed_to_ib_speed(int speed, u8 *active_speed,
> -					u8 *active_width)
> -{
> -	if (speed <=3D 10000) {
> -		*active_width =3D IB_WIDTH_1X;
> -		*active_speed =3D IB_SPEED_FDR10;
> -	} else if (speed <=3D 20000) {
> -		*active_width =3D IB_WIDTH_4X;
> -		*active_speed =3D IB_SPEED_DDR;
> -	} else if (speed <=3D 30000) {
> -		*active_width =3D IB_WIDTH_4X;
> -		*active_speed =3D IB_SPEED_QDR;
> -	} else if (speed <=3D 40000) {
> -		*active_width =3D IB_WIDTH_4X;
> -		*active_speed =3D IB_SPEED_FDR10;
> -	} else {
> -		*active_width =3D IB_WIDTH_4X;
> -		*active_speed =3D IB_SPEED_EDR;
> -	}
> -}
> -
>  static int create_qp_validate_user_data(struct usnic_ib_create_qp_cmd cm=
d)  {
>  	if (cmd.spec.trans_type <=3D USNIC_TRANSPORT_UNKNOWN || @@ -326,12 +305=
,16
> @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
>  				struct ib_port_attr *props)
>  {
>  	struct usnic_ib_dev *us_ibdev =3D to_usdev(ibdev);
> -	struct ethtool_link_ksettings cmd;
>=20
>  	usnic_dbg("\n");
>=20
>  	mutex_lock(&us_ibdev->usdev_lock);
> -	__ethtool_get_link_ksettings(us_ibdev->netdev, &cmd);
> +	if (!ib_get_eth_speed(ibdev, port, &props->active_speed,
> +			      &props->active_width)) {
> +		mutex_unlock(&us_ibdev->usdev_lock);
> +		return -EINVAL;
> +	}
> +
>  	/* props being zeroed by the caller, avoid zeroing it here */
>=20
>  	props->lid =3D 0;
> @@ -355,8 +338,6 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 p=
ort,
>  	props->pkey_tbl_len =3D 1;
>  	props->bad_pkey_cntr =3D 0;
>  	props->qkey_viol_cntr =3D 0;
> -	eth_speed_to_ib_speed(cmd.base.speed, &props->active_speed,
> -			      &props->active_width);
>  	props->max_mtu =3D IB_MTU_4096;
>  	props->active_mtu =3D iboe_get_mtu(us_ibdev->ufdev->mtu);
>  	/* Userspace will adjust for hdrs */
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c
> b/drivers/infiniband/sw/rxe/rxe_verbs.c
> index 83d709e..4570f04 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
> @@ -51,40 +51,16 @@ static int rxe_query_device(struct ib_device *dev,
>  	return 0;
>  }
>=20
> -static void rxe_eth_speed_to_ib_speed(int speed, u8 *active_speed,
> -				      u8 *active_width)
> -{
> -	if (speed <=3D 1000) {
> -		*active_width =3D IB_WIDTH_1X;
> -		*active_speed =3D IB_SPEED_SDR;
> -	} else if (speed <=3D 10000) {
> -		*active_width =3D IB_WIDTH_1X;
> -		*active_speed =3D IB_SPEED_FDR10;
> -	} else if (speed <=3D 20000) {
> -		*active_width =3D IB_WIDTH_4X;
> -		*active_speed =3D IB_SPEED_DDR;
> -	} else if (speed <=3D 30000) {
> -		*active_width =3D IB_WIDTH_4X;
> -		*active_speed =3D IB_SPEED_QDR;
> -	} else if (speed <=3D 40000) {
> -		*active_width =3D IB_WIDTH_4X;
> -		*active_speed =3D IB_SPEED_FDR10;
> -	} else {
> -		*active_width =3D IB_WIDTH_4X;
> -		*active_speed =3D IB_SPEED_EDR;
> -	}
> -}
> -
>  static int rxe_query_port(struct ib_device *dev,
>  			  u8 port_num, struct ib_port_attr *attr)  {
>  	struct rxe_dev *rxe =3D to_rdev(dev);
>  	struct rxe_port *port;
> -	u32 speed;
> +	int rc =3D -EINVAL;
>=20
>  	if (unlikely(port_num !=3D 1)) {
>  		pr_warn("invalid port_number %d\n", port_num);
> -		goto err1;
> +		goto out;
>  	}
>=20
>  	port =3D &rxe->port;
> @@ -93,29 +69,12 @@ static int rxe_query_port(struct ib_device *dev,
>  	*attr =3D port->attr;
>=20
>  	mutex_lock(&rxe->usdev_lock);
> -	if (rxe->ndev->ethtool_ops->get_link_ksettings) {
> -		struct ethtool_link_ksettings ks;
> -
> -		rxe->ndev->ethtool_ops->get_link_ksettings(rxe->ndev, &ks);
> -		speed =3D ks.base.speed;
> -	} else if (rxe->ndev->ethtool_ops->get_settings) {
> -		struct ethtool_cmd cmd;
> -
> -		rxe->ndev->ethtool_ops->get_settings(rxe->ndev, &cmd);
> -		speed =3D cmd.speed;
> -	} else {
> -		pr_warn("%s speed is unknown, defaulting to 1000\n",
> -			rxe->ndev->name);
> -		speed =3D 1000;
> -	}
> -	rxe_eth_speed_to_ib_speed(speed, &attr->active_speed,
> -				  &attr->active_width);
> +	rc =3D ib_get_eth_speed(dev, port_num, &attr->active_speed,
> +			      &attr->active_width);
>  	mutex_unlock(&rxe->usdev_lock);
>=20
> -	return 0;
> -
> -err1:
> -	return -EINVAL;
> +out:
> +	return rc;
>  }
>=20
>  static int rxe_query_gid(struct ib_device *device, diff --git
> a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h index ba8314e..860cb3=
0
> 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -3488,6 +3488,7 @@ void ib_drain_qp(struct ib_qp *qp);
>=20
>  int ib_resolve_eth_dmac(struct ib_device *device,
>  			struct rdma_ah_attr *ah_attr);
> +int ib_get_eth_speed(struct ib_device *dev, u8 port_num, u8 *speed, u8
> +*width);
>=20
>  static inline u8 *rdma_ah_retrieve_dmac(struct rdma_ah_attr *attr)  {
> --
> 2.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
