From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 17/18] IB/core: Define 'ib' and 'eth'
 rdma_ah_attr types
Date: Wed, 12 Apr 2017 01:44:51 +0000
Message-ID: <VI1PR0502MB30081ACB86A0ADEEE2C68743D1030@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1491932545-60894-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1491932545-60894-18-git-send-email-dasaratharaman.chandramouli@intel.com>
 <VI1PR0502MB3008F933EA086C3A47C025B3D1000@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <9873c7bd-5fe7-7b9a-c28f-e11ffa5d53e9@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9873c7bd-5fe7-7b9a-c28f-e11ffa5d53e9-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Chandramouli, Dasaratharaman" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Chandramouli, Dasaratharaman
> [mailto:dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> Sent: Tuesday, April 11, 2017 8:36 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-rdma <linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>; Hefty, Sean
> <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 17/18] IB/core: Define 'ib' and 'eth'
> rdma_ah_attr types
>=20
>=20
>=20
> On 4/11/2017 4:09 PM, Parav Pandit wrote:
> >
> >

> >>  int rdma_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
> >> {
> >> +	if (ah->type !=3D ah_attr->type)
> >> +		return -EINVAL;
> >> +
> >>  	return ah->device->modify_ah ?
> >>  		ah->device->modify_ah(ah, ah_attr) :
> >>  		-ENOSYS;
> >> @@ -1207,14 +1213,14 @@ int ib_resolve_eth_dmac(struct ib_device
> >> *device,
> >>  	if (!rdma_is_port_valid(device, rdma_ah_get_port_num(ah_attr)))
> >>  		return -EINVAL;
> >>
> >> -	if (!rdma_cap_eth_ah(device, rdma_ah_get_port_num(ah_attr)))
> >> +	if (ah_attr->type !=3D RDMA_AH_ATTR_TYPE_ETH)
> >>  		return 0;
> > Can you keep rdma_cap_eth_ah to do the work of the above code?
> > This function is useful for other patches that I am working on. That wa=
y we
> don't have to open code for this comparison.
>=20
> Not too sure i follow. Are you suggesting we keep the old rdma_cap_eth_ah
> check?
> I can change the type check into a function if you feel its open coded.
> One of the benefits of adding type to ah_attr is exactly the above code.
> The caller doesnt have to call into the core (rdma_cap_eth_ah) to know wh=
at
> 'protocol' its working with. That information is contained in the ah_attr=
 itself.
>=20
I was referring to have helper function like rdma_cap_eth_ah, but for ah_at=
tr_type
as,
is_ah_attr_eth(ah_attr).

I think it will be more useful, as there is more code in grh processing com=
ing up, that needs to diverge based on ib vs roce.
And there are few places we have that comparison anyway below. It just keep=
 code neat.

> >
> >>
> >>  	grh =3D rdma_ah_retrieve_grh(ah_attr);
> >>
> >>  	if (rdma_link_local_addr((struct in6_addr *)grh->dgid.raw)) {
> >>  		rdma_get_ll_mac((struct in6_addr *)grh->dgid.raw,
> >> -				ah_attr->dmac);
> >> +				ah_attr->eth.dmac);
> >>  	} else {
> >>  		union ib_gid		sgid;
> >>  		struct ib_gid_attr	sgid_attr;
> >> @@ -1236,7 +1242,7 @@ int ib_resolve_eth_dmac(struct ib_device
> >> *device,
> >>
> >>  		ret =3D
> >>  		rdma_addr_find_l2_eth_by_grh(&sgid, &grh->dgid,
> >> -					     ah_attr->dmac,
> >> +					     ah_attr->eth.dmac,
> >>  					     NULL, &ifindex, &hop_limit);
> >>
> >>  		dev_put(sgid_attr.ndev);
> >> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> >> b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> >> index 0de43c7..2d0d6fe 100644
> >> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> >> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> >> @@ -597,7 +597,7 @@ struct ib_ah *bnxt_re_create_ah(struct ib_pd
> >> *ib_pd,
> >>  			break;
> >>  		}
> >>  		rc =3D rdma_addr_find_l2_eth_by_grh(&sgid, &grh->dgid,
> >> -						  ah_attr->dmac, &vlan_tag,
> >> +						  ah_attr->eth.dmac,
> >> &vlan_tag,
> >>  						  &sgid_attr.ndev->ifindex,
> >>  						  NULL);
> >>  		if (rc) {
> >> @@ -606,7 +606,7 @@ struct ib_ah *bnxt_re_create_ah(struct ib_pd
> >> *ib_pd,
> >>  		}
> >>  	}
> >>
> >> -	memcpy(ah->qplib_ah.dmac, ah_attr->dmac, ETH_ALEN);
> >> +	memcpy(ah->qplib_ah.dmac, ah_attr->eth.dmac, ETH_ALEN);
> >>  	rc =3D bnxt_qplib_create_ah(&rdev->qplib_res, &ah->qplib_ah);
> >>  	if (rc) {
> >>  		dev_err(rdev_to_dev(rdev), "Failed to allocate HW AH");
> @@ -644,8
> >> +644,9 @@ int bnxt_re_query_ah(struct ib_ah *ib_ah, struct
> >> rdma_ah_attr *ah_attr)  {
> >>  	struct bnxt_re_ah *ah =3D container_of(ib_ah, struct bnxt_re_ah,
> >> ib_ah);
> >>
> >> +	ah_attr->type =3D ib_ah->type;
> >>  	rdma_ah_set_sl(ah_attr, ah->qplib_ah.sl);
> >> -	memcpy(ah_attr->dmac, ah->qplib_ah.dmac, ETH_ALEN);
> >> +	memcpy(ah_attr->eth.dmac, ah->qplib_ah.dmac, ETH_ALEN);
> >>  	rdma_ah_set_grh(ah_attr, NULL, 0,
> >>  			ah->qplib_ah.host_sgid_index,
> >>  			0, ah->qplib_ah.traffic_class);
> >> @@ -1280,7 +1281,8 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp,
> >> struct ib_qp_attr *qp_attr,
> >>  		qp->qplib_qp.ah.hop_limit =3D grh->hop_limit;
> >>  		qp->qplib_qp.ah.traffic_class =3D grh->traffic_class;
> >>  		qp->qplib_qp.ah.sl =3D rdma_ah_get_sl(&qp_attr->ah_attr);
> >> -		ether_addr_copy(qp->qplib_qp.ah.dmac, qp_attr-
> >>> ah_attr.dmac);
> >> +		ether_addr_copy(qp->qplib_qp.ah.dmac,
> >> +				qp_attr->ah_attr.eth.dmac);
> >>
> >>  		status =3D ib_get_cached_gid(&rdev->ibdev, 1,
> >>  					   grh->sgid_index,
> >> @@ -1423,13 +1425,14 @@ int bnxt_re_query_qp(struct ib_qp *ib_qp,
> >> struct ib_qp_attr *qp_attr,
> >>  	qp_attr->qp_access_flags =3D __to_ib_access_flags(qplib_qp.access);
> >>  	qp_attr->pkey_index =3D qplib_qp.pkey_index;
> >>  	qp_attr->qkey =3D qplib_qp.qkey;
> >> +	qp_attr->ah_attr.type =3D RDMA_AH_ATTR_TYPE_ETH;
> >>  	rdma_ah_set_grh(&qp_attr->ah_attr, NULL, qplib_qp.ah.flow_label,
> >>  			qplib_qp.ah.host_sgid_index,
> >>  			qplib_qp.ah.hop_limit,
> >>  			qplib_qp.ah.traffic_class);
> >>  	rdma_ah_set_dgid_raw(&qp_attr->ah_attr, qplib_qp.ah.dgid.data);
> >>  	rdma_ah_set_sl(&qp_attr->ah_attr, qplib_qp.ah.sl);
> >> -	ether_addr_copy(qp_attr->ah_attr.dmac, qplib_qp.ah.dmac);
> >> +	ether_addr_copy(qp_attr->ah_attr.eth.dmac, qplib_qp.ah.dmac);
> >>  	qp_attr->path_mtu =3D __to_ib_mtu(qplib_qp.path_mtu);
> >>  	qp_attr->timeout =3D qplib_qp.timeout;
> >>  	qp_attr->retry_cnt =3D qplib_qp.retry_cnt; diff --git
> >> a/drivers/infiniband/hw/hfi1/verbs.c
> >> b/drivers/infiniband/hw/hfi1/verbs.c
> >> index be3077d..0e464f0 100644
> >> --- a/drivers/infiniband/hw/hfi1/verbs.c
> >> +++ b/drivers/infiniband/hw/hfi1/verbs.c
> >> @@ -1509,8 +1509,12 @@ struct ib_ah *hfi1_create_qp0_ah(struct
> >> hfi1_ibport *ibp, u16 dlid)
> >>  	struct rdma_ah_attr attr;
> >>  	struct ib_ah *ah =3D ERR_PTR(-EINVAL);
> >>  	struct rvt_qp *qp0;
> >> +	struct hfi1_pportdata *ppd =3D ppd_from_ibp(ibp);
> >> +	struct hfi1_devdata *dd =3D dd_from_ppd(ppd);
> >> +	u8 port_num =3D ppd->port;
> >>
> >>  	memset(&attr, 0, sizeof(attr));
> >> +	attr.type =3D rdma_ah_find_type(&dd->verbs_dev.rdi.ibdev,
> >> port_num);
> >>  	rdma_ah_set_dlid(&attr, dlid);
> >>  	rdma_ah_set_port_num(&attr, ppd_from_ibp(ibp)->port);
> >>  	rcu_read_lock();
> >> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> >> b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> >> index 6a0353d..9c6fa06 100644
> >> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> >> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> >> @@ -2737,7 +2737,7 @@ static int hns_roce_v1_m_qp(struct ib_qp
> *ibqp,
> >> const struct ib_qp_attr *attr,
> >>  			goto out;
> >>  		}
> >>
> >> -		dmac =3D (u8 *)attr->ah_attr.dmac;
> >> +		dmac =3D (u8 *)attr->ah_attr.eth.dmac;
> >>
> >>  		context->sq_rq_bt_l =3D (u32)(dma_handle);
> >>  		roce_set_field(context->qpc_bytes_24,
> >> diff --git a/drivers/infiniband/hw/mlx4/ah.c
> >> b/drivers/infiniband/hw/mlx4/ah.c index 3cbac5f..44934b9 100644
> >> --- a/drivers/infiniband/hw/mlx4/ah.c
> >> +++ b/drivers/infiniband/hw/mlx4/ah.c
> >> @@ -96,7 +96,7 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd=
,
> >>  		is_mcast =3D 1;
> >>  		rdma_get_mcast_mac(&in6, ah->av.eth.mac);
> >>  	} else {
> >> -		memcpy(ah->av.eth.mac, ah_attr->dmac, ETH_ALEN);
> >> +		memcpy(ah->av.eth.mac, ah_attr->eth.dmac, ETH_ALEN);
> >>  	}
> >>  	ret =3D ib_get_cached_gid(pd->device,
> rdma_ah_get_port_num(ah_attr),
> >>  				grh->sgid_index, &sgid, &gid_attr); @@ -
> >> 154,9 +154,7 @@ struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd,
> >> struct rdma_ah_attr *ah_attr,
> >>  	if (!ah)
> >>  		return ERR_PTR(-ENOMEM);
> >>
> >> -	if (rdma_port_get_link_layer(pd->device,
> >> -				     rdma_ah_get_port_num(ah_attr)) =3D=3D
> >> -	    IB_LINK_LAYER_ETHERNET) {
> >> +	if (ah_attr->type =3D=3D RDMA_AH_ATTR_TYPE_ETH) {
> >>  		if (!(rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH)) {
> >>  			ret =3D ERR_PTR(-EINVAL);
> >>  		} else {
> >> @@ -182,30 +180,29 @@ struct ib_ah *mlx4_ib_create_ah(struct ib_pd
> >> *pd, struct rdma_ah_attr *ah_attr,  int mlx4_ib_query_ah(struct ib_ah
> >> *ibah, struct rdma_ah_attr *ah_attr)  {
> >>  	struct mlx4_ib_ah *ah =3D to_mah(ibah);
> >> -	enum rdma_link_layer ll;
> >> +	int port_num =3D be32_to_cpu(ah->av.ib.port_pd) >> 24;
> >>
> >>  	memset(ah_attr, 0, sizeof *ah_attr);
> >> -	rdma_ah_set_port_num(ah_attr,
> >> -			     be32_to_cpu(ah->av.ib.port_pd) >> 24);
> >> -	ll =3D rdma_port_get_link_layer(ibah->device,
> >> -				      rdma_ah_get_port_num(ah_attr));
> >> -	if (ll =3D=3D IB_LINK_LAYER_ETHERNET)
> >> +	ah_attr->type =3D ibah->type;
> >> +
> >> +	if (ah_attr->type =3D=3D RDMA_AH_ATTR_TYPE_ETH) {
> >> +		rdma_ah_set_dlid(ah_attr, 0);
> >>  		rdma_ah_set_sl(ah_attr,
> >>  			       be32_to_cpu(ah->av.eth.sl_tclass_flowlabel)
> >>  			       >> 29);
> >> -	else
> >> +	} else {
> >> +		rdma_ah_set_dlid(ah_attr, be16_to_cpu(ah->av.ib.dlid));
> >>  		rdma_ah_set_sl(ah_attr,
> >>  			       be32_to_cpu(ah->av.ib.sl_tclass_flowlabel)
> >>  			       >> 28);
> >> +	}
> >>
> >> -	rdma_ah_set_dlid(ah_attr, (ll =3D=3D IB_LINK_LAYER_INFINIBAND) ?
> >> -			 be16_to_cpu(ah->av.ib.dlid) : 0);
> >> +	rdma_ah_set_port_num(ah_attr, port_num);
> >>  	if (ah->av.ib.stat_rate)
> >>  		rdma_ah_set_static_rate(ah_attr,
> >>  					ah->av.ib.stat_rate -
> >>  					MLX4_STAT_RATE_OFFSET);
> >>  	rdma_ah_set_path_bits(ah_attr, ah->av.ib.g_slid & 0x7F);
> >> -
> >>  	if (mlx4_ib_ah_grh_present(ah)) {
> >>  		u32 tc_fl =3D be32_to_cpu(ah->av.ib.sl_tclass_flowlabel);
> >>
> >> diff --git a/drivers/infiniband/hw/mlx4/mad.c
> >> b/drivers/infiniband/hw/mlx4/mad.c
> >> index 425515e..b469471 100644
> >> --- a/drivers/infiniband/hw/mlx4/mad.c
> >> +++ b/drivers/infiniband/hw/mlx4/mad.c
> >> @@ -196,6 +196,7 @@ static void update_sm_ah(struct mlx4_ib_dev
> *dev,
> >> u8 port_num, u16 lid, u8 sl)
> >>  		return;
> >>
> >>  	memset(&ah_attr, 0, sizeof ah_attr);
> >> +	ah_attr.type =3D rdma_ah_find_type(&dev->ib_dev, port_num);
> >>  	rdma_ah_set_dlid(&ah_attr, lid);
> >>  	rdma_ah_set_sl(&ah_attr, sl);
> >>  	rdma_ah_set_port_num(&ah_attr, port_num); @@ -555,6 +556,7
> @@ int
> >> mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
> >>  	/* create ah. Just need an empty one with the port num for the post
> >> send.
> >>  	 * The driver will set the force loopback bit in post_send */
> >>  	memset(&attr, 0, sizeof attr);
> >> +	attr.type =3D rdma_ah_find_type(&dev->ib_dev, port);
> >>
> >>  	rdma_ah_set_port_num(&attr, port);
> >>  	if (is_eth) {
> >> diff --git a/drivers/infiniband/hw/mlx4/qp.c
> >> b/drivers/infiniband/hw/mlx4/qp.c index 0c016d8..fa3f374 100644
> >> --- a/drivers/infiniband/hw/mlx4/qp.c
> >> +++ b/drivers/infiniband/hw/mlx4/qp.c
> >> @@ -1388,8 +1388,6 @@ static int _mlx4_set_path(struct mlx4_ib_dev
> *dev,
> >>  			  u64 smac, u16 vlan_tag, struct mlx4_qp_path *path,
> >>  			  struct mlx4_roce_smac_vlan_info *smac_info, u8
> >> port)  {
> >> -	int is_eth =3D rdma_port_get_link_layer(&dev->ib_dev, port) =3D=3D
> >> -		IB_LINK_LAYER_ETHERNET;
> >>  	int vidx;
> >>  	int smac_index;
> >>  	int err;
> >> @@ -1426,7 +1424,7 @@ static int _mlx4_set_path(struct mlx4_ib_dev
> *dev,
> >>  		memcpy(path->rgid, grh->dgid.raw, 16);
> >>  	}
> >>
> >> -	if (is_eth) {
> >> +	if (ah->type =3D=3D RDMA_AH_ATTR_TYPE_ETH) {
> >
> > Lets have the macro/function for this change, instead of open code.
>=20
> I can create an function. I liked the straightforward comparison though, =
it just
> made it easier to understand on seeing the code.
> On the aspect of open coding --  IMO, the type attribute is something the
> caller needs to be aware of and work with. We added functions for many of
> the other fields as they were more internal to the structure.
> Can definitely change it into a function if you feel strongly about it.
>=20
I like to have one.
While we are at it, I was thinking since iWarp doesn't use AH, we better na=
me ah->type as ROCE, to avoid this confusion happening again?

> >
> >>  		if (!(rdma_ah_get_ah_flags(ah) & IB_AH_GRH))
> >>  			return -1;
> >>
> >> @@ -1490,7 +1488,7 @@ static int _mlx4_set_path(struct mlx4_ib_dev
> *dev,
> >>  		} else {
> >>  			smac_index =3D smac_info->smac_index;
> >>  		}
> >> -		memcpy(path->dmac, ah->dmac, 6);
> >> +		memcpy(path->dmac, ah->eth.dmac, 6);
> >>  		path->ackto =3D MLX4_IB_LINK_TYPE_ETH;
> >>  		/* put MAC table smac index for IBoE */
> >>  		path->grh_mylmc =3D (u8) (smac_index) | 0x80; @@ -3402,23
> >> +3400,19 @@ static void to_rdma_ah_attr(struct mlx4_ib_dev *ibdev,
> >>  			    struct mlx4_qp_path *path)
> >>  {
> >>  	struct mlx4_dev *dev =3D ibdev->dev;
> >> -	int is_eth;
> >>  	u8 port_num =3D path->sched_queue & 0x40 ? 2 : 1;
> >>
> >>  	memset(ah_attr, 0, sizeof(*ah_attr));
> >> -	rdma_ah_set_port_num(ah_attr, port_num);
> >> -
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
