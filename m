From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v4 3/7] RDMA: Annotate create QP callers
Date: Thu, 18 Jan 2018 07:22:22 +0200
Message-ID: <20180118052222.GT13639@mtr-leonro.local>
References: <20180115151255.30167-1-leon@kernel.org>
 <20180115151255.30167-4-leon@kernel.org>
 <017301d38f1e$497ce8b0$dc76ba10$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="E1BPhOSoTthPQdPL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <017301d38f1e$497ce8b0$dc76ba10$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Jason Gunthorpe' <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--E1BPhOSoTthPQdPL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 16, 2018 at 05:03:56PM -0600, Steve Wise wrote:
>
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Update all callers to provide owner name through QP attribute
> > structure and connect create_qp with helper which supports
> > resource tracking.
> >
> > Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > ---
> >  drivers/infiniband/core/cma.c              | 1 +
> >  drivers/infiniband/core/mad.c              | 1 +
> >  drivers/infiniband/core/uverbs_cmd.c       | 3 +--
> >  drivers/infiniband/core/verbs.c            | 4 ++--
> >  drivers/infiniband/hw/mlx4/mad.c           | 1 +
> >  drivers/infiniband/hw/mlx4/qp.c            | 1 +
> >  drivers/infiniband/hw/mlx5/gsi.c           | 2 ++
> >  drivers/infiniband/ulp/ipoib/ipoib_cm.c    | 4 +++-
> >  drivers/infiniband/ulp/ipoib/ipoib_verbs.c | 1 +
> >  drivers/infiniband/ulp/srp/ib_srp.c        | 1 +
> >  drivers/infiniband/ulp/srpt/ib_srpt.c      | 1 +
> >  net/smc/smc_ib.c                           | 1 +
> >  12 files changed, 16 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> > index 30d1c32a816f..3810716ea65e 100644
> > --- a/drivers/infiniband/core/cma.c
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -858,6 +858,7 @@ int rdma_create_qp(struct rdma_cm_id *id, struct
> > ib_pd *pd,
> >  		return -EINVAL;
> >
> >  	qp_init_attr->port_num = id->port_num;
> > +	strncpy(qp_init_attr->comm, "rdma-cm", TASK_COMM_LEN);
>
>
> I think the above strncpy should be done only if the caller of
> rdma_create_qp() didn't fill in qp_init_attr->comm.  IE if the caller ULP
> fills it out, we want to see it.  Otherwise all kernel ULPs end up being
> "rdma-cm"...

Thanks Steve,

This patch won't be needed in next revision, I found a way to use
compiler to generate the kernel name.

>
> Stevo
>

--E1BPhOSoTthPQdPL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpgLw4ACgkQ5GN7iDZy
WKdjAhAAppCblr9gXlEMBd1VbdMhSxFwCEjKjrEcT/uFMHa30oSEgL/bbHikC8Ug
u0GDylRrF6zSxkj1KkanQEOA7ghF4Rd7HG/jDUtC5CZPX0l9gZfqs32I/Pp+wpSZ
ecPUJyOqmZfTJM6MaegXLlJnkuc0xUvTaKqz/LI05rhO0krFx3ETOxMQk6tkfpaS
UVJwig3xnPiRohY2Hzfv3mnkyJHvPHfa8SkHF22iacq8kzMp5zpSYDJLXYG+zVs8
LkXpHUQNgtVBKmWdqtC8HysazdErjPfZZB/IMStSFNbNRpYf5F3z7724fhXNomE1
OAjQkkXxcAu5XYLAOBPkb4kq7bP6p/qQ7VJ3zGitJuFftNsbquJSf8h87BeI+HDm
GnjOERVoFnDy1RcN0KrdLSYQFHAIyabU6GQtsBHRuFg3/ieJtFKI+8QMg8iYA4pa
uQcrKkQmS9WMyF5t6LobX/8ygQc8O35TZ0XqNcZPm7NVlUhGtpWQK5Psd/Co7NuY
yLvNk4qhFeL2JRZYtul1MgeBki6KRI7NP18tmjZ/Ri0txjbdHYKYwCUQOcKHUqz3
Ovm0qOBiq+4UzOmnfoOR8zrlk46656u33jaxMgL9fNRftkLPCNBgpmmpdVfVdkMx
81eVzSKP1ti50mJOEo0Qin6VKbvwc7ZJZwU+IZCNlaizuOs0VkM=
=UccI
-----END PGP SIGNATURE-----

--E1BPhOSoTthPQdPL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
