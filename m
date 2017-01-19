From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 5/5] IB: Query port through the core instead of
 directly calling the driver handler
Date: Thu, 19 Jan 2017 06:06:04 +0000
Message-ID: <HE1PR0502MB3004E6D28AED46720C428576D17E0@HE1PR0502MB3004.eurprd05.prod.outlook.com>
References: <20170119054102.20135-1-leon@kernel.org>
 <20170119054102.20135-6-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170119054102.20135-6-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Minor nit for safer code.

> -----Original Message-----

> diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c
> b/drivers/infiniband/hw/mlx4/alias_GUID.c
> index 06020c5..4648374 100644
> --- a/drivers/infiniband/hw/mlx4/alias_GUID.c
> +++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
> @@ -499,6 +499,7 @@ static int set_guid_rec(struct ib_device *ibdev,
>  	struct list_head *head =3D
>  		&dev->sriov.alias_guid.ports_guid[port - 1].cb_list;
>=20
> +	memset(&attr, 0, sizeof(struct ib_port_attr));

Can you please change above code to,
	memset(&attr, 0, sizeof(attr));

> diff --git a/drivers/infiniband/hw/mlx4/sysfs.c
> b/drivers/infiniband/hw/mlx4/sysfs.c
> index 69fb5ba..5835165 100644
> --- a/drivers/infiniband/hw/mlx4/sysfs.c
> +++ b/drivers/infiniband/hw/mlx4/sysfs.c
> @@ -226,6 +226,7 @@ static int add_port_entries(struct mlx4_ib_dev
> *device, int port_num)
>  	int ret =3D 0 ;
>  	struct ib_port_attr attr;
>=20
> +	memset(&attr, 0, sizeof(struct ib_port_attr));
Ditto.
	memset(&attr, 0, sizeof(attr));


> a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 4e8e78f..176417b 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -174,7 +174,7 @@ static int mlx5_query_port_roce(struct ib_device
>=20
>  	for (port =3D 1; port <=3D MLX5_CAP_GEN(dev->mdev, num_ports);
> port++) {
> +		memset(pprops, 0, sizeof(struct ib_port_attr));
Here too.
		memset(pprops, 0, sizeof(*pprops));

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
