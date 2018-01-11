From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 4/6] RDMA/{cma, ucma}: Refactor to have
 transport specific checks
Date: Thu, 11 Jan 2018 00:55:57 +0000
Message-ID: <VI1PR0502MB30089B0F846E8A50643DBE33D1160@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20180108150448.29069-1-leon@kernel.org>
 <20180108150448.29069-5-leon@kernel.org> <20180110233748.GS4518@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180110233748.GS4518-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg-uk2M96/98Pc@public.gmane.org]
> Sent: Wednesday, January 10, 2018 5:38 PM
> To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; RDMA mailing list <linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Parav Pandit
> <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Dasaratharaman Chandramouli
> <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>;
> Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 4/6] RDMA/{cma, ucma}: Refactor to have
> transport specific checks
>=20
> On Mon, Jan 08, 2018 at 05:04:46PM +0200, Leon Romanovsky wrote:
> > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Code is refactored to perform transport specific checks for OPA, IB,
> > RoCE to be done in core routine. Wherever possible, it is better to
> > avoid spreading transport specific code in multiple kernel modules.
> >
> > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > drivers/infiniband/core/cma.c  | 11 ++++++++++-
> > drivers/infiniband/core/ucma.c |  9 +--------
> >  2 files changed, 11 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/cma.c
> > b/drivers/infiniband/core/cma.c index f1e425da926d..68223bd56b53
> > 100644
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -2522,14 +2522,23 @@ int rdma_set_ib_path(struct rdma_cm_id *id,
> >  		     struct sa_path_rec *path_rec)
> >  {
> >  	struct rdma_id_private *id_priv;
> > +	struct sa_path_rec *in_path_rec;
> > +	struct sa_path_rec opa;
> >  	int ret;
> >
> > +	if (rdma_cap_opa_ah(id->device, id->port_num)) {
> > +		sa_convert_path_ib_to_opa(&opa, path_rec);
> > +		in_path_rec =3D &opa;
> > +	} else {
> > +		in_path_rec =3D path_rec;
> > +	}
> > +
> >  	id_priv =3D container_of(id, struct rdma_id_private, id);
> >  	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED,
> >  			   RDMA_CM_ROUTE_RESOLVED))
> >  		return -EINVAL;
> >
> > -	id->route.path_rec =3D kmemdup(path_rec, sizeof(*path_rec),
> > +	id->route.path_rec =3D kmemdup(in_path_rec, sizeof(*in_path_rec),
> >  				     GFP_KERNEL);
> >  	if (!id->route.path_rec) {
> >  		ret =3D -ENOMEM;
> > diff --git a/drivers/infiniband/core/ucma.c
> > b/drivers/infiniband/core/ucma.c index 6d32af27bac6..7b25226b608e
> > 100644
> > +++ b/drivers/infiniband/core/ucma.c
> > @@ -1227,14 +1227,7 @@ static int ucma_set_ib_path(struct ucma_context
> *ctx,
> >  	sa_path.rec_type =3D SA_PATH_REC_TYPE_IB;
> >  	ib_sa_unpack_path(path_data->path_rec, &sa_path);
> >
> > -	if (rdma_cap_opa_ah(ctx->cm_id->device, ctx->cm_id->port_num)) {
> > -		struct sa_path_rec opa;
> > -
> > -		sa_convert_path_ib_to_opa(&opa, &sa_path);
> > -		ret =3D rdma_set_ib_path(ctx->cm_id, &opa);
> > -	} else {
> > -		ret =3D rdma_set_ib_path(ctx->cm_id, &sa_path);
> > -	}
> > +	ret =3D rdma_set_ib_path(ctx->cm_id, &sa_path);
>=20
>=20
> No, this is not right
>=20
> sa_convert_path_ib_to_opa is misnamed and the usage here is arguably
> misplaced.
>=20
> It is converting the internal OPA path record into a compability path rec=
ord. The
> ONLY place a compatability path record should be used is at the uapi boun=
dary
> when copying to userspace.
>=20
> It is certainly not the right direction to have the core APIs degrade the=
 path
> record.
>=20
> If anything should be fixed here, it is to move the degradation closer to=
 the
> actual copy_to_user.
>=20
> Why was it put here anyhow? I don't see a uapi boundary?
>=20
>From git blame result, it was put in below patch.
57520751445b837c20a8e658e3dae3a7e7ddf45c
IB/SA: Add OPA path record type
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
