From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 06/19] IB/core: Add max_mad_size to ib_device_attr
Date: Tue, 24 Feb 2015 09:16:25 -0500
Message-ID: <1424787385.4847.16.camel@redhat.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
	 <1423092585-26692-7-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Vtvkv+VHQgTzGGsVpA9j"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423092585-26692-7-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-Vtvkv+VHQgTzGGsVpA9j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-02-04 at 18:29 -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Change all IB drivers to report the max MAD size.
> Add check to verify that all devices support at least IB_MGMT_MAD_SIZE
>=20
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> ---
>=20
> Changes from V3:
> 	Fix ehca compile found with 0-day build
>=20
>  drivers/infiniband/core/mad.c                | 6 ++++++
>  drivers/infiniband/hw/amso1100/c2_rnic.c     | 1 +
>  drivers/infiniband/hw/cxgb3/iwch_provider.c  | 1 +
>  drivers/infiniband/hw/cxgb4/provider.c       | 1 +
>  drivers/infiniband/hw/ehca/ehca_hca.c        | 3 +++
>  drivers/infiniband/hw/ipath/ipath_verbs.c    | 1 +
>  drivers/infiniband/hw/mlx4/main.c            | 1 +
>  drivers/infiniband/hw/mlx5/main.c            | 1 +
>  drivers/infiniband/hw/mthca/mthca_provider.c | 2 ++
>  drivers/infiniband/hw/nes/nes_verbs.c        | 1 +
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  | 1 +
>  drivers/infiniband/hw/qib/qib_verbs.c        | 1 +
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 2 ++
>  include/rdma/ib_mad.h                        | 1 +
>  include/rdma/ib_verbs.h                      | 1 +
>  15 files changed, 24 insertions(+)
>=20
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.=
c
> index 819b794..a6a33cf 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -2924,6 +2924,12 @@ static int ib_mad_port_open(struct ib_device *devi=
ce,
>  	char name[sizeof "ib_mad123"];
>  	int has_smi;
> =20
> +	if (device->cached_dev_attrs.max_mad_size < IB_MGMT_MAD_SIZE) {
> +		dev_err(&device->dev, "Min MAD size for device is %u\n",
> +			IB_MGMT_MAD_SIZE);
> +		return -EFAULT;
> +	}
> +

The printk message here is not very informative and it qualifies as an
error.  Someone reading that for the first time in the dmesg output and
wondering why their device isn't working will be confused if they don't
know about the mad size changes you are making here.  Something like
"max supported MAD size (%u) < min required by ib_mad (%u), ignoring dev
\n"

>  	/* Create new device info */
>  	port_priv =3D kzalloc(sizeof *port_priv, GFP_KERNEL);
>  	if (!port_priv) {
> diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c b/drivers/infiniban=
d/hw/amso1100/c2_rnic.c
> index d2a6d96..63322c0 100644
> --- a/drivers/infiniband/hw/amso1100/c2_rnic.c
> +++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
> @@ -197,6 +197,7 @@ static int c2_rnic_query(struct c2_dev *c2dev, struct=
 ib_device_attr *props)
>  	props->max_srq_sge         =3D 0;
>  	props->max_pkeys           =3D 0;
>  	props->local_ca_ack_delay  =3D 0;
> +	props->max_mad_size        =3D IB_MGMT_MAD_SIZE;
> =20
>   bail2:
>  	vq_repbuf_free(c2dev, reply);
> diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infini=
band/hw/cxgb3/iwch_provider.c
> index 811b24a..b8a80aa0 100644
> --- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
> +++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> @@ -1174,6 +1174,7 @@ static int iwch_query_device(struct ib_device *ibde=
v,
>  	props->max_pd =3D dev->attr.max_pds;
>  	props->local_ca_ack_delay =3D 0;
>  	props->max_fast_reg_page_list_len =3D T3_MAX_FASTREG_DEPTH;
> +	props->max_mad_size =3D IB_MGMT_MAD_SIZE;
> =20
>  	return 0;
>  }
> diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/=
hw/cxgb4/provider.c
> index 66bd6a2..299c70c 100644
> --- a/drivers/infiniband/hw/cxgb4/provider.c
> +++ b/drivers/infiniband/hw/cxgb4/provider.c
> @@ -332,6 +332,7 @@ static int c4iw_query_device(struct ib_device *ibdev,
>  	props->max_pd =3D T4_MAX_NUM_PD;
>  	props->local_ca_ack_delay =3D 0;
>  	props->max_fast_reg_page_list_len =3D t4_max_fr_depth(use_dsgl);
> +	props->max_mad_size =3D IB_MGMT_MAD_SIZE;
> =20
>  	return 0;
>  }
> diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/h=
w/ehca/ehca_hca.c
> index 9ed4d25..6166146 100644
> --- a/drivers/infiniband/hw/ehca/ehca_hca.c
> +++ b/drivers/infiniband/hw/ehca/ehca_hca.c
> @@ -40,6 +40,7 @@
>   */
> =20
>  #include <linux/gfp.h>
> +#include <rdma/ib_mad.h>
> =20
>  #include "ehca_tools.h"
>  #include "ehca_iverbs.h"
> @@ -133,6 +134,8 @@ int ehca_query_device(struct ib_device *ibdev, struct=
 ib_device_attr *props)
>  		if (rblock->hca_cap_indicators & cap_mapping[i + 1])
>  			props->device_cap_flags |=3D cap_mapping[i];
> =20
> +	props->max_mad_size =3D IB_MGMT_MAD_SIZE;
> +
>  query_device1:
>  	ehca_free_fw_ctrlblock(rblock);
> =20
> diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniba=
nd/hw/ipath/ipath_verbs.c
> index 44ea939..4c6474c 100644
> --- a/drivers/infiniband/hw/ipath/ipath_verbs.c
> +++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
> @@ -1538,6 +1538,7 @@ static int ipath_query_device(struct ib_device *ibd=
ev,
>  	props->max_mcast_qp_attach =3D ib_ipath_max_mcast_qp_attached;
>  	props->max_total_mcast_qp_attach =3D props->max_mcast_qp_attach *
>  		props->max_mcast_grp;
> +	props->max_mad_size =3D IB_MGMT_MAD_SIZE;
> =20
>  	return 0;
>  }
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/ml=
x4/main.c
> index 57ecc5b..88326a7 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -229,6 +229,7 @@ static int mlx4_ib_query_device(struct ib_device *ibd=
ev,
>  	props->max_total_mcast_qp_attach =3D props->max_mcast_qp_attach *
>  					   props->max_mcast_grp;
>  	props->max_map_per_fmr =3D dev->dev->caps.max_fmr_maps;
> +	props->max_mad_size        =3D IB_MGMT_MAD_SIZE;
> =20
>  out:
>  	kfree(in_mad);
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/ml=
x5/main.c
> index 8a87404..24a0a54 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -243,6 +243,7 @@ static int mlx5_ib_query_device(struct ib_device *ibd=
ev,
>  	props->max_total_mcast_qp_attach =3D props->max_mcast_qp_attach *
>  					   props->max_mcast_grp;
>  	props->max_map_per_fmr =3D INT_MAX; /* no limit in ConnectIB */
> +	props->max_mad_size        =3D IB_MGMT_MAD_SIZE;
> =20
>  #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
>  	if (dev->mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
> diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infin=
iband/hw/mthca/mthca_provider.c
> index 415f8e1..236c0df 100644
> --- a/drivers/infiniband/hw/mthca/mthca_provider.c
> +++ b/drivers/infiniband/hw/mthca/mthca_provider.c
> @@ -123,6 +123,8 @@ static int mthca_query_device(struct ib_device *ibdev=
,
>  		props->max_map_per_fmr =3D
>  			(1 << (32 - ilog2(mdev->limits.num_mpts))) - 1;
> =20
> +	props->max_mad_size =3D IB_MGMT_MAD_SIZE;
> +
>  	err =3D 0;
>   out:
>  	kfree(in_mad);
> diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/h=
w/nes/nes_verbs.c
> index c0d0296..93e67e2 100644
> --- a/drivers/infiniband/hw/nes/nes_verbs.c
> +++ b/drivers/infiniband/hw/nes/nes_verbs.c
> @@ -555,6 +555,7 @@ static int nes_query_device(struct ib_device *ibdev, =
struct ib_device_attr *prop
>  	props->max_qp_init_rd_atom =3D props->max_qp_rd_atom;
>  	props->atomic_cap =3D IB_ATOMIC_NONE;
>  	props->max_map_per_fmr =3D 1;
> +	props->max_mad_size =3D IB_MGMT_MAD_SIZE;
> =20
>  	return 0;
>  }
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infini=
band/hw/ocrdma/ocrdma_verbs.c
> index fb8d8c4..7ae0a22 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -103,6 +103,7 @@ int ocrdma_query_device(struct ib_device *ibdev, stru=
ct ib_device_attr *attr)
>  	attr->local_ca_ack_delay =3D dev->attr.local_ca_ack_delay;
>  	attr->max_fast_reg_page_list_len =3D dev->attr.max_pages_per_frmr;
>  	attr->max_pkeys =3D 1;
> +	attr->max_mad_size =3D IB_MGMT_MAD_SIZE;
>  	return 0;
>  }
> =20
> diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/h=
w/qib/qib_verbs.c
> index 9bcfbd8..5d6447b 100644
> --- a/drivers/infiniband/hw/qib/qib_verbs.c
> +++ b/drivers/infiniband/hw/qib/qib_verbs.c
> @@ -1591,6 +1591,7 @@ static int qib_query_device(struct ib_device *ibdev=
,
>  	props->max_mcast_qp_attach =3D ib_qib_max_mcast_qp_attached;
>  	props->max_total_mcast_qp_attach =3D props->max_mcast_qp_attach *
>  		props->max_mcast_grp;
> +	props->max_mad_size =3D IB_MGMT_MAD_SIZE;
> =20
>  	return 0;
>  }
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infin=
iband/hw/usnic/usnic_ib_verbs.c
> index 53bd6a2..b72ad7f 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> @@ -22,6 +22,7 @@
> =20
>  #include <rdma/ib_user_verbs.h>
>  #include <rdma/ib_addr.h>
> +#include <rdma/ib_mad.h>
> =20
>  #include "usnic_abi.h"
>  #include "usnic_ib.h"
> @@ -296,6 +297,7 @@ int usnic_ib_query_device(struct ib_device *ibdev,
>  	props->max_mcast_qp_attach =3D 0;
>  	props->max_total_mcast_qp_attach =3D 0;
>  	props->max_map_per_fmr =3D 0;
> +	props->max_mad_size =3D IB_MGMT_MAD_SIZE;
>  	/* Owned by Userspace
>  	 * max_qp_wr, max_sge, max_sge_rd, max_cqe */
>  	mutex_unlock(&us_ibdev->usdev_lock);
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index 9c89939..5823016 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -135,6 +135,7 @@ enum {
>  	IB_MGMT_SA_DATA =3D 200,
>  	IB_MGMT_DEVICE_HDR =3D 64,
>  	IB_MGMT_DEVICE_DATA =3D 192,
> +	IB_MGMT_MAD_SIZE =3D IB_MGMT_MAD_HDR + IB_MGMT_MAD_DATA,
>  };
> =20
>  struct ib_mad_hdr {
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 0116e4b..64d3479 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -210,6 +210,7 @@ struct ib_device_attr {
>  	int			sig_prot_cap;
>  	int			sig_guard_cap;
>  	struct ib_odp_caps	odp_caps;
> +	u32			max_mad_size;
>  };
> =20
>  enum ib_mtu {


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-Vtvkv+VHQgTzGGsVpA9j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJU7Ie5AAoJELgmozMOVy/dzAsQAIS74flLr02Vsolp9Lhbggz8
BCIrflyoj+brsLGAxD9Eva1Ebby9kyHKzXpdGJFAr2/xz9/VadLDKRzbVfja+D95
lJyIVTLhqK6vZxBdQhQfSP7p1SYXN5NmoE8RniByw+0+H1E+IHLxlOT4Qpw1c3/p
6Vc3oCoWoPnxyaXk9AazzkK1yJBUisjB/R49pjSTxcC5Pv7dnPGF+UGdd+kTD8ja
8+4S9axuPK2cxU0aAQIRF5TCEkiQnojoNvT8WEQx+yOdj0+Hl8LUuDa4ab4fjgd5
CspUYjlpGUgYpTWBxQ34u3GnsUOsqDxSA+Ii+6/Zzm6dM6B9e2svjNJF1HA7Ha29
TKbCvmH6h+UD+rvnGIgouEPRWb4koMWt9uvenp7FNdAenfGFusqYcDlwexvrFTZW
LuJMWsD4+wxV8t6mTcJuCXkwmQ/FZpaUG7qrRn5Uq3jgpArJH6e5Rv20j0MT16FK
THGVkLHt0BhxeWMsOFbk6b8b7oYjTYMjQ7KkAckGjJtq+N+40H6ZrL29XiNiQgcv
8hb1ODaBqhHxP9Ib6HgRNC5+nyrrBkLN6M3Z9C+oIRYLiZL4EAKrMM8WNpPkIoej
k0claoOx0pmnvPtBqNOfoWUD6gdkZfrac/0SmZr7yA3IMre5Fj4wWDpepIfns81p
p6OuvAbvIbujdA4XHbh+
=sdOw
-----END PGP SIGNATURE-----

--=-Vtvkv+VHQgTzGGsVpA9j--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
