From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/cma: Fix unknown symbol when CONFIG_IPV6 is not
 enabled
Date: Wed, 25 Jan 2017 08:51:15 +0200
Message-ID: <20170125065115.GM6005@mtr-leonro.local>
References: <20170115181500.4465-1-leon@kernel.org>
 <1485293330.43764.80.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m0XfRaZG5aslkcJX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485293330.43764.80.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Spencer Baugh <sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--m0XfRaZG5aslkcJX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 24, 2017 at 04:28:50PM -0500, Doug Ledford wrote:
> On Sun, 2017-01-15 at 20:15 +0200, Leon Romanovsky wrote:
> > From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> >
> > If IPV6 has not been enabled in the underlying kernel, we must avoid
> > calling IPV6 procedures in rdma_cm.ko.
> >
> > This requires using "IS_ENABLED(CONFIG_IPV6)" in "if" statements
> > surrounding any code which calls external IPV6 procedures.
>
> This seems strange....
>
> > In the instance fixed here, procedure cma_bind_addr() called
> > ipv6_addr_type() -- which resulted in calling external procedure
> > __ipv6_addr_type().
> >
> > Fixes: 6c26a77124ff ("RDMA/cma: fix IPv6 address resolution")
> > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.2+
> > Cc: Spencer Baugh <sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> > Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> > =A0drivers/infiniband/core/cma.c | 3 ++-
> > =A01 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/core/cma.c
> > b/drivers/infiniband/core/cma.c
> > index bd8d051..e19f19c 100644
> > --- a/drivers/infiniband/core/cma.c
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -2822,7 +2822,8 @@ static int cma_bind_addr(struct rdma_cm_id *id,
> > struct sockaddr *src_addr,
> > =A0	if (!src_addr || !src_addr->sa_family) {
> > =A0		src_addr =3D (struct sockaddr *) &id-
> > >route.addr.src_addr;
> > =A0		src_addr->sa_family =3D dst_addr->sa_family;
> > -		if (dst_addr->sa_family =3D=3D AF_INET6) {
>
> Why this construct? =A0Isn't the norm to simply surround the entire if
> statement with
> #if IS_ENABLED(CONFIG_IPV6)
> ...
> #endif

It is common way to add dependency on specific config option directly to
the flow if other "if" already exists. It gives clear view on the flow,
eliminates the need to find corresponding #endif and put all constraints
in one place.

For example latest patches, bet there is a lot of code like this:
commit 7ede8665f27cde7da69e8b2fbeaa1ed0664879c5
Author: Alexander Popov <alex.popov-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Date:   Mon Dec 19 16:23:06 2016 -0800

    arm64: setup: introduce kaslr_offset()

commit b6f8a92c9ca835b4a079ecee8433d0d110398448
Author: Nicolas Pitre <nicolas.pitre-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Date:   Wed Dec 14 15:06:13 2016 -0800

    posix-timers: give lazy compilers some help optimizing code away


=2E....

>
> > +		if (IS_ENABLED(CONFIG_IPV6) &&
> > +		=A0=A0=A0=A0dst_addr->sa_family =3D=3D AF_INET6) {
> > =A0			struct sockaddr_in6 *src_addr6 =3D (struct
> > sockaddr_in6 *) src_addr;
> > =A0			struct sockaddr_in6 *dst_addr6 =3D (struct
> > sockaddr_in6 *) dst_addr;
> > =A0			src_addr6->sin6_scope_id =3D dst_addr6-
> > >sin6_scope_id;
> > --
> > 2.10.2
> >
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =A0 =A0 GPG KeyID: B826A3330E572FDD
> =A0 =A0
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD



--m0XfRaZG5aslkcJX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliISuMACgkQ5GN7iDZy
WKcLYw//XdQozl2VH1/OC9/Hw66rINsCWSO4C7XgAhuJyRu5T6DjhcA6wCuOiDee
g+VxSh3VNb8Jv86vLEIhoCYnYtBhmL5e6QaZApV3FLiD7oWkHTv2dJsdMaIj5otj
kFhG2FiROZUobijR+jxUBE6lQUSR6KbB4/OQlyTnG7uy1uMyr2DvLC0QGgphKDEE
+HGgcYhGeboBvoGWQqn1d8ugmFyvBzuJ6vp2stFJMxefpUtA0iGDkz746xtjL9eA
d4A23rIU5LNgoDFQYMHEl4c3bVhrZiRtVBrxWpL4Y2i8r+rXRKmaf0XXzw21V8cj
3aYUrXifvi4Ctm9qFMifPxbTfKJFl+JB2WKmXjxcS3EKeN9rzVgEf6vOrqR7/wh+
V29A5OKyxEuECPvoD+NyRvJr4xXYVtNiDvzDmcYr2BPDoOWtATq+U5SOafjzz4qE
bC7XJpd0NbZDZdiByX6liyckGSLxM6fbjoBoOOHtRCtC3Dd9Ye+0mXa3o2G8VWcr
Y3N+lYXKaHVNnZlTsRI7K/vHhOVXXqtn7H+lxvvKMPsQUKRM8/amQYs/V4iZajXi
J93XGRtWysEAswGbj0OGF3a0hsIPhrEjRl56di9TjJaZzV9vYQouBSc/hJQFhrqq
epZAL0+zQrb5MM9jcvohfMIlzhcAUfD302Lobqyy9VChmBOaCO8=
=mChd
-----END PGP SIGNATURE-----

--m0XfRaZG5aslkcJX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
