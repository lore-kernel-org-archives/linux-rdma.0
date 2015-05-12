From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] IB/core: Formalize the creation of immutable per
 port data within the ib_device object
Date: Tue, 12 May 2015 11:25:01 -0400
Message-ID: <1431444301.43876.34.camel@redhat.com>
References: <1431395218-27693-1-git-send-email-ira.weiny@intel.com>
	 <1431395218-27693-3-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-zbZ8P08q6XTvH6DxgmHI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431395218-27693-3-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-zbZ8P08q6XTvH6DxgmHI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-11 at 21:46 -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> As of commit 5eb620c81ce3 "IB/core: Add helpers for uncached GID and P_Ke=
y
> searches"; pkey_tbl_len and gid_tbl_len are immutable data which are stor=
ed in
> the ib_device.
>=20
> The per port core capability flags to be added later are also immutable d=
ata to
> be stored in the ib_device object.
>=20
> In preparation for this create a structure for per port immutable data an=
d
> place the pkey and gid table lengths within this structure.
>=20
> This type of data requires a new call back "port_immutable" parameter to
> ib_register_device to allow each driver to create this data as appropriat=
e.
> This callback is added to ib_register_device rather than as a new device
> function because the callback should only be used when devices are first
> registered.
>=20
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/device.c             | 56 ++++++++++++++--------=
------
>  drivers/infiniband/hw/amso1100/c2_provider.c | 20 +++++++++-
>  drivers/infiniband/hw/cxgb3/iwch_provider.c  | 20 +++++++++-
>  drivers/infiniband/hw/cxgb4/provider.c       | 20 +++++++++-
>  drivers/infiniband/hw/ehca/ehca_main.c       | 20 +++++++++-
>  drivers/infiniband/hw/ipath/ipath_verbs.c    | 20 +++++++++-
>  drivers/infiniband/hw/mlx4/main.c            | 20 +++++++++-
>  drivers/infiniband/hw/mlx5/main.c            | 20 +++++++++-
>  drivers/infiniband/hw/mthca/mthca_provider.c | 20 +++++++++-
>  drivers/infiniband/hw/nes/nes_verbs.c        | 21 ++++++++++-
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c   | 20 +++++++++-
>  drivers/infiniband/hw/qib/qib_verbs.c        | 21 ++++++++++-
>  drivers/infiniband/hw/usnic/usnic_ib_main.c  | 20 +++++++++-
>  include/rdma/ib_verbs.h                      | 13 +++++--
>  14 files changed, 268 insertions(+), 43 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/d=
evice.c
> index b360350..e1e5c8d 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -223,42 +223,42 @@ static int add_client_context(struct ib_device *dev=
ice, struct ib_client *client
>  	return 0;
>  }
> =20
> -static int read_port_table_lengths(struct ib_device *device)
> +static int read_port_immutable(struct ib_device *device,
> +			       int (*port_immutable)(struct ib_device *,
> +						     u8,
> +						     struct ib_port_immutable *))
>  {
> -	struct ib_port_attr *tprops =3D NULL;
>  	int num_ports, ret =3D -ENOMEM;
> -	u8 port_index;
> -
> -	tprops =3D kmalloc(sizeof *tprops, GFP_KERNEL);
> -	if (!tprops)
> -		goto out;
> +	u8 port;
> =20
>  	num_ports =3D end_port(device) - start_port(device) + 1;
> =20
> -	device->pkey_tbl_len =3D kmalloc(sizeof *device->pkey_tbl_len * num_por=
ts,
> -				       GFP_KERNEL);
> -	device->gid_tbl_len =3D kmalloc(sizeof *device->gid_tbl_len * num_ports=
,
> -				      GFP_KERNEL);
> -	if (!device->pkey_tbl_len || !device->gid_tbl_len)
> +	device->port_immutable =3D kmalloc(sizeof(*device->port_immutable)
> +						* (num_ports+1),
> +					 GFP_KERNEL);
> +	if (!device->port_immutable)
>  		goto err;
> =20
> -	for (port_index =3D 0; port_index < num_ports; ++port_index) {
> -		ret =3D ib_query_port(device, port_index + start_port(device),
> -					tprops);
> +	for (port =3D 0; port <=3D num_ports; ++port) {
> +
> +		if (port =3D=3D 0 && device->node_type !=3D RDMA_NODE_IB_SWITCH)
> +			continue;
> +
> +		if (port > 0 && device->node_type =3D=3D RDMA_NODE_IB_SWITCH)
> +			break;
> +
> +		ret =3D port_immutable(device, port,
> +				     &device->port_immutable[port]);
>  		if (ret)
>  			goto err;
> -		device->pkey_tbl_len[port_index] =3D tprops->pkey_tbl_len;
> -		device->gid_tbl_len[port_index]  =3D tprops->gid_tbl_len;
>  	}
> =20
>  	ret =3D 0;
>  	goto out;
> =20
>  err:
> -	kfree(device->gid_tbl_len);
> -	kfree(device->pkey_tbl_len);
> +	kfree(device->port_immutable);
>  out:
> -	kfree(tprops);
>  	return ret;
>  }
> =20
> @@ -273,7 +273,9 @@ out:
>   */
>  int ib_register_device(struct ib_device *device,
>  		       int (*port_callback)(struct ib_device *,
> -					    u8, struct kobject *))
> +					    u8, struct kobject *),
> +		       int (*port_immutable)(struct ib_device *, u8,
> +					     struct ib_port_immutable *))

