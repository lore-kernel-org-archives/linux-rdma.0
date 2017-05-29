From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 5/9] IB/core, rdmavt, hfi1: Send OPA cap_mask3
 in trap
Date: Mon, 29 May 2017 19:14:07 +0300
Message-ID: <20170529161407.GB17751@mtr-leonro.local>
References: <20170526123257.8158.23943.stgit@scvm10.sc.intel.com>
 <20170526123536.8158.237.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UTjKcilERHWBCdCp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170526123536.8158.237.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael N. Henry" <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--UTjKcilERHWBCdCp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 26, 2017 at 05:35:37AM -0700, Dennis Dalessandro wrote:
> From: Michael N. Henry <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Provide the ability for IB clients to modify the OPA specific
> capability mask and include this mask in the subsequent trap data.
>
> Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michael N. Henry <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/mad.c   |    7 ++-----
>  drivers/infiniband/hw/hfi1/mad.h   |    2 +-
>  drivers/infiniband/hw/hfi1/verbs.c |    7 ++++++-
>  drivers/infiniband/sw/rdmavt/vt.c  |    9 +++++++--
>  include/rdma/ib_verbs.h            |    3 ++-
>  include/rdma/rdma_vt.h             |    1 +
>  6 files changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
> index 5977673..70831ad 100644
> --- a/drivers/infiniband/hw/hfi1/mad.c
> +++ b/drivers/infiniband/hw/hfi1/mad.c
> @@ -260,6 +260,7 @@ void hfi1_cap_mask_chg(struct rvt_dev_info *rdi, u8 port_num)
>  	data.issuer_lid = cpu_to_be32(lid);
>  	data.ntc_144.lid = data.issuer_lid;
>  	data.ntc_144.new_cap_mask = cpu_to_be32(ibp->rvp.port_cap_flags);
> +	data.ntc_144.cap_mask3 = cpu_to_be16(ibp->rvp.port_cap3_flags);
>
>  	send_trap(ibp, &data, sizeof(data));
>  }
> @@ -704,11 +705,7 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
>  	buffer_units |= (dd->vl15_init << 11) & OPA_PI_MASK_BUF_UNIT_VL15_INIT;
>  	pi->buffer_units = cpu_to_be32(buffer_units);
>
> -	pi->opa_cap_mask = cpu_to_be16(OPA_CAP_MASK3_IsSharedSpaceSupported |
> -				       OPA_CAP_MASK3_IsEthOnFabricSupported);
> -	/* Driver does not support mcast/collective configuration */
> -	pi->opa_cap_mask &=
> -		cpu_to_be16(~OPA_CAP_MASK3_IsAddrRangeConfigSupported);
> +	pi->opa_cap_mask = cpu_to_be16(ibp->rvp.port_cap3_flags);
>  	pi->collectivemask_multicastmask = ((HFI1_COLLECTIVE_NR & 0x7)
>  					    << 3 | (HFI1_MCAST_NR & 0x7));
>
> diff --git a/drivers/infiniband/hw/hfi1/mad.h b/drivers/infiniband/hw/hfi1/mad.h
> index 5aa3fd1..a4e2506 100644
> --- a/drivers/infiniband/hw/hfi1/mad.h
> +++ b/drivers/infiniband/hw/hfi1/mad.h
> @@ -115,7 +115,7 @@ struct opa_mad_notice_attr {
>  			__be32	lid;		/* LID where change occurred */
>  			__be32	new_cap_mask;	/* new capability mask */
>  			__be16	reserved2;
> -			__be16	cap_mask;
> +			__be16	cap_mask3;
>  			__be16	change_flags;	/* low 4 bits only */
>  		} __packed ntc_144;
>
> diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
> index af54d3f..2881798 100644
> --- a/drivers/infiniband/hw/hfi1/verbs.c
> +++ b/drivers/infiniband/hw/hfi1/verbs.c
> @@ -1537,9 +1537,14 @@ static void init_ibport(struct hfi1_pportdata *ppd)
>  	/* Set the prefix to the default value (see ch. 4.1.1) */
>  	ibp->rvp.gid_prefix = IB_DEFAULT_GID_PREFIX;
>  	ibp->rvp.sm_lid = 0;
> -	/* Below should only set bits defined in OPA PortInfo.CapabilityMask */
> +	/*
> +	 * Below should only set bits defined in OPA PortInfo.CapabilityMask
> +	 * and PortInfo.CapabilityMask3
> +	 */
>  	ibp->rvp.port_cap_flags = IB_PORT_AUTO_MIGR_SUP |
>  		IB_PORT_CAP_MASK_NOTICE_SUP;
> +	ibp->rvp.port_cap3_flags = OPA_CAP_MASK3_IsSharedSpaceSupported |
> +				   OPA_CAP_MASK3_IsEthOnFabricSupported;
>  	ibp->rvp.pma_counter_select[0] = IB_PMA_PORT_XMIT_DATA;
>  	ibp->rvp.pma_counter_select[1] = IB_PMA_PORT_RCV_DATA;
>  	ibp->rvp.pma_counter_select[2] = IB_PMA_PORT_XMIT_PKTS;
> diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
> index 0d7c6bb..64bdd44 100644
> --- a/drivers/infiniband/sw/rdmavt/vt.c
> +++ b/drivers/infiniband/sw/rdmavt/vt.c
> @@ -202,8 +202,13 @@ static int rvt_modify_port(struct ib_device *ibdev, u8 port_num,
>  		return -EINVAL;
>
>  	rvp = rdi->ports[port_index];
> -	rvp->port_cap_flags |= props->set_port_cap_mask;
> -	rvp->port_cap_flags &= ~props->clr_port_cap_mask;
> +	if (port_modify_mask & IB_PORT_OPA_MASK_CHG) {
> +		rvp->port_cap3_flags |= props->set_port_cap_mask;
> +		rvp->port_cap3_flags &= ~props->clr_port_cap_mask;
> +	} else {
> +		rvp->port_cap_flags |= props->set_port_cap_mask;
> +		rvp->port_cap_flags &= ~props->clr_port_cap_mask;
> +	}
>
>  	if (props->set_port_cap_mask || props->clr_port_cap_mask)
>  		rdi->driver_f.cap_mask_chg(rdi, port_num);
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 785e927..6c4f6da 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -576,7 +576,8 @@ struct ib_device_modify {
>  enum ib_port_modify_flags {
>  	IB_PORT_SHUTDOWN		= 1,
>  	IB_PORT_INIT_TYPE		= (1<<2),
> -	IB_PORT_RESET_QKEY_CNTR		= (1<<3)
> +	IB_PORT_RESET_QKEY_CNTR		= (1<<3),
> +	IB_PORT_OPA_MASK_CHG		= (1<<4)

How will this flag be set?

>  };
>
>  struct ib_port_modify {
> diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
> index d0b9f91..0f18ffd 100644
> --- a/include/rdma/rdma_vt.h
> +++ b/include/rdma/rdma_vt.h
> @@ -75,6 +75,7 @@ struct rvt_ibport {
>  	__be64 mkey;
>  	u64 tid;
>  	u32 port_cap_flags;
> +	u16 port_cap3_flags;
>  	u32 pma_sample_start;
>  	u32 pma_sample_interval;
>  	__be16 pma_counter_select[5];
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--UTjKcilERHWBCdCp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlksSM4ACgkQ5GN7iDZy
WKfjWg/+K9ntousUxpH072kMvkRk1ipeqELtVJk4FMkG6Nm3U0kKdwo50qIItJMG
U7VakLM30hTCdTRB7k62FS5HLBdrrKtt6dMjIijNaXkUy4mDp6miqJEu8D2IJNfz
zsR55SLGh6Q97QC68CscHiC+wTYvCHZDJr3gYPP0Opku8VGri3ZI3qTeMwClgUFh
snQzs839GmUds3TZCyKZ1ejIMrWfkHlIOtUgnZpcJcYBCR++HVZr2PHq+1B6leAX
ECtLnFfvHbFop7tQfIOVpoEUvtI0zKJFXs5F6h7+P8dHsjSv1Jy86Jk48DacjnLg
43mSLjQkAdbJh28S2i1znVBmmMQggOM/l6hPIBozmG3AGajuki4ef+5Si3c1RuDQ
47nQMtGM2NRS2Wfl9GXbXxP9tfg1Akckjs2aTMF5oZxbWiJRf6H0Hi7Xou31I64k
zqcpzzUyM6yvugtbupIXSu0bTkzm4we750JU0+PpAkymZToDqpzlC31PHqpytPjK
NTvLUVdb9nEJqg/MZG+pYJBp15QZ6q6+7GNQ9ohjTmAjFD/5sgvXP4uOt8JK89oC
k3t2IgQPldBFneqmMlN92N7VDnnHG+nKM6RFTMdjxlrA4bt1S/eqEMYAFUxWi/7Z
bWZ3catb/fxdd/15cygBrfuyhpyB56LkFukZ9IbYMDOTC9GTFzc=
=i5uw
-----END PGP SIGNATURE-----

--UTjKcilERHWBCdCp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
