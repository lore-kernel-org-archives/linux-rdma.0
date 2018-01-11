From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 4/6] RDMA/{cma, ucma}: Refactor to have
 transport specific checks
Date: Thu, 11 Jan 2018 08:05:37 +0200
Message-ID: <20180111060537.GO7368@mtr-leonro.local>
References: <20180108150448.29069-1-leon@kernel.org>
 <20180108150448.29069-5-leon@kernel.org>
 <20180110233748.GS4518@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hnsKUeImFCk/igEn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180110233748.GS4518-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--hnsKUeImFCk/igEn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 10, 2018 at 04:37:48PM -0700, Jason Gunthorpe wrote:
> On Mon, Jan 08, 2018 at 05:04:46PM +0200, Leon Romanovsky wrote:
> > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Code is refactored to perform transport specific checks for OPA, IB,
> > RoCE to be done in core routine. Wherever possible, it is better to avoid
> > spreading transport specific code in multiple kernel modules.
> >
> > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >  drivers/infiniband/core/cma.c  | 11 ++++++++++-
> >  drivers/infiniband/core/ucma.c |  9 +--------
> >  2 files changed, 11 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> > index f1e425da926d..68223bd56b53 100644
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
> > +		in_path_rec = &opa;
> > +	} else {
> > +		in_path_rec = path_rec;
> > +	}
> > +
> >  	id_priv = container_of(id, struct rdma_id_private, id);
> >  	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED,
> >  			   RDMA_CM_ROUTE_RESOLVED))
> >  		return -EINVAL;
> >
> > -	id->route.path_rec = kmemdup(path_rec, sizeof(*path_rec),
> > +	id->route.path_rec = kmemdup(in_path_rec, sizeof(*in_path_rec),
> >  				     GFP_KERNEL);
> >  	if (!id->route.path_rec) {
> >  		ret = -ENOMEM;
> > diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> > index 6d32af27bac6..7b25226b608e 100644
> > +++ b/drivers/infiniband/core/ucma.c
> > @@ -1227,14 +1227,7 @@ static int ucma_set_ib_path(struct ucma_context *ctx,
> >  	sa_path.rec_type = SA_PATH_REC_TYPE_IB;
> >  	ib_sa_unpack_path(path_data->path_rec, &sa_path);
> >
> > -	if (rdma_cap_opa_ah(ctx->cm_id->device, ctx->cm_id->port_num)) {
> > -		struct sa_path_rec opa;
> > -
> > -		sa_convert_path_ib_to_opa(&opa, &sa_path);
> > -		ret = rdma_set_ib_path(ctx->cm_id, &opa);
> > -	} else {
> > -		ret = rdma_set_ib_path(ctx->cm_id, &sa_path);
> > -	}
> > +	ret = rdma_set_ib_path(ctx->cm_id, &sa_path);
>
>
> No, this is not right
>
> sa_convert_path_ib_to_opa is misnamed and the usage here is arguably
> misplaced.
>
> It is converting the internal OPA path record into a compability path
> record. The ONLY place a compatability path record should be used is
> at the uapi boundary when copying to userspace.
>
> It is certainly not the right direction to have the core APIs
> degrade the path record.
>
> If anything should be fixed here, it is to move the degradation closer
> to the actual copy_to_user.
>
> Why was it put here anyhow? I don't see a uapi boundary?

As Parav wrote, it was added in commit 57520751445b ("IB/SA: Add OPA
path record type") and it looks like this sa_convert_path_ib_to_opa()
can be deleted, because there is the same conversion in ucma_query_path().

Thanks

>
> Jason

--hnsKUeImFCk/igEn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpW/rAACgkQ5GN7iDZy
WKfXCRAAunlVuejwdXoGydb3AIEJMsXtBVaFkZAvAnQhv2iCVOAVNGFBIqy4laMN
LRaAYEJK6l9YdenFj5bXGLzKb4UGvrzgNufr28D8Ouf39p8ZDywTUzvvfx/YC/o1
iiBeGh4Fi1fzvUqJ4xMp8pZaRlJIxnp5kTHcUaPVEds7AIrPbe2INR1UlgQNY8Ps
wIzSIsabY+MjvvtVSHrPVIUuiolVYte10a2fQAVY8T7DK+p7EpY+KFAvI1cV+xLf
NXcGAtWG4e9sF2qUqIIBVh+27U46xFNcmVSQWEP+qYByujuk5E2+2wirD//LugvN
qioThL7WHJj1RznJLnoDclkauPEdnaJUGdaY3XvSy4QqkD+Tam+jmV9gHHHEcfF5
qgUnBz4Oj/Wx085KkAAws/+1+fm3sbsZQGMRvI2g+ADW1sWmZI/wDBNNohvVDw/Z
ZZa1zgImWyIwNbjRO3CuLpKS0muowAq74Q4ynjdBfs28SKBk6vQ+OJqKcKdtZUH1
deIkvFE9K28UdQ2hWfK7g5xt/6bKRgNo1rq/tkixKMitAdl/A5cTy/dV/gR/88AI
TcFFlRtWy7d+sEnOBCQO6drEGqKsvu47JK9Tr3xCJys2pnACLv2bMMD6gNz1/KJo
xMTimou3pkaZKSOldzaFNN1UBPqyC1zq/Ky0WebFnjLtWZ40weM=
=BRQy
-----END PGP SIGNATURE-----

--hnsKUeImFCk/igEn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
