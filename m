From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/mlx5; Remove redundant allocation warning
 print
Date: Fri, 19 Jan 2018 12:58:40 +0200
Message-ID: <20180119105840.GA1393@mtr-leonro.local>
References: <20180118123424.21062-1-leon@kernel.org>
 <20180118200211.GA17561@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180118200211.GA17561@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 18, 2018 at 10:02:12PM +0200, Yuval Shaia wrote:
> On Thu, Jan 18, 2018 at 02:34:24PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The kmalloc() failure to allocate memory generates enough information
> > and doesn't need to be accompanied by another driver print.
> >
> > Fixes: d69a24e03659 ("IB/mlx5: Move IB event processing onto a workqueue")
>
> Didn't found it in:
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/leon/linux-rdma/
> branch rdma-next and didn't find it.
> Where should i look?

In official place:
https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=for-next&id=d69a24e036596877ce08c25ab8e63a202412fd9e

>
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/mlx5/main.c | 20 +++++++++-----------
> >  1 file changed, 9 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> > index f282e281eff2..91688352b5d7 100644
> > --- a/drivers/infiniband/hw/mlx5/main.c
> > +++ b/drivers/infiniband/hw/mlx5/main.c
> > @@ -3345,19 +3345,17 @@ static void mlx5_ib_event(struct mlx5_core_dev *dev, void *context,
> >  	struct mlx5_ib_event_work *work;
> >
> >  	work = kmalloc(sizeof(*work), GFP_ATOMIC);
> > -	if (work) {
> > -		INIT_WORK(&work->work, mlx5_ib_handle_event);
> > -		work->dev = dev;
> > -		work->param = param;
> > -		work->context = context;
> > -		work->event = event;
> > -
> > -		queue_work(mlx5_ib_event_wq, &work->work);
> > +	if (!work)
> >  		return;
> > -	}
> >
> > -	dev_warn(&dev->pdev->dev, "%s: mlx5_dev_event: %d, with param: %lu dropped, couldn't allocate memory.\n",
> > -		 __func__, event, param);
> > +	INIT_WORK(&work->work, mlx5_ib_handle_event);
> > +	work->dev = dev;
> > +	work->param = param;
> > +	work->context = context;
> > +	work->event = event;
> > +
> > +	queue_work(mlx5_ib_event_wq, &work->work);
> > +	return;
>
> We don't really need this last "return", right?

Right, I'll remove it now.

Thanks

>
> >  }
> >
> >  static int set_has_smi_cap(struct mlx5_ib_dev *dev)
> > --
> > 2.15.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlphz2AACgkQ5GN7iDZy
WKdPLA//dH02xkTOKvvzC0pTn1EVMYsM6vprCyDP4ZcmE+HeVnrydXMzbJQAzawz
jfKcoV+i7So3zJOnU0s6a8dfloA4p9SfRsXnUM9vqIt0k0BzT9T4ppuLQ37FgHl+
Uoe9RMwjAZoqjxGH+jnf/evP2mX0ysfjv4pRS+n+tWpJqQBHt/IWWS5iWqFNO+m7
VDpM5eYlb9/laUvCuSN6h06BwRszi0NFXkZ8PEiz8OyGXjUJw5TJD/UJ0OKgq0kk
t/W4l4xfdG0zzzdveDfUMv3i4oCX3G7fdLsTDlUAYmXODixhUJ1vxVH3rqshIGqb
f+Sr+bm30x/efNsQMkGTYovco0S1auTFqN2XsQk1sXehO656cgnQrsY19plqX2yT
lw6aEQxtRAiSbSMsQYboWro/zTF+r66g7uzTxwi/zFhvJwLb4cSvAgl5Z6IjRyRy
07RHyqAb8uM3IPnOWkAHwmCWtnNLeCXyl09ovs2DbfnY2ib+KuWhESKGsPj/BNeV
4Jvxc+Ki8xxyp5671zFUm/CeIAQ/66lbx3CvrARrzIRH9f6jZHSD/wh+wpOdI/Nh
tw9gPll7n6vRA+zWSEhW+SiJiCUVIZOu2D+weirRJ7hyTQ/hZFmUuWt48pkEmmY8
x5OvnjTfv2jaaCiJOkoQ3Ij2woFaprZGwbWu+bVFFQLaVx/zNB8=
=wlVF
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
