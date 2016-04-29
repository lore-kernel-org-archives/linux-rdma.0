From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 12/12] IB/isert: convert to the generic RDMA READ/WRITE
 API
Date: Fri, 29 Apr 2016 19:42:41 +0300
Message-ID: <20160429164241.GE774@leon.nu>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-13-git-send-email-hch@lst.de>
 <57227ADC.80000@redhat.com>
 <572349AA.2070407@grimberg.me>
 <e7959da7-79ca-0422-fbc9-9b3814516e1b@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2qXFWqzzG3v1+95a"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e7959da7-79ca-0422-fbc9-9b3814516e1b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--2qXFWqzzG3v1+95a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 29, 2016 at 10:45:34AM -0400, Doug Ledford wrote:
> On 04/29/2016 07:46 AM, Sagi Grimberg wrote:
> >=20
> >>> Replace the homegrown RDMA READ/WRITE code in isert with the generic
> >>> API,
> >>> which also adds iWarp support to the I/O path as a side effect.  Note
> >>> that full iWarp operation will need a few additional patches from Ste=
ve.
> >>>
> >>> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> >>> ---
> >>>   drivers/infiniband/ulp/isert/ib_isert.c | 841
> >>> ++++----------------------------
> >>>   drivers/infiniband/ulp/isert/ib_isert.h |  69 +--
> >>>   2 files changed, 85 insertions(+), 825 deletions(-)
> >>
> >> Hi Sagi,
> >>
> >> I've seen your reviews on the smaller patches in this series, but this
> >> one in particular has your name all over it.  If you could review it, I
> >> would appreciate it ;-)
> >=20
> > ~800 LOC deleted, what's not to love ? :)
>=20
> Well, if it neutered support for something in the process, it wouldn't
> be to love ;-)
>=20
> > The patch looks fine to me,
> > Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> >=20
> > I did some light testing with rxe and it works fine (no signature stuff
> > though). I've asked Mellanox folks to get this set into their regression
> > systems and still hoping to get their tested-by tag, but if we don't
> > hear from them by the merge window I don't think we should block it.
>=20
> Good to hear, thanks!

We are in the Passover vacation, and most of the people aren't at
work, so I don't know when it is planned to be tested.

>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>=20
>=20



--2qXFWqzzG3v1+95a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXI48BAAoJEORje4g2clinr7MP/Rh5QGRvmkxtl52ljL9qgQ4N
Rcu5g6EwJC4R0XcfKbNNClvUS7qS/ev1NFYTc0lrQpoQUDFA6TWkbxgwzWZib8dD
P7DRZQSrXuLVtGcX/6RtrmAkbp6xtoJRQ3YVVbWx6fEy9Bec/+xKSL5B2dMsJW1p
FaQCR0sxrt5CREblZl7dVhV7QhGGo48m4VRRYtJ+r9VadrrSL70S6NrmrlD5a2UV
/b6Pmpq8+VD/yrX1eM7v8a4qV8Q0hTwGLJrcEU0Ut3joXyRKYcsULPqvuSzd9tY4
Zy6X+9Qa1UJ/NW/Nmf5aNhC4INyhy8940RiHpbX2VFoo0uuVHD4MY+EZePHGii1M
ooQ5t9u/b9d0Mg3Ol/ZafO6Y46di61CbpWrTjW8mq5b3+jfuA/ncrTqV6UXONKrA
uVTPNNX5r1Q26+shWqGdbv8GGRE9KHBmvBju6ppXv5R6o71sry0epvXgdJvQ+Krp
79m+4uX7rVmhowfOEcyLW0mELOgN00REoWHKotGgIYNQSOPdtXyMsDww5laOdOgK
mIpHtVykFjsmev/TJOVVat0bslEE/CaiGne7e0X8V+GySb/83uUeERNzUYKh5iRi
Yy55e4r3+eRuDKvgbx+w0qCINyrHhRU/av4rLzdgXjtv0L4kvDC9Zw1RS+jl3skZ
gHZz/2xgQRQriN8DCheO
=x2Z0
-----END PGP SIGNATURE-----

--2qXFWqzzG3v1+95a--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
