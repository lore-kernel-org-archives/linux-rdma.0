From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 06/11] IB/rdmavt: Use correct numa node for SRQ
 allocation
Date: Wed, 20 Dec 2017 10:31:23 +0200
Message-ID: <20171220083123.GO2942@mtr-leonro.local>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
 <20171219035649.2126.1625.stgit@scvm10.sc.intel.com>
 <20171220081720.GM2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YZQs1kEQY307C4ut"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171220081720.GM2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--YZQs1kEQY307C4ut
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 20, 2017 at 10:17:20AM +0200, Leon Romanovsky wrote:
> On Mon, Dec 18, 2017 at 07:56:52PM -0800, Dennis Dalessandro wrote:
> > From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > Normal receive queue allocation ensures that kernel receive queues
> > are allocated on the local numa node. Shared receive queues
> > do not behave the same way.
> >
> > Ensure that kernel shared receive queues are allocated on the device
> > local node.
> >
> > Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/sw/rdmavt/srq.c |   16 +++++++++-------
> >  1 files changed, 9 insertions(+), 7 deletions(-)
>
> Are you aware of "__GFP_THISNODE" flag?

It is not relevant to this patch, sorry.

>
> Thanks



--YZQs1kEQY307C4ut
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo6H9oACgkQ5GN7iDZy
WKd1qg//UFNHhTYKfRNt7Iqsl1X7Du4UnJRe+Xc7wHC5PHnjvPKk4AhWRQ8nvXSM
qfC0/ppiOFgluWrtCycIG74Z3hqwcNmsRyGsZ76RkhsWER5AtnSUkTCVyYiik3pA
doy7BbD/s2RlDsCIg05rA1bnV9kUwIawqENpaQUMA2mqc5raNzl51P+VMvS5WVvV
JLUygoOfjik0KWNvm7X0kB2aJLt0wZH30FcaVNIxiIWGmsVTO6yfj9qXFBYY+Vx3
x0ht525X6Iow6MANwmrPD0pTDvfwKs7DJhiogPe9mBiYprmF4N4lmoUocqq4IKES
YyV75I0wMDzljxFIqVTgsyjERtD6duvTWQinpt7f8By1roBlmlwB7uJstqxIf5FO
N9w2cr78SMfwjOKHZIW2m8dMCqqb5NmfLjdzjiZWA9EnqBl8Rco5NDQ5aAbnykau
S2C2OKIDZQGG5s0/CBW4ttoqxWNUTF7eB4J2jPYys87EiNdHHASXK4XL//rGyWzL
Nw+Fd8VCo0L5GS+uUPfgDu9Tt8nCKdbywxliu9Vd/RNYRICORsUP9DntC/v6DPLX
JtqHvFnu6cCh4/+aPTt5RGFxE5Zbobaq7a6ZaSNP/UG/G/InoR906nW75Nyqr1pe
aQAmNWGA0mH7byoF1QoGvbnlOAWKhxdmJkRBjmkdhvmSo3jXVdg=
=Znwp
-----END PGP SIGNATURE-----

--YZQs1kEQY307C4ut--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
