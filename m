From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 01/27] IB/Verbs: Implement new callback
 query_transport()
Date: Wed, 22 Apr 2015 11:02:55 -0400
Message-ID: <1429714975.45956.113.camel@redhat.com>
References: <5534B8C9.506@profitbricks.com>
	 <5534B981.1030302@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-4Qdk3KqeZU5P8dmCZwNL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5534B981.1030302-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-4Qdk3KqeZU5P8dmCZwNL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-04-20 at 10:32 +0200, Michael Wang wrote:
> Add new callback query_transport() and implement for each HW.

The more I think about it, the more I think we need to eliminate this
patch entirely.

The problem here is that, if we follow my suggestion, then we are going
to eliminate the query as an API function and replace the information it
gives us with a static port attribute bitmap.  If we do this patch, then
reform this patch to my idea later, we introduce a very short lived
API/ABI change in the kernel module interface that serves absolutely no
purpose.  Instead, let's do the bitmap creation first, update the
drivers to properly set the bitmap, then do all of the remaining reforms
you have here using that bitmap and completely skip the
query_transport() API item that will no longer serve a purpose.

> Mapping List:
> 		node-type	link-layer	old-transport	new-transport
> nes		RNIC		ETH		IWARP		IWARP
> amso1100	RNIC		ETH		IWARP		IWARP
> cxgb3   	RNIC		ETH		IWARP		IWARP
> cxgb4   	RNIC		ETH		IWARP		IWARP
> usnic   	USNIC_UDP	ETH		USNIC_UDP	USNIC_UDP
> ocrdma  	IB_CA		ETH		IB		IBOE
> mlx4    	IB_CA		IB/ETH		IB		IB/IBOE
> mlx5    	IB_CA		IB		IB		IB
> ehca    	IB_CA		IB		IB		IB
> ipath   	IB_CA		IB		IB		IB
> mthca   	IB_CA		IB		IB		IB
> qib     	IB_CA		IB		IB		IB
>=20
> Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  drivers/infiniband/core/device.c             |  1 +
>  drivers/infiniband/core/verbs.c              |  4 +++-
>  drivers/infiniband/hw/amso1100/c2_provider.c |  7 +++++++
>  drivers/infiniband/hw/cxgb3/iwch_provider.c  |  7 +++++++
>  drivers/infiniband/hw/cxgb4/provider.c       |  7 +++++++
>  drivers/infiniband/hw/ehca/ehca_hca.c        |  6 ++++++
>  drivers/infiniband/hw/ehca/ehca_iverbs.h     |  3 +++
>  drivers/infiniband/hw/ehca/ehca_main.c       |  1 +
>  drivers/infiniband/hw/ipath/ipath_verbs.c    |  7 +++++++
>  drivers/infiniband/hw/mlx4/main.c            | 10 ++++++++++
>  drivers/infiniband/hw/mlx5/main.c            |  7 +++++++
>  drivers/infiniband/hw/mthca/mthca_provider.c |  7 +++++++
>  drivers/infiniband/hw/nes/nes_verbs.c        |  6 ++++++
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |  1 +
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  6 ++++++
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |  3 +++
>  drivers/infiniband/hw/qib/qib_verbs.c        |  7 +++++++
>  drivers/infiniband/hw/usnic/usnic_ib_main.c  |  1 +
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  6 ++++++
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |  2 ++
>  include/rdma/ib_verbs.h                      |  7 ++++++-
>  21 files changed, 104 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/d=
evice.c
> index 18c1ece..a9587c4 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -76,6 +76,7 @@ static int ib_device_check_mandatory(struct ib_device *=
device)
>  	} mandatory_table[] =3D {
>  		IB_MANDATORY_FUNC(query_device),
>  		IB_MANDATORY_FUNC(query_port),
> +		IB_MANDATORY_FUNC(query_transport),
>  		IB_MANDATORY_FUNC(query_pkey),
>  		IB_MANDATORY_FUNC(query_gid),
>  		IB_MANDATORY_FUNC(alloc_pd),
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/ve=
rbs.c
> index f93eb8d..626c9cf 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -133,14 +133,16 @@ enum rdma_link_layer rdma_port_get_link_layer(struc=
t ib_device *device, u8 port_
>  	if (device->get_link_layer)
>  		return device->get_link_layer(device, port_num);
> =20
> -	switch (rdma_node_get_transport(device->node_type)) {
> +	switch (device->query_transport(device, port_num)) {
>  	case RDMA_TRANSPORT_IB:
>  		return IB_LINK_LAYER_INFINIBAND;
> +	case RDMA_TRANSPORT_IBOE:
>  	case RDMA_TRANSPORT_IWARP:
>  	case RDMA_TRANSPORT_USNIC:
>  	case RDMA_TRANSPORT_USNIC_UDP:
>  		return IB_LINK_LAYER_ETHERNET;
>  	default:
> +		BUG();
>  		return IB_LINK_LAYER_UNSPECIFIED;
>  	}
>  }
> diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infin=
iband/hw/amso1100/c2_provider.c
> index bdf3507..d46bbb0 100644
> --- a/drivers/infiniband/hw/amso1100/c2_provider.c
> +++ b/drivers/infiniband/hw/amso1100/c2_provider.c
> @@ -99,6 +99,12 @@ static int c2_query_port(struct ib_device *ibdev,
>  	return 0;
>  }
> =20
> +static enum rdma_transport_type
> +c2_query_transport(struct ib_device *device, u8 port_num)
> +{
> +	return RDMA_TRANSPORT_IWARP;
> +}
> +
>  static int c2_query_pkey(struct ib_device *ibdev,
>  			 u8 port, u16 index, u16 * pkey)
>  {
> @@ -801,6 +807,7 @@ int c2_register_device(struct c2_dev *dev)
>  	dev->ibdev.dma_device =3D &dev->pcidev->dev;
>  	dev->ibdev.query_device =3D c2_query_device;
>  	dev->ibdev.query_port =3D c2_query_port;
> +	dev->ibdev.query_transport =3D c2_query_transport;
>  	dev->ibdev.query_pkey =3D c2_query_pkey;
>  	dev->ibdev.query_gid =3D c2_query_gid;
>  	dev->ibdev.alloc_ucontext =3D c2_alloc_ucontext;
> diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infini=
band/hw/cxgb3/iwch_provider.c
> index 811b24a..09682e9e 100644
> --- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
> +++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> @@ -1232,6 +1232,12 @@ static int iwch_query_port(struct ib_device *ibdev=
,
>  	return 0;
>  }
> =20
> +static enum rdma_transport_type
> +iwch_query_transport(struct ib_device *device, u8 port_num)
> +{
> +	return RDMA_TRANSPORT_IWARP;
> +}
> +
>  static ssize_t show_rev(struct device *dev, struct device_attribute *att=
r,
>  			char *buf)
>  {
> @@ -1385,6 +1391,7 @@ int iwch_register_device(struct iwch_dev *dev)
>  	dev->ibdev.dma_device =3D &(dev->rdev.rnic_info.pdev->dev);
>  	dev->ibdev.query_device =3D iwch_query_device;
>  	dev->ibdev.query_port =3D iwch_query_port;
> +	dev->ibdev.query_transport =3D iwch_query_transport;
>  	dev->ibdev.query_pkey =3D iwch_query_pkey;
>  	dev->ibdev.query_gid =3D iwch_query_gid;
>  	dev->ibdev.alloc_ucontext =3D iwch_alloc_ucontext;
> diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/=
hw/cxgb4/provider.c
> index 66bd6a2..a445e0d 100644
> --- a/drivers/infiniband/hw/cxgb4/provider.c
> +++ b/drivers/infiniband/hw/cxgb4/provider.c
> @@ -390,6 +390,12 @@ static int c4iw_query_port(struct ib_device *ibdev, =
u8 port,
>  	return 0;
>  }
> =20
> +static enum rdma_transport_type
> +c4iw_query_transport(struct ib_device *device, u8 port_num)
> +{
> +	return RDMA_TRANSPORT_IWARP;
> +}
> +
>  static ssize_t show_rev(struct device *dev, struct device_attribute *att=
r,
>  			char *buf)
>  {
> @@ -506,6 +512,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
>  	dev->ibdev.dma_device =3D &(dev->rdev.lldi.pdev->dev);
>  	dev->ibdev.query_device =3D c4iw_query_device;
>  	dev->ibdev.query_port =3D c4iw_query_port;
> +	dev->ibdev.query_transport =3D c4iw_query_transport;
>  	dev->ibdev.query_pkey =3D c4iw_query_pkey;
>  	dev->ibdev.query_gid =3D c4iw_query_gid;
>  	dev->ibdev.alloc_ucontext =3D c4iw_alloc_ucontext;
> diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/h=
w/ehca/ehca_hca.c
> index 9ed4d25..d5a34a6 100644
> --- a/drivers/infiniband/hw/ehca/ehca_hca.c
> +++ b/drivers/infiniband/hw/ehca/ehca_hca.c
> @@ -242,6 +242,12 @@ query_port1:
>  	return ret;
>  }
> =20
> +enum rdma_transport_type
> +ehca_query_transport(struct ib_device *device, u8 port_num)
> +{
> +	return RDMA_TRANSPORT_IB;
> +}
> +
>  int ehca_query_sma_attr(struct ehca_shca *shca,
>  			u8 port, struct ehca_sma_attr *attr)
>  {
> diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniban=
d/hw/ehca/ehca_iverbs.h
> index 22f79af..cec945f 100644
> --- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
> +++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
> @@ -49,6 +49,9 @@ int ehca_query_device(struct ib_device *ibdev, struct i=
b_device_attr *props);
>  int ehca_query_port(struct ib_device *ibdev, u8 port,
>  		    struct ib_port_attr *props);
> =20
> +enum rdma_transport_type
> +ehca_query_transport(struct ib_device *device, u8 port_num);
> +
>  int ehca_query_sma_attr(struct ehca_shca *shca, u8 port,
>  			struct ehca_sma_attr *attr);
> =20
> diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/=
hw/ehca/ehca_main.c
> index cd8d290..60e0a09 100644
> --- a/drivers/infiniband/hw/ehca/ehca_main.c
> +++ b/drivers/infiniband/hw/ehca/ehca_main.c
> @@ -467,6 +467,7 @@ static int ehca_init_device(struct ehca_shca *shca)
>  	shca->ib_device.dma_device          =3D &shca->ofdev->dev;
>  	shca->ib_device.query_device        =3D ehca_query_device;
>  	shca->ib_device.query_port          =3D ehca_query_port;
> +	shca->ib_device.query_transport     =3D ehca_query_transport;
>  	shca->ib_device.query_gid           =3D ehca_query_gid;
>  	shca->ib_device.query_pkey          =3D ehca_query_pkey;
>  	/* shca->in_device.modify_device    =3D ehca_modify_device    */
> diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniba=
nd/hw/ipath/ipath_verbs.c
> index 44ea939..58d36e3 100644
> --- a/drivers/infiniband/hw/ipath/ipath_verbs.c
> +++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
> @@ -1638,6 +1638,12 @@ static int ipath_query_port(struct ib_device *ibde=
v,
>  	return 0;
>  }
> =20
> +static enum rdma_transport_type
> +ipath_query_transport(struct ib_device *device, u8 port_num)
> +{
> +	return RDMA_TRANSPORT_IB;
> +}
> +
>  static int ipath_modify_device(struct ib_device *device,
>  			       int device_modify_mask,
>  			       struct ib_device_modify *device_modify)
> @@ -2140,6 +2146,7 @@ int ipath_register_ib_device(struct ipath_devdata *=
dd)
>  	dev->query_device =3D ipath_query_device;
>  	dev->modify_device =3D ipath_modify_device;
>  	dev->query_port =3D ipath_query_port;
> +	dev->query_transport =3D ipath_query_transport;
>  	dev->modify_port =3D ipath_modify_port;
>  	dev->query_pkey =3D ipath_query_pkey;
>  	dev->query_gid =3D ipath_query_gid;
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/ml=
x4/main.c
> index b972c0b..e1424ad 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -420,6 +420,15 @@ static int mlx4_ib_query_port(struct ib_device *ibde=
v, u8 port,
>  	return __mlx4_ib_query_port(ibdev, port, props, 0);
>  }
> =20
> +static enum rdma_transport_type
> +mlx4_ib_query_transport(struct ib_device *device, u8 port_num)
> +{
> +	struct mlx4_dev *dev =3D to_mdev(device)->dev;
> +
> +	return dev->caps.port_mask[port_num] =3D=3D MLX4_PORT_TYPE_IB ?
> +		RDMA_TRANSPORT_IB : RDMA_TRANSPORT_IBOE;
> +}
> +
>  int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
>  			union ib_gid *gid, int netw_view)
>  {
> @@ -2201,6 +2210,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
> =20
>  	ibdev->ib_dev.query_device	=3D mlx4_ib_query_device;
>  	ibdev->ib_dev.query_port	=3D mlx4_ib_query_port;
> +	ibdev->ib_dev.query_transport	=3D mlx4_ib_query_transport;
>  	ibdev->ib_dev.get_link_layer	=3D mlx4_ib_port_link_layer;
>  	ibdev->ib_dev.query_gid		=3D mlx4_ib_query_gid;
>  	ibdev->ib_dev.query_pkey	=3D mlx4_ib_query_pkey;
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/ml=
x5/main.c
> index cc4ac1e..209c796 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -351,6 +351,12 @@ out:
>  	return err;
>  }
> =20
> +static enum rdma_transport_type
> +mlx5_ib_query_transport(struct ib_device *device, u8 port_num)
> +{
> +	return RDMA_TRANSPORT_IB;
> +}
> +
>  static int mlx5_ib_query_gid(struct ib_device *ibdev, u8 port, int index=
,
>  			     union ib_gid *gid)
>  {
> @@ -1336,6 +1342,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev=
)
> =20
>  	dev->ib_dev.query_device	=3D mlx5_ib_query_device;
>  	dev->ib_dev.query_port		=3D mlx5_ib_query_port;
> +	dev->ib_dev.query_transport	=3D mlx5_ib_query_transport;
>  	dev->ib_dev.query_gid		=3D mlx5_ib_query_gid;
>  	dev->ib_dev.query_pkey		=3D mlx5_ib_query_pkey;
>  	dev->ib_dev.modify_device	=3D mlx5_ib_modify_device;
> diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infin=
iband/hw/mthca/mthca_provider.c
> index 415f8e1..67ac6a4 100644
> --- a/drivers/infiniband/hw/mthca/mthca_provider.c
> +++ b/drivers/infiniband/hw/mthca/mthca_provider.c
> @@ -179,6 +179,12 @@ static int mthca_query_port(struct ib_device *ibdev,
>  	return err;
>  }
> =20
> +static enum rdma_transport_type
> +mthca_query_transport(struct ib_device *device, u8 port_num)
> +{
> +	return RDMA_TRANSPORT_IB;
> +}
> +
>  static int mthca_modify_device(struct ib_device *ibdev,
>  			       int mask,
>  			       struct ib_device_modify *props)
> @@ -1281,6 +1287,7 @@ int mthca_register_device(struct mthca_dev *dev)
>  	dev->ib_dev.dma_device           =3D &dev->pdev->dev;
>  	dev->ib_dev.query_device         =3D mthca_query_device;
>  	dev->ib_dev.query_port           =3D mthca_query_port;
> +	dev->ib_dev.query_transport      =3D mthca_query_transport;
>  	dev->ib_dev.modify_device        =3D mthca_modify_device;
>  	dev->ib_dev.modify_port          =3D mthca_modify_port;
>  	dev->ib_dev.query_pkey           =3D mthca_query_pkey;
> diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/h=
w/nes/nes_verbs.c
> index c0d0296..8df5b61 100644
> --- a/drivers/infiniband/hw/nes/nes_verbs.c
> +++ b/drivers/infiniband/hw/nes/nes_verbs.c
> @@ -606,6 +606,11 @@ static int nes_query_port(struct ib_device *ibdev, u=
8 port, struct ib_port_attr
>  	return 0;
>  }
> =20
> +static enum rdma_transport_type
> +nes_query_transport(struct ib_device *device, u8 port_num)
> +{
> +	return RDMA_TRANSPORT_IWARP;
> +}
> =20
>  /**
>   * nes_query_pkey
> @@ -3879,6 +3884,7 @@ struct nes_ib_device *nes_init_ofa_device(struct ne=
t_device *netdev)
>  	nesibdev->ibdev.dev.parent =3D &nesdev->pcidev->dev;
>  	nesibdev->ibdev.query_device =3D nes_query_device;
>  	nesibdev->ibdev.query_port =3D nes_query_port;
> +	nesibdev->ibdev.query_transport =3D nes_query_transport;
>  	nesibdev->ibdev.query_pkey =3D nes_query_pkey;
>  	nesibdev->ibdev.query_gid =3D nes_query_gid;
>  	nesibdev->ibdev.alloc_ucontext =3D nes_alloc_ucontext;
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infinib=
and/hw/ocrdma/ocrdma_main.c
> index 7a2b59a..9f4d182 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> @@ -244,6 +244,7 @@ static int ocrdma_register_device(struct ocrdma_dev *=
dev)
>  	/* mandatory verbs. */
>  	dev->ibdev.query_device =3D ocrdma_query_device;
>  	dev->ibdev.query_port =3D ocrdma_query_port;
> +	dev->ibdev.query_transport =3D ocrdma_query_transport;
>  	dev->ibdev.modify_port =3D ocrdma_modify_port;
>  	dev->ibdev.query_gid =3D ocrdma_query_gid;
>  	dev->ibdev.get_link_layer =3D ocrdma_link_layer;
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infini=
band/hw/ocrdma/ocrdma_verbs.c
> index 8771755..73bace4 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -187,6 +187,12 @@ int ocrdma_query_port(struct ib_device *ibdev,
>  	return 0;
>  }
> =20
> +enum rdma_transport_type
> +ocrdma_query_transport(struct ib_device *device, u8 port_num)
> +{
> +	return RDMA_TRANSPORT_IBOE;
> +}
> +
>  int ocrdma_modify_port(struct ib_device *ibdev, u8 port, int mask,
>  		       struct ib_port_modify *props)
>  {
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infini=
band/hw/ocrdma/ocrdma_verbs.h
> index b8f7853..4a81b63 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
> @@ -41,6 +41,9 @@ int ocrdma_query_port(struct ib_device *, u8 port, stru=
ct ib_port_attr *props);
>  int ocrdma_modify_port(struct ib_device *, u8 port, int mask,
>  		       struct ib_port_modify *props);
> =20
> +enum rdma_transport_type
> +ocrdma_query_transport(struct ib_device *device, u8 port_num);
> +
>  void ocrdma_get_guid(struct ocrdma_dev *, u8 *guid);
>  int ocrdma_query_gid(struct ib_device *, u8 port,
>  		     int index, union ib_gid *gid);
> diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/h=
w/qib/qib_verbs.c
> index 4a35998..caad665 100644
> --- a/drivers/infiniband/hw/qib/qib_verbs.c
> +++ b/drivers/infiniband/hw/qib/qib_verbs.c
> @@ -1650,6 +1650,12 @@ static int qib_query_port(struct ib_device *ibdev,=
 u8 port,
>  	return 0;
>  }
> =20
> +static enum rdma_transport_type
> +qib_query_transport(struct ib_device *device, u8 port_num)
> +{
> +	return RDMA_TRANSPORT_IB;
> +}
> +
>  static int qib_modify_device(struct ib_device *device,
>  			     int device_modify_mask,
>  			     struct ib_device_modify *device_modify)
> @@ -2184,6 +2190,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
>  	ibdev->query_device =3D qib_query_device;
>  	ibdev->modify_device =3D qib_modify_device;
>  	ibdev->query_port =3D qib_query_port;
> +	ibdev->query_transport =3D qib_query_transport;
>  	ibdev->modify_port =3D qib_modify_port;
>  	ibdev->query_pkey =3D qib_query_pkey;
>  	ibdev->query_gid =3D qib_query_gid;
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infini=
band/hw/usnic/usnic_ib_main.c
> index 0d0f986..03ea9f3 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> @@ -360,6 +360,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
> =20
>  	us_ibdev->ib_dev.query_device =3D usnic_ib_query_device;
>  	us_ibdev->ib_dev.query_port =3D usnic_ib_query_port;
> +	us_ibdev->ib_dev.query_transport =3D usnic_ib_query_transport;
>  	us_ibdev->ib_dev.query_pkey =3D usnic_ib_query_pkey;
>  	us_ibdev->ib_dev.query_gid =3D usnic_ib_query_gid;
>  	us_ibdev->ib_dev.get_link_layer =3D usnic_ib_port_link_layer;
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infin=
iband/hw/usnic/usnic_ib_verbs.c
> index 53bd6a2..ff9a5f7 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> @@ -348,6 +348,12 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 =
port,
>  	return 0;
>  }
> =20
> +enum rdma_transport_type
> +usnic_ib_query_transport(struct ib_device *device, u8 port_num)
> +{
> +	return RDMA_TRANSPORT_USNIC_UDP;
> +}
> +
>  int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
>  				int qp_attr_mask,
>  				struct ib_qp_init_attr *qp_init_attr)
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/infin=
iband/hw/usnic/usnic_ib_verbs.h
> index bb864f5..0b1633b 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
> @@ -27,6 +27,8 @@ int usnic_ib_query_device(struct ib_device *ibdev,
>  				struct ib_device_attr *props);
>  int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
>  				struct ib_port_attr *props);
> +enum rdma_transport_type
> +usnic_ib_query_transport(struct ib_device *device, u8 port_num);
>  int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
>  				int qp_attr_mask,
>  				struct ib_qp_init_attr *qp_init_attr);
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 65994a1..d54f91e 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -75,10 +75,13 @@ enum rdma_node_type {
>  };
> =20
>  enum rdma_transport_type {
> +	/* legacy for users */
>  	RDMA_TRANSPORT_IB,
>  	RDMA_TRANSPORT_IWARP,
>  	RDMA_TRANSPORT_USNIC,
> -	RDMA_TRANSPORT_USNIC_UDP
> +	RDMA_TRANSPORT_USNIC_UDP,
> +	/* new transport */
> +	RDMA_TRANSPORT_IBOE,
>  };
> =20
>  __attribute_const__ enum rdma_transport_type
> @@ -1501,6 +1504,8 @@ struct ib_device {
>  	int		           (*query_port)(struct ib_device *device,
>  						 u8 port_num,
>  						 struct ib_port_attr *port_attr);
> +	enum rdma_transport_type   (*query_transport)(struct ib_device *device,
> +						      u8 port_num);
>  	enum rdma_link_layer	   (*get_link_layer)(struct ib_device *device,
>  						     u8 port_num);
>  	int		           (*query_gid)(struct ib_device *device,


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-4Qdk3KqeZU5P8dmCZwNL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVN7gfAAoJELgmozMOVy/dw4cP/0srpwlfh/jx+v2TIBOHZ//A
luMhGgKvkt3HoRy+kA4FrogtfoOlhWi81pW4NCDJK2EIqFup8Qt3/YIcroG/GW2J
DDJ+MQMA38B5Jvz9/xZB5EgJN4Ftm4g47xl1A+rOM4QV/LPCvYAig80UwiLjfxDL
HvahbafoXj6AwrQWrzr7TuuPZF9wNXKzxDXN2m7PJIgeq0oyhribXv4kbSSbHWRs
yjc/JUMymREWe6R42kPyDR5n68+vitJWBqdjPcQS+uS8uRjlTVlJFytZYFOr09/p
yVxjPD+Kq7d0R6Q38foXxt5GrImnSxG08sQQKa6ybaAgTEqtnEvWz0e9rLnRK+cN
7gblq7nNWrnJkN9NVA0fFx6lxc2jDjLJfZbLyYQMqup2bMtCaTjgxOHiU9aS0FfO
KFGtV34xpji4kG26xAagoaWjw7Hhr3ufHuTAktkx66+kj0lDwAeirv3lbfR2kWNe
JCw+CQrirAGmsQSbwChS58UWSOnil/i1s8mk1t7nROOeSGm/eWxqbkSiQ3LRqgxM
zoeH6JIPWG5QwtGM1/2ytj/2VIEmoi0JsIYiY/7PAiNhEfzF9OJbbRCkCGVsGL+G
ffyNpg4fS9X5kFarbrnu3W3iZ8dci2iksoATMuSs5BWACCUwJ9If7HETOV9pMJ91
4pOfc2hwBtPRVWf8uZJA
=Ezsv
-----END PGP SIGNATURE-----

--=-4Qdk3KqeZU5P8dmCZwNL--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
