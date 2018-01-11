From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 5/6] RDMA/cma: Fix setting RoCE specific path
 record fields
Date: Thu, 11 Jan 2018 13:57:45 +0000
Message-ID: <VI1PR0502MB3008703D935BF70B474ECD90D1160@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20180108150448.29069-1-leon@kernel.org>
 <20180108150448.29069-6-leon@kernel.org> <20180111050453.GB16668@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111050453.GB16668-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg-uk2M96/98Pc@public.gmane.org]
> Sent: Wednesday, January 10, 2018 11:05 PM
> To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; RDMA mailing list <linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Parav Pandit
> <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 5/6] RDMA/cma: Fix setting RoCE specific pa=
th
> record fields
>=20
> On Mon, Jan 08, 2018 at 05:04:47PM +0200, Leon Romanovsky wrote:
> > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > rdma_set_ib_path() missed setting path record fields for RoCE
> > transport when RoCE transport support was added.
> >
> > This results into setting incorrect ndev, destination mac address,
> > incorrect GID type etc errors. This patch uses recently introduced
> > helper function to setup such RoCE specific path record fields.
> >
> > Fixes: 3c86aa70bf67 ("RDMA/cm: Add RDMA CM support for IBoE devices")
> > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > drivers/infiniband/core/cma.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/drivers/infiniband/core/cma.c
> > b/drivers/infiniband/core/cma.c index 68223bd56b53..f4c6c2cbc585
> > 100644
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -2523,6 +2523,7 @@ int rdma_set_ib_path(struct rdma_cm_id *id,  {
> >  	struct rdma_id_private *id_priv;
> >  	struct sa_path_rec *in_path_rec;
> > +	struct net_device *ndev;
> >  	struct sa_path_rec opa;
> >  	int ret;
> >
> > @@ -2545,6 +2546,18 @@ int rdma_set_ib_path(struct rdma_cm_id *id,
> >  		goto err;
> >  	}
> >
> > +	if (rdma_protocol_roce(id->device, id->port_num)) {
> > +		ndev =3D cma_iboe_set_path_rec_l2_fields(id_priv);
> > +		if (!ndev) {
> > +			ret =3D -ENODEV;
> > +			kfree(id->route.path_rec);
> > +			id->route.path_rec =3D NULL;
> > +			goto err;
> > +		} else {
> > +			dev_put(ndev);
> > +		}
> > +	}
>=20
> I revised this slightly, I didn't like mixing goto error unwind and in-li=
ned error
> unwind in the same function, not the pointless else block.
>=20
> Please check my work:
>=20
> Author: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date:   Mon Jan 8 17:04:47 2018 +0200
>=20
>     RDMA/cma: Fix rdma_cm raw IB path setting for RoCE
>=20
>     rdma_set_ib_path() missed setting path record fields for RoCE
>     transport when RoCE support was added.
>=20
>     This results in setting incorrect ndev, destination mac address,
>     incorrect GID type etc errors when user space attempts to set a raw
>     IB path using the roce IB path compatibility mapping from userspace.
>=20
>     Fixes: 3c86aa70bf67 ("RDMA/cm: Add RDMA CM support for IBoE devices")
>     Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>     Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>     Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>     Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.=
c index
> 5c158cda08e31d..30d1c32a816f91 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -2521,6 +2521,7 @@ int rdma_set_ib_path(struct rdma_cm_id *id,
>  		     struct sa_path_rec *path_rec)
>  {
>  	struct rdma_id_private *id_priv;
> +	struct net_device *ndev;
>  	int ret;
>=20
>  	id_priv =3D container_of(id, struct rdma_id_private, id); @@ -2535,8
> +2536,21 @@ int rdma_set_ib_path(struct rdma_cm_id *id,
>  		goto err;
>  	}
>=20
> +	if (rdma_protocol_roce(id->device, id->port_num)) {
> +		ndev =3D cma_iboe_set_path_rec_l2_fields(id_priv);
> +		if (!ndev) {
> +			ret =3D -ENODEV;
> +			goto err_free;
> +		}
> +		dev_put(ndev);
> +	}
> +
>  	id->route.num_paths =3D 1;
>  	return 0;
> +
> +err_free:
> +	kfree(id->route.path_rec);
> +	id->route.path_rec =3D NULL;
>  err:
>  	cma_comp_exch(id_priv, RDMA_CM_ROUTE_RESOLVED,
> RDMA_CM_ADDR_RESOLVED);
>  	return ret;
Looks good.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