I'm having a hard time getting past how ugly this is.  Passing callbacks
as arguments to a registration function should be a last resort.  I
would rather see this added to the device mandatory list (and it *is*
mandatory, we use it without checking for NULL).  In truth, I'd rather
see both of those moved to the driver callback struct.  They can be
placed at the end, after a comment that says something like "These are
single use entry points for initialization, keep them away from the rest
of the entry points to help prevent growing the entry point list beyond
any more cachelines that needed for the more commonly used entry
points".  I would find that much preferable to this.

>  {
>  	int ret;
> =20
> @@ -295,7 +297,7 @@ int ib_register_device(struct ib_device *device,
>  	spin_lock_init(&device->event_handler_lock);
>  	spin_lock_init(&device->client_data_lock);
> =20
> -	ret =3D read_port_table_lengths(device);
> +	ret =3D read_port_immutable(device, port_immutable);
>  	if (ret) {
>  		printk(KERN_WARNING "Couldn't create table lengths cache for device %s=
\n",
>  		       device->name);
> @@ -306,8 +308,7 @@ int ib_register_device(struct ib_device *device,
>  	if (ret) {
>  		printk(KERN_WARNING "Couldn't register device %s with driver model\n",
>  		       device->name);
> -		kfree(device->gid_tbl_len);
> -		kfree(device->pkey_tbl_len);
> +		kfree(device->port_immutable);
>  		goto out;
>  	}
> =20
> @@ -349,8 +350,7 @@ void ib_unregister_device(struct ib_device *device)
> =20
>  	list_del(&device->core_list);
> =20
> -	kfree(device->gid_tbl_len);
> -	kfree(device->pkey_tbl_len);
> +	kfree(device->port_immutable);
> =20
>  	mutex_unlock(&device_mutex);
> =20
> @@ -678,7 +678,7 @@ int ib_find_gid(struct ib_device *device, union ib_gi=
d *gid,
>  	int ret, port, i;
> =20
>  	for (port =3D start_port(device); port <=3D end_port(device); ++port) {
> -		for (i =3D 0; i < device->gid_tbl_len[port - start_port(device)]; ++i)=
 {
> +		for (i =3D 0; i < device->port_immutable[port].gid_tbl_len; ++i) {
>  			ret =3D ib_query_gid(device, port, i, &tmp_gid);
>  			if (ret)
>  				return ret;
> @@ -710,7 +710,7 @@ int ib_find_pkey(struct ib_device *device,
>  	u16 tmp_pkey;
>  	int partial_ix =3D -1;
> =20
> -	for (i =3D 0; i < device->pkey_tbl_len[port_num - start_port(device)]; =
++i) {
> +	for (i =3D 0; i < device->port_immutable[port_num].pkey_tbl_len; ++i) {
>  		ret =3D ib_query_pkey(device, port_num, i, &tmp_pkey);
>  		if (ret)
>  			return ret;
> diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infin=
iband/hw/amso1100/c2_provider.c
> index 6fe329a..a29c37f 100644
> --- a/drivers/infiniband/hw/amso1100/c2_provider.c
> +++ b/drivers/infiniband/hw/amso1100/c2_provider.c
> @@ -763,6 +763,24 @@ static struct net_device *c2_pseudo_netdev_init(stru=
ct c2_dev *c2dev)
>  	return netdev;
>  }
> =20
> +static int c2_port_immutable(struct ib_device *ibdev, u8 port_num,
> +			     struct ib_port_immutable *immutable)
> +{
> +	struct ib_port_attr attr;
> +	int err;
> +
> +	err =3D c2_query_port(ibdev, port_num, &attr);
> +	if (err)
> +		return err;
> +
> +	memset(immutable, 0, sizeof(*immutable));
> +
> +	immutable->pkey_tbl_len =3D attr.pkey_tbl_len;
> +	immutable->gid_tbl_len =3D attr.gid_tbl_len;
> +
> +	return 0;
> +}
> +
>  int c2_register_device(struct c2_dev *dev)
>  {
>  	int ret =3D -ENOMEM;
> @@ -855,7 +873,7 @@ int c2_register_device(struct c2_dev *dev)
>  	dev->ibdev.iwcm->create_listen =3D c2_service_create;
>  	dev->ibdev.iwcm->destroy_listen =3D c2_service_destroy;
> =20
> -	ret =3D ib_register_device(&dev->ibdev, NULL);
> +	ret =3D ib_register_device(&dev->ibdev, NULL, c2_port_immutable);
>  	if (ret)
>  		goto out_free_iwcm;
> =20
> diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infini=
band/hw/cxgb3/iwch_provider.c
> index 298d1ca..a1635e5 100644
> --- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
> +++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> @@ -1349,6 +1349,24 @@ static struct device_attribute *iwch_class_attribu=
tes[] =3D {
>  	&dev_attr_board_id,
>  };
> =20
> +static int iwch_port_immutable(struct ib_device *ibdev, u8 port_num,
> +			       struct ib_port_immutable *immutable)
> +{
> +	struct ib_port_attr attr;
> +	int err;
> +
> +	err =3D iwch_query_port(ibdev, port_num, &attr);
> +	if (err)
> +		return err;
> +
> +	memset(immutable, 0, sizeof(*immutable));
> +
> +	immutable->pkey_tbl_len =3D attr.pkey_tbl_len;
> +	immutable->gid_tbl_len =3D attr.gid_tbl_len;
> +
> +	return 0;
> +}
> +
>  int iwch_register_device(struct iwch_dev *dev)
>  {
>  	int ret;
> @@ -1441,7 +1459,7 @@ int iwch_register_device(struct iwch_dev *dev)
>  	dev->ibdev.iwcm->rem_ref =3D iwch_qp_rem_ref;
>  	dev->ibdev.iwcm->get_qp =3D iwch_get_qp;
> =20
> -	ret =3D ib_register_device(&dev->ibdev, NULL);
> +	ret =3D ib_register_device(&dev->ibdev, NULL, iwch_port_immutable);
>  	if (ret)
>  		goto bail1;
> =20
> diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/=
hw/cxgb4/provider.c
> index f52ee63..2281726 100644
> --- a/drivers/infiniband/hw/cxgb4/provider.c
> +++ b/drivers/infiniband/hw/cxgb4/provider.c
> @@ -471,6 +471,24 @@ static struct device_attribute *c4iw_class_attribute=
s[] =3D {
>  	&dev_attr_board_id,
>  };
> =20
> +static int c4iw_port_immutable(struct ib_device *ibdev, u8 port_num,
> +			       struct ib_port_immutable *immutable)
> +{
> +	struct ib_port_attr attr;
> +	int err;
> +
> +	err =3D c4iw_query_port(ibdev, port_num, &attr);
> +	if (err)
> +		return err;
> +
> +	memset(immutable, 0, sizeof(*immutable));
> +
> +	immutable->pkey_tbl_len =3D attr.pkey_tbl_len;
> +	immutable->gid_tbl_len =3D attr.gid_tbl_len;
> +
> +	return 0;
> +}
> +
>  int c4iw_register_device(struct c4iw_dev *dev)
>  {
>  	int ret;
> @@ -563,7 +581,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
>  	dev->ibdev.iwcm->rem_ref =3D c4iw_qp_rem_ref;
>  	dev->ibdev.iwcm->get_qp =3D c4iw_get_qp;
> =20
> -	ret =3D ib_register_device(&dev->ibdev, NULL);
> +	ret =3D ib_register_device(&dev->ibdev, NULL, c4iw_port_immutable);
>  	if (ret)
>  		goto bail1;
> =20
> diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/=
hw/ehca/ehca_main.c
> index 321545b..0ad9307 100644
> --- a/drivers/infiniband/hw/ehca/ehca_main.c
> +++ b/drivers/infiniband/hw/ehca/ehca_main.c
> @@ -431,6 +431,24 @@ init_node_guid1:
>  	return ret;
>  }
> =20
> +static int ehca_port_immutable(struct ib_device *ibdev, u8 port_num,
> +			       struct ib_port_immutable *immutable)
> +{
> +	struct ib_port_attr attr;
> +	int err;
> +
> +	err =3D ehca_query_port(ibdev, port_num, &attr);
> +	if (err)
> +		return err;
> +
> +	memset(immutable, 0, sizeof(*immutable));
> +
> +	immutable->pkey_tbl_len =3D attr.pkey_tbl_len;
> +	immutable->gid_tbl_len =3D attr.gid_tbl_len;
> +
> +	return 0;
> +}
> +
>  static int ehca_init_device(struct ehca_shca *shca)
>  {
>  	int ret;
> @@ -801,7 +819,7 @@ static int ehca_probe(struct platform_device *dev)
>  		goto probe5;
>  	}
> =20
> -	ret =3D ib_register_device(&shca->ib_device, NULL);
> +	ret =3D ib_register_device(&shca->ib_device, NULL, ehca_port_immutable)=
;
>  	if (ret) {
>  		ehca_err(&shca->ib_device,
>  			 "ib_register_device() failed ret=3D%i", ret);
> diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniba=
nd/hw/ipath/ipath_verbs.c
> index 34b94c3a..2f81cf2 100644
> --- a/drivers/infiniband/hw/ipath/ipath_verbs.c
> +++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
> @@ -1986,6 +1986,24 @@ static int disable_timer(struct ipath_devdata *dd)
>  	return 0;
>  }
> =20
> +static int ipath_port_immutable(struct ib_device *ibdev, u8 port_num,
> +			        struct ib_port_immutable *immutable)
> +{
> +	struct ib_port_attr attr;
> +	int err;
> +
> +	err =3D ipath_query_port(ibdev, port_num, &attr);
> +	if (err)
> +		return err;
> +
> +	memset(immutable, 0, sizeof(*immutable));
> +
> +	immutable->pkey_tbl_len =3D attr.pkey_tbl_len;
> +	immutable->gid_tbl_len =3D attr.gid_tbl_len;
> +
> +	return 0;
> +}
> +
>  /**
>   * ipath_register_ib_device - register our device with the infiniband co=
re
>   * @dd: the device data structure
> @@ -2190,7 +2208,7 @@ int ipath_register_ib_device(struct ipath_devdata *=
dd)
>  	snprintf(dev->node_desc, sizeof(dev->node_desc),
>  		 IPATH_IDSTR " %s", init_utsname()->nodename);
> =20
> -	ret =3D ib_register_device(dev, NULL);
> +	ret =3D ib_register_device(dev, NULL, ipath_port_immutable);
>  	if (ret)
>  		goto err_reg;
> =20
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/ml=
x4/main.c
> index 26678d2..57e1a5c 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -2124,6 +2124,24 @@ static void mlx4_ib_free_eqs(struct mlx4_dev *dev,=
 struct mlx4_ib_dev *ibdev)
>  	kfree(ibdev->eq_table);
>  }
> =20
> +static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
> +			       struct ib_port_immutable *immutable)
> +{
> +	struct ib_port_attr attr;
> +	int err;
> +
> +	err =3D mlx4_ib_query_port(ibdev, port_num, &attr);
> +	if (err)
> +		return err;
> +
> +	memset(immutable, 0, sizeof(*immutable));
> +
> +	immutable->pkey_tbl_len =3D attr.pkey_tbl_len;
> +	immutable->gid_tbl_len =3D attr.gid_tbl_len;
> +
> +	return 0;
> +}
> +
>  static void *mlx4_ib_add(struct mlx4_dev *dev)
>  {
>  	struct mlx4_ib_dev *ibdev;
> @@ -2353,7 +2371,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
>  	for (j =3D 1; j <=3D ibdev->dev->caps.num_ports; j++)
>  		atomic64_set(&iboe->mac[j - 1], ibdev->dev->caps.def_mac[j]);
> =20
> -	if (ib_register_device(&ibdev->ib_dev, NULL))
> +	if (ib_register_device(&ibdev->ib_dev, NULL, mlx4_port_immutable))
>  		goto err_steer_free_bitmap;
> =20
>  	if (mlx4_ib_mad_init(ibdev))
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/ml=
x5/main.c
> index 8dec380..9bf2564 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -1188,6 +1188,24 @@ static void destroy_dev_resources(struct mlx5_ib_r=
esources *devr)
>  	mlx5_ib_dealloc_pd(devr->p0);
>  }
> =20
> +static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
> +			       struct ib_port_immutable *immutable)
> +{
> +	struct ib_port_attr attr;
> +	int err;
> +
> +	err =3D mlx5_ib_query_port(ibdev, port_num, &attr);
> +	if (err)
> +		return err;
> +
> +	memset(immutable, 0, sizeof(*immutable));
> +
> +	immutable->pkey_tbl_len =3D attr.pkey_tbl_len;
> +	immutable->gid_tbl_len =3D attr.gid_tbl_len;
> +
> +	return 0;
> +}
> +
>  static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
>  {
>  	struct mlx5_ib_dev *dev;
> @@ -1317,7 +1335,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev=
)
>  	if (err)
>  		goto err_rsrc;
> =20
> -	err =3D ib_register_device(&dev->ib_dev, NULL);
> +	err =3D ib_register_device(&dev->ib_dev, NULL, mlx5_port_immutable);
>  	if (err)
>  		goto err_odp;
> =20
> diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infin=
iband/hw/mthca/mthca_provider.c
> index ad1cca3..fc59611 100644
> --- a/drivers/infiniband/hw/mthca/mthca_provider.c
> +++ b/drivers/infiniband/hw/mthca/mthca_provider.c
> @@ -1250,6 +1250,24 @@ out:
>  	return err;
>  }
> =20
> +static int mthca_port_immutable(struct ib_device *ibdev, u8 port_num,
> +			        struct ib_port_immutable *immutable)
> +{
> +	struct ib_port_attr attr;
> +	int err;
> +
> +	err =3D mthca_query_port(ibdev, port_num, &attr);
> +	if (err)
> +		return err;
> +
> +	memset(immutable, 0, sizeof(*immutable));
> +
> +	immutable->pkey_tbl_len =3D attr.pkey_tbl_len;
> +	immutable->gid_tbl_len =3D attr.gid_tbl_len;
> +
> +	return 0;
> +}
> +
>  int mthca_register_device(struct mthca_dev *dev)
>  {
>  	int ret;
> @@ -1357,7 +1375,7 @@ int mthca_register_device(struct mthca_dev *dev)
> =20
>  	mutex_init(&dev->cap_mask_mutex);
> =20
> -	ret =3D ib_register_device(&dev->ib_dev, NULL);
> +	ret =3D ib_register_device(&dev->ib_dev, NULL, mthca_port_immutable);
>  	if (ret)
>  		return ret;
> =20
> diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/h=
w/nes/nes_verbs.c
> index 027f6d1..7cd3c1d 100644
> --- a/drivers/infiniband/hw/nes/nes_verbs.c
> +++ b/drivers/infiniband/hw/nes/nes_verbs.c
> @@ -4000,6 +4000,24 @@ void nes_destroy_ofa_device(struct nes_ib_device *=
nesibdev)
>  }
> =20
>=20
> +static int nes_port_immutable(struct ib_device *ibdev, u8 port_num,
> +			      struct ib_port_immutable *immutable)
> +{
> +	struct ib_port_attr attr;
> +	int err;
> +
> +	err =3D nes_query_port(ibdev, port_num, &attr);
> +	if (err)
> +		return err;
> +
> +	memset(immutable, 0, sizeof(*immutable));
> +
> +	immutable->pkey_tbl_len =3D attr.pkey_tbl_len;
> +	immutable->gid_tbl_len =3D attr.gid_tbl_len;
> +
> +	return 0;
> +}
> +
>  /**
>   * nes_register_ofa_device
>   */
> @@ -4010,7 +4028,8 @@ int nes_register_ofa_device(struct nes_ib_device *n=
esibdev)
>  	struct nes_adapter *nesadapter =3D nesdev->nesadapter;
>  	int i, ret;
> =20
> -	ret =3D ib_register_device(&nesvnic->nesibdev->ibdev, NULL);
> +	ret =3D ib_register_device(&nesvnic->nesibdev->ibdev, NULL,
> +				 nes_port_immutable);
>  	if (ret) {
>  		return ret;
>  	}
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infinib=
and/hw/ocrdma/ocrdma_main.c
> index 85d99e9..11f2e32 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> @@ -202,6 +202,24 @@ static enum rdma_link_layer ocrdma_link_layer(struct=
 ib_device *device,
>  	return IB_LINK_LAYER_ETHERNET;
>  }
> =20
> +static int ocrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
> +			         struct ib_port_immutable *immutable)
> +{
> +	struct ib_port_attr attr;
> +	int err;
> +
> +	err =3D ocrdma_query_port(ibdev, port_num, &attr);
> +	if (err)
> +		return err;
> +
> +	memset(immutable, 0, sizeof(*immutable));
> +
> +	immutable->pkey_tbl_len =3D attr.pkey_tbl_len;
> +	immutable->gid_tbl_len =3D attr.gid_tbl_len;
> +
> +	return 0;
> +}
> +
>  static int ocrdma_register_device(struct ocrdma_dev *dev)
>  {
>  	strlcpy(dev->ibdev.name, "ocrdma%d", IB_DEVICE_NAME_MAX);
> @@ -302,7 +320,7 @@ static int ocrdma_register_device(struct ocrdma_dev *=
dev)
>  		dev->ibdev.destroy_srq =3D ocrdma_destroy_srq;
>  		dev->ibdev.post_srq_recv =3D ocrdma_post_srq_recv;
>  	}
> -	return ib_register_device(&dev->ibdev, NULL);
> +	return ib_register_device(&dev->ibdev, NULL, ocrdma_port_immutable);
>  }
> =20
>  static int ocrdma_alloc_resources(struct ocrdma_dev *dev)
> diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/h=
w/qib/qib_verbs.c
> index 9fd4b28..1c60eb2 100644
> --- a/drivers/infiniband/hw/qib/qib_verbs.c
> +++ b/drivers/infiniband/hw/qib/qib_verbs.c
> @@ -2046,6 +2046,24 @@ static void init_ibport(struct qib_pportdata *ppd)
>  	RCU_INIT_POINTER(ibp->qp1, NULL);
>  }
> =20
> +static int qib_port_immutable(struct ib_device *ibdev, u8 port_num,
> +			      struct ib_port_immutable *immutable)
> +{
> +	struct ib_port_attr attr;
> +	int err;
> +
> +	err =3D qib_query_port(ibdev, port_num, &attr);
> +	if (err)
> +		return err;
> +
> +	memset(immutable, 0, sizeof(*immutable));
> +
> +	immutable->pkey_tbl_len =3D attr.pkey_tbl_len;
> +	immutable->gid_tbl_len =3D attr.gid_tbl_len;
> +
> +	return 0;
> +}
> +
>  /**
>   * qib_register_ib_device - register our device with the infiniband core
>   * @dd: the device data structure
> @@ -2238,7 +2256,8 @@ int qib_register_ib_device(struct qib_devdata *dd)
>  	snprintf(ibdev->node_desc, sizeof(ibdev->node_desc),
>  		 "Intel Infiniband HCA %s", init_utsname()->nodename);
> =20
> -	ret =3D ib_register_device(ibdev, qib_create_port_files);
> +	ret =3D ib_register_device(ibdev, qib_create_port_files,
> +				 qib_port_immutable);
>  	if (ret)
>  		goto err_reg;
> =20
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infini=
band/hw/usnic/usnic_ib_main.c
> index bd9f364..848ba1b 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> @@ -300,6 +300,24 @@ static struct notifier_block usnic_ib_inetaddr_notif=
ier =3D {
>  };
>  /* End of inet section*/
> =20
> +static int usnic_port_immutable(struct ib_device *ibdev, u8 port_num,
> +			        struct ib_port_immutable *immutable)
> +{
> +	struct ib_port_attr attr;
> +	int err;
> +
> +	err =3D usnic_ib_query_port(ibdev, port_num, &attr);
> +	if (err)
> +		return err;
> +
> +	memset(immutable, 0, sizeof(*immutable));
> +
> +	immutable->pkey_tbl_len =3D attr.pkey_tbl_len;
> +	immutable->gid_tbl_len =3D attr.gid_tbl_len;
> +
> +	return 0;
> +}
> +
>  /* Start of PF discovery section */
>  static void *usnic_ib_device_add(struct pci_dev *dev)
>  {
> @@ -386,7 +404,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
>  	us_ibdev->ib_dev.get_dma_mr =3D usnic_ib_get_dma_mr;
> =20
>=20
> -	if (ib_register_device(&us_ibdev->ib_dev, NULL))
> +	if (ib_register_device(&us_ibdev->ib_dev, NULL, usnic_port_immutable))
>  		goto err_fwd_dealloc;
> =20
>  	usnic_fwd_set_mtu(us_ibdev->ufdev, us_ibdev->netdev->mtu);
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 8d59479..fe7efbe 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1481,6 +1481,12 @@ struct ib_dma_mapping_ops {
> =20
>  struct iw_cm_verbs;
> =20
> +/* Per port immutable data */
> +struct ib_port_immutable {
> +	int                           pkey_tbl_len;
> +	int                           gid_tbl_len;
> +};
> +
>  struct ib_device {
>  	struct device                *dma_device;
> =20
> @@ -1494,8 +1500,7 @@ struct ib_device {
>  	struct list_head              client_data_list;
> =20
>  	struct ib_cache               cache;
> -	int                          *pkey_tbl_len;
> -	int                          *gid_tbl_len;
> +	struct ib_port_immutable     *port_immutable;
> =20
>  	int			      num_comp_vectors;
> =20
> @@ -1699,7 +1704,9 @@ void ib_dealloc_device(struct ib_device *device);
> =20
>  int ib_register_device(struct ib_device *device,
>  		       int (*port_callback)(struct ib_device *,
> -					    u8, struct kobject *));
> +					    u8, struct kobject *),
> +		       int (*port_immutable)(struct ib_device *, u8,
> +					     struct ib_port_immutable *));
>  void ib_unregister_device(struct ib_device *device);
> =20
>  int ib_register_client   (struct ib_client *client);


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-zbZ8P08q6XTvH6DxgmHI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUhtNAAoJELgmozMOVy/d6boP/ixxwlPp+Zwussk4ZMRF/ZxR
ieTvEbAVXUjZ+IgDkMO2jIjzZR2sE45p6NeDHPsulKLL6FGuR6d2pDlUySkmzw+l
emXE+abedbscCehDJ/LTEaBHK4xqvOD0SfmdCUSMSdfdE4/0XGEh6sfg0bfBvps5
VKVvhAFra7A5tbiGU6aA5HIgzFQohfWkknvglXRbq4PmsFbrfxSpkJMjZB81hUu5
Nd+dFDM9s2UzJB1Dg+oXzgZStomfoHj3F4zfJh1PRgWC326u8sHB5xNgmIYHUj1t
IrQU5a2x2vkNy/R4m+uEVruVsmqVdz3jojn3HKKQ1ZoglEaoNyderiq6bFcrLTn2
ckurrSqKPqgxTJIlebxCgPsKsSL5QXF2tmKsvuOuF9GOmgU/tVsnHAQMUQKpDQSp
iHK7pMrtsE8GnbFvQOx7rJMbtU6eMfW4Q6tseO1aGDc8o0iuzqxI8IME5oCCp/dv
rEQMPEQH9rcRWq12Mj3vpn+IOEeiRt2JehY3J+YuegrYKux0rC9dUTdgA2h7fEt6
feg0qdsY8k/Hy+g73Eum/07n3mqrBcnAumxxqWtCTcNgJiyZXbQD6YvTRPGatblX
36RMh/CYysv21eXewYgk5ExmDVEVQ2HTCOD7GTM2hjW0vYY+qdqxb/mHo7cXhNLE
yJe6jEoQkpTI8fQBYh3v
=WQLS
-----END PGP SIGNATURE-----

--=-zbZ8P08q6XTvH6DxgmHI--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
