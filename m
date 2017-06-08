From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1] IB/core: Add generic function to extract IB speed
 from netdev
Date: Thu, 8 Jun 2017 08:16:16 +0300
Message-ID: <20170608051616.GK1127@mtr-leonro.local>
References: <20170606193622.25552-1-yuval.shaia@oracle.com>
 <20170607165022.GF1127@mtr-leonro.local>
 <20170607194635.GA7042@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OOq1TgGhe8eTwFBO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170607194635.GA7042@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--OOq1TgGhe8eTwFBO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 07, 2017 at 10:46:36PM +0300, Yuval Shaia wrote:
> On Wed, Jun 07, 2017 at 07:50:22PM +0300, Leon Romanovsky wrote:
> > On Tue, Jun 06, 2017 at 10:36:22PM +0300, Yuval Shaia wrote:
> > > Logic of retrieving netdev speed from net_device and translating it to IB
> > > speed is implemented in rxe, in usnic and in bnxt drivers.
> > >
> > > Define new function which merges all.
> > >
> > > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > ---
> > > v0 -> v1:
> > > 	* Invite usnic to the party.
> > >
> > > Please note that this patch kills the following mail threads:
> > > 	* [PATCH] IB/bnxt_re: Check return value from get_link_ksettings
> > > 	* [PATCH 1/2] IB/rxe: Check return value from get_settings
> > > 	* [PATCH 2/2] IB/rxe: Protect call to get_link_ksettings with rtnl lock
> > > ---
> > >  drivers/infiniband/core/verbs.c              | 52 ++++++++++++++++++++++++++++
> > >  drivers/infiniband/hw/bnxt_re/ib_verbs.c     | 48 ++-----------------------
> > >  drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 27 ++-------------
> > >  drivers/infiniband/sw/rxe/rxe_verbs.c        | 43 +----------------------
> > >  include/rdma/ib_verbs.h                      |  1 +
> > >  5 files changed, 58 insertions(+), 113 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> > > index 4792f52..de40434 100644
> > > --- a/drivers/infiniband/core/verbs.c
> > > +++ b/drivers/infiniband/core/verbs.c
> > > @@ -1253,6 +1253,58 @@ int ib_resolve_eth_dmac(struct ib_device *device,
> > >  }
> > >  EXPORT_SYMBOL(ib_resolve_eth_dmac);
> > >
> > > +void ib_get_speed(struct net_device *netdev, u8 *speed, u8 *width)
> > > +{
> > > +	int rc;
> > > +	u32 netdev_speed = SPEED_UNKNOWN;
> > > +
>
> [1]
>
> > > +	if (netdev->ethtool_ops->get_link_ksettings) {
> > > +		struct ethtool_link_ksettings lksettings;
> > > +
> > > +		rtnl_lock();
> > > +		rc = netdev->ethtool_ops->get_link_ksettings(netdev,
> > > +							     &lksettings);
> > > +		rtnl_unlock();
> > > +
> > > +		if (!rc)
> > > +			netdev_speed = lksettings.base.speed;
> > > +	} else if (netdev->ethtool_ops->get_settings) {
> > > +		struct ethtool_cmd cmd;
> > > +
> > > +		rc = netdev->ethtool_ops->get_settings(netdev, &cmd);
> > > +
> > > +		if (!rc)
> > > +			netdev_speed = cmd.speed;
> > > +	}
>
> [2]
>
> > > +
> > > +	if (netdev_speed == SPEED_UNKNOWN) {
> > > +		netdev_speed = SPEED_1000;
> > > +		pr_warn("%s speed is unknown, defaulting to %d\n", netdev->name,
> > > +			netdev_speed);
> > > +	}
> >
> > Are you sure that it works for usnic?
> > I didn't check in the code, but from the patch usnic doesn't depend on
> > "netdev->ethtool_ops" and in its case, you will be here with
> > netdev_speed == SPEED_UNKNOWN.
>
> Looking at __ethtool_get_link_ksettings, which is what usnic is using and
> it is doing the exact flow as above so we should be fine.
> However, this makes me think maybe to replace the above ([1] to [2]) with a
> call to __ethtool_get_link_ksettings.
>
> What do you think?

I think that it is good thing and it is a way to go.

Thanks

>
> >
> >
> > > +
> > > +	if (netdev_speed <= SPEED_1000) {
> > > +		*width = IB_WIDTH_1X;
> > > +		*speed = IB_SPEED_SDR;
> > > +	} else if (netdev_speed <= SPEED_10000) {
> > > +		*width = IB_WIDTH_1X;
> > > +		*speed = IB_SPEED_FDR10;
> > > +	} else if (netdev_speed <= SPEED_20000) {
> > > +		*width = IB_WIDTH_4X;
> > > +		*speed = IB_SPEED_DDR;
> > > +	} else if (netdev_speed <= SPEED_25000) {
> > > +		*width = IB_WIDTH_1X;
> > > +		*speed = IB_SPEED_EDR;
> > > +	} else if (netdev_speed <= SPEED_40000) {
> > > +		*width = IB_WIDTH_4X;
> > > +		*speed = IB_SPEED_FDR10;
> > > +	} else {
> > > +		*width = IB_WIDTH_4X;
> > > +		*speed = IB_SPEED_EDR;
> > > +	}
> > > +}
> > > +EXPORT_SYMBOL(ib_get_speed);
> > > +
> > >  int ib_modify_qp(struct ib_qp *qp,
> > >  		 struct ib_qp_attr *qp_attr,
> > >  		 int qp_attr_mask)
> > > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > index 7ba9e69..9a34c06 100644
> > > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > @@ -181,50 +181,6 @@ int bnxt_re_modify_device(struct ib_device *ibdev,
> > >  	return 0;
> > >  }
> > >
> > > -static void __to_ib_speed_width(struct net_device *netdev, u8 *speed, u8 *width)
> > > -{
> > > -	struct ethtool_link_ksettings lksettings;
> > > -	u32 espeed;
> > > -
> > > -	if (netdev->ethtool_ops && netdev->ethtool_ops->get_link_ksettings) {
> > > -		memset(&lksettings, 0, sizeof(lksettings));
> > > -		rtnl_lock();
> > > -		netdev->ethtool_ops->get_link_ksettings(netdev, &lksettings);
> > > -		rtnl_unlock();
> > > -		espeed = lksettings.base.speed;
> > > -	} else {
> > > -		espeed = SPEED_UNKNOWN;
> > > -	}
> > > -	switch (espeed) {
> > > -	case SPEED_1000:
> > > -		*speed = IB_SPEED_SDR;
> > > -		*width = IB_WIDTH_1X;
> > > -		break;
> > > -	case SPEED_10000:
> > > -		*speed = IB_SPEED_QDR;
> > > -		*width = IB_WIDTH_1X;
> > > -		break;
> > > -	case SPEED_20000:
> > > -		*speed = IB_SPEED_DDR;
> > > -		*width = IB_WIDTH_4X;
> > > -		break;
> > > -	case SPEED_25000:
> > > -		*speed = IB_SPEED_EDR;
> > > -		*width = IB_WIDTH_1X;
> > > -		break;
> > > -	case SPEED_40000:
> > > -		*speed = IB_SPEED_QDR;
> > > -		*width = IB_WIDTH_4X;
> > > -		break;
> > > -	case SPEED_50000:
> > > -		break;
> > > -	default:
> > > -		*speed = IB_SPEED_SDR;
> > > -		*width = IB_WIDTH_1X;
> > > -		break;
> > > -	}
> > > -}
> > > -
> > >  /* Port */
> > >  int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
> > >  		       struct ib_port_attr *port_attr)
> > > @@ -266,8 +222,8 @@ int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
> > >  	 * IB stack to avoid race in the NETDEV_UNREG path
> > >  	 */
> > >  	if (test_bit(BNXT_RE_FLAG_IBDEV_REGISTERED, &rdev->flags))
> > > -		__to_ib_speed_width(rdev->netdev, &port_attr->active_speed,
> > > -				    &port_attr->active_width);
> > > +		ib_get_speed(rdev->netdev, &port_attr->active_speed,
> > > +			     &port_attr->active_width);
> > >  	return 0;
> > >  }
> > >
> > > diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> > > index 4996984..097a3b1 100644
> > > --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> > > +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> > > @@ -226,27 +226,6 @@ static void qp_grp_destroy(struct usnic_ib_qp_grp *qp_grp)
> > >  	spin_unlock(&vf->lock);
> > >  }
> > >
> > > -static void eth_speed_to_ib_speed(int speed, u8 *active_speed,
> > > -					u8 *active_width)
> > > -{
> > > -	if (speed <= 10000) {
> > > -		*active_width = IB_WIDTH_1X;
> > > -		*active_speed = IB_SPEED_FDR10;
> > > -	} else if (speed <= 20000) {
> > > -		*active_width = IB_WIDTH_4X;
> > > -		*active_speed = IB_SPEED_DDR;
> > > -	} else if (speed <= 30000) {
> > > -		*active_width = IB_WIDTH_4X;
> > > -		*active_speed = IB_SPEED_QDR;
> > > -	} else if (speed <= 40000) {
> > > -		*active_width = IB_WIDTH_4X;
> > > -		*active_speed = IB_SPEED_FDR10;
> > > -	} else {
> > > -		*active_width = IB_WIDTH_4X;
> > > -		*active_speed = IB_SPEED_EDR;
> > > -	}
> > > -}
> > > -
> > >  static int create_qp_validate_user_data(struct usnic_ib_create_qp_cmd cmd)
> > >  {
> > >  	if (cmd.spec.trans_type <= USNIC_TRANSPORT_UNKNOWN ||
> > > @@ -326,12 +305,12 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
> > >  				struct ib_port_attr *props)
> > >  {
> > >  	struct usnic_ib_dev *us_ibdev = to_usdev(ibdev);
> > > -	struct ethtool_link_ksettings cmd;
> > >
> > >  	usnic_dbg("\n");
> > >
> > >  	mutex_lock(&us_ibdev->usdev_lock);
> > > -	__ethtool_get_link_ksettings(us_ibdev->netdev, &cmd);
> > > +	ib_get_speed(us_ibdev->netdev, &props->active_speed,
> > > +		     &props->active_width);
> > >  	/* props being zeroed by the caller, avoid zeroing it here */
> > >
> > >  	props->lid = 0;
> > > @@ -355,8 +334,6 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
> > >  	props->pkey_tbl_len = 1;
> > >  	props->bad_pkey_cntr = 0;
> > >  	props->qkey_viol_cntr = 0;
> > > -	eth_speed_to_ib_speed(cmd.base.speed, &props->active_speed,
> > > -			      &props->active_width);
> > >  	props->max_mtu = IB_MTU_4096;
> > >  	props->active_mtu = iboe_get_mtu(us_ibdev->ufdev->mtu);
> > >  	/* Userspace will adjust for hdrs */
> > > diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
> > > index 83d709e..cdac9f2 100644
> > > --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> > > +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
> > > @@ -51,36 +51,11 @@ static int rxe_query_device(struct ib_device *dev,
> > >  	return 0;
> > >  }
> > >
> > > -static void rxe_eth_speed_to_ib_speed(int speed, u8 *active_speed,
> > > -				      u8 *active_width)
> > > -{
> > > -	if (speed <= 1000) {
> > > -		*active_width = IB_WIDTH_1X;
> > > -		*active_speed = IB_SPEED_SDR;
> > > -	} else if (speed <= 10000) {
> > > -		*active_width = IB_WIDTH_1X;
> > > -		*active_speed = IB_SPEED_FDR10;
> > > -	} else if (speed <= 20000) {
> > > -		*active_width = IB_WIDTH_4X;
> > > -		*active_speed = IB_SPEED_DDR;
> > > -	} else if (speed <= 30000) {
> > > -		*active_width = IB_WIDTH_4X;
> > > -		*active_speed = IB_SPEED_QDR;
> > > -	} else if (speed <= 40000) {
> > > -		*active_width = IB_WIDTH_4X;
> > > -		*active_speed = IB_SPEED_FDR10;
> > > -	} else {
> > > -		*active_width = IB_WIDTH_4X;
> > > -		*active_speed = IB_SPEED_EDR;
> > > -	}
> > > -}
> > > -
> > >  static int rxe_query_port(struct ib_device *dev,
> > >  			  u8 port_num, struct ib_port_attr *attr)
> > >  {
> > >  	struct rxe_dev *rxe = to_rdev(dev);
> > >  	struct rxe_port *port;
> > > -	u32 speed;
> > >
> > >  	if (unlikely(port_num != 1)) {
> > >  		pr_warn("invalid port_number %d\n", port_num);
> > > @@ -93,23 +68,7 @@ static int rxe_query_port(struct ib_device *dev,
> > >  	*attr = port->attr;
> > >
> > >  	mutex_lock(&rxe->usdev_lock);
> > > -	if (rxe->ndev->ethtool_ops->get_link_ksettings) {
> > > -		struct ethtool_link_ksettings ks;
> > > -
> > > -		rxe->ndev->ethtool_ops->get_link_ksettings(rxe->ndev, &ks);
> > > -		speed = ks.base.speed;
> > > -	} else if (rxe->ndev->ethtool_ops->get_settings) {
> > > -		struct ethtool_cmd cmd;
> > > -
> > > -		rxe->ndev->ethtool_ops->get_settings(rxe->ndev, &cmd);
> > > -		speed = cmd.speed;
> > > -	} else {
> > > -		pr_warn("%s speed is unknown, defaulting to 1000\n",
> > > -			rxe->ndev->name);
> > > -		speed = 1000;
> > > -	}
> > > -	rxe_eth_speed_to_ib_speed(speed, &attr->active_speed,
> > > -				  &attr->active_width);
> > > +	ib_get_speed(rxe->ndev, &attr->active_speed, &attr->active_width);
> > >  	mutex_unlock(&rxe->usdev_lock);
> > >
> > >  	return 0;
> > > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > > index ba8314e..2c57f32 100644
> > > --- a/include/rdma/ib_verbs.h
> > > +++ b/include/rdma/ib_verbs.h
> > > @@ -3488,6 +3488,7 @@ void ib_drain_qp(struct ib_qp *qp);
> > >
> > >  int ib_resolve_eth_dmac(struct ib_device *device,
> > >  			struct rdma_ah_attr *ah_attr);
> > > +void ib_get_speed(struct net_device *netdev, u8 *speed, u8 *width);
> > >
> > >  static inline u8 *rdma_ah_retrieve_dmac(struct rdma_ah_attr *attr)
> > >  {
> > > --
> > > 2.9.4
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--OOq1TgGhe8eTwFBO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk43aAACgkQ5GN7iDZy
WKffJxAAq8KHHXh5Idj8n0SLlRLlUksLIv+3waCs2/BNPXgFF0wUzE4aMVNMS9CO
36m/TlCmNO7eQ/qP9gXiY4a9ncz5EJyMoBWQ5+h2kUMYthFYWh04Gvz6z8LeNAmc
xx7qTxA/Zl9zEvwmmHmo/Lh7gdTlsb51f8d5y55s8P38pnOKOXTBjEosaZenxHNP
kTKL2BX9dOqslCrzZYA/mX0VubHh9qpgyAij4IowasLq9zTIDazE+NNAmr5J+zvO
ouYIUGCNSqs+NyWqHjoykmY8c/lR/lq1CeKIy9k9xGYF5ZNnNkfpQCRLAtEBDUqM
adP6125dBhWPr41IpnjMnY8+FWf1c2csqhjbtVL2yFsNlNExSuTgSTH3XPOZ3AfE
sbFkQ6ryH+li27jYDWyPWmBgpPBuf8fl1YO78Rj3ehx7MudFL9ofoXzC5j17xDl9
Hbfz+grc2P632kPWWicie9WKSawKDyAbAaZ3B12Z5OJgcbJMtQ3VBAoOQ625jask
dzyFwsXtZSdq/dgeDcyFctub77J/B4vlYGoSW3q7K3cAUNmmJff/VeEJ9y21xL/9
yETv67nXYkKyEp9q3TtJIwU3oIPNBLnb6aJtCPSRHEgX8MRu7M8Jjy1S30qJhBOI
siaq8FUPIFhfxVNHyRQ1gdTmQnEasa8VDOs6JAYO7W7nyMYSrH4=
=VPyP
-----END PGP SIGNATURE-----

--OOq1TgGhe8eTwFBO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
