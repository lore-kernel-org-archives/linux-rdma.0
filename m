From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/rxe: Fix a race condition related to the QP error
 state
Date: Fri, 12 Jan 2018 08:23:59 +0200
Message-ID: <20180112062359.GG15760@mtr-leonro.local>
References: <20180109192340.25702-1-bart.vanassche@wdc.com>
 <1515620434.3403.169.camel@redhat.com>
 <1515621700.3403.174.camel@redhat.com>
 <20180111062252.GP7368@mtr-leonro.local>
 <1515686552.2752.2.camel@wdc.com>
 <20180111190045.GE15760@mtr-leonro.local>
 <1515697625.2752.46.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Qz2CZ664xQdCRdPu"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515697625.2752.46.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jgg@mellanox.com" <jgg@mellanox.com>, "monis@mellanox.com" <monis@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org


--Qz2CZ664xQdCRdPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 11, 2018 at 07:07:06PM +0000, Bart Van Assche wrote:
> On Thu, 2018-01-11 at 21:00 +0200, Leon Romanovsky wrote:
> > On Thu, Jan 11, 2018 at 04:02:33PM +0000, Bart Van Assche wrote:
> > > On Thu, 2018-01-11 at 08:22 +0200, Leon Romanovsky wrote:
> > > > The proposed patch definitely decreases the chance of races, but it is not fixing them.
> > > > There is a chance to have change in qp state immediately after your "if ..." check.
> > >
> > > Hello Leon,
> > >
> > > Please have a look at rxe_qp_error() and you will see that the patch I posted
> > > is a proper fix. In the scenario you described rxe_qp_error() will trigger a
> > > run of rxe_completer().
> >
> > Bart,
> >
> > What am I missing?
> >
> > CPU1							CPU2
> > 							if (unlikely....
> > 						<---
> > /* move the qp to the error state */
> > void rxe_qp_error(struct rxe_qp *qp)
> > {
> >         qp->req.state = QP_STATE_ERROR;
> >         qp->resp.state = QP_STATE_ERROR;
> >         qp->attr.qp_state = IB_QPS_ERR;
> > 						--->
> > 							rxe_run_task(&qp->req.task, must_sched);
> >
> >
> >
> > It is more or less the same as without "if (unlikely..."
>
> Hello Leon,
>
> In the above the part of rxe_qp_error() that I was referring to in my e-mail
> is missing:
>
> 	if (qp_type(qp) == IB_QPT_RC)
> 		rxe_run_task(&qp->comp.task, 1);


But it is exactly where race exists, as long QP isn't protected, it can
switch CPUs and create race.

Thanks

>
> Bart.

--Qz2CZ664xQdCRdPu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpYVH8ACgkQ5GN7iDZy
WKfbog//emjas2DjVczG/gVuMJ726d87/prN2B5fyY1Z0Mei4hQxH75C6Tey3nkU
QcGONEa8czCYqZyTlqmUR3TrTKNGioeW+E8ovBV4j9+81liV9dnPWMe0tUE94S3B
x05D5Fz+beaU51hRjgmoztej5fKY6Bp9KCE6PReN1tDsqmN6lbuSTpLZX7CrKxB6
iRlJQkSdM9LrsJWQQC3ErtSLzohzb4FpJP+VusXzMvAFwGqD1Z4CafVOlnDZLmwV
vftroEJHhA/TarluBTulijJ9qNKUiookCNGWRWvy1FbSlt5wEIYSqWx+cHcywowX
BYSAeBc86UITcg7ykIaik8Pur8SeMZg4IEvyVBUsgwOhwXp12v/w64kOkuiKoNKa
+3/Gd2uPvsdIXOwJ/A+vX2xALxiuw2Vd+4L3RAKO2XKFEhxRz74ytQ2GZ/+3L3Rq
2yhLqxQJbpU9ry1JfNUV0cVVI0DgGCIZBMb2fi7c3Kf6Pm3gdnd7BfvgNk9RkW6x
nhSmbrINxvx0ZndimYVz1/5fvKkg7Uxw9ObpVXwO2Ch0THs0vFR5QkNBNwS+ZPxD
07RvHAIEiYvaR65SyXv1foDe5dlPe2bKUpXWTsTXakesqgbDNiq2sQXFKml1sT5n
cP5J10gX6ROqx5AK8BIYMXvsa7ehf01IbvjqQVcjV+3Wbg5Apuo=
=sxVe
-----END PGP SIGNATURE-----

--Qz2CZ664xQdCRdPu--
