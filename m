From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/27] IB/hfi1,qib,rdmavt: Patches for 4.11
Date: Sun, 19 Feb 2017 08:47:22 -0500
Message-ID: <1487512042.86943.106.camel@redhat.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Xpurn7YfGr7diNXpC6Wj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Xpurn7YfGr7diNXpC6Wj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-02-08 at 05:25 -0800, Dennis Dalessandro wrote:
> Doug,
>=20
> Here is a set of patches for our drivers for 4.11. This is a
> collection of bug fixes, perf improvements, and clean ups.
>=20
> This does not include the port reordering patch series or
> vnic as those are still undergoing discussion on the list.
>=20
> Patches apply to your for-4.11 branch and can also be
> found in my GitHub repo at:
> https://github.com/ddalessa/kernel/tree/for-4.11

Hi Denny,

I took everything except patches 22 and 23 because they add a Kconfig
and I'm trying not to do that. =C2=A0I'd be more than happy if you and Leon
worked out a joint Kconfig for debugging that didn't have all the
compile time options and instead you have one compile time option, then
the remainder are runtime options, and make that a global RDMA stack
debugging option. =C2=A0You both have debug features you want to enable, bu=
t
I want the Kconfig to remain simple and sane.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-Xpurn7YfGr7diNXpC6Wj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYqaHqAAoJELgmozMOVy/dXgAQAINtzHVdD+mB0ZI9m8zXxdJ/
gYm7qRTEvvOfXC9o3Aww2GZeVCBN4pfz9/cOQKH5bIXRNh8geTYC+EZ+MvJLBmCe
woiV4PnrOpYSYHL6JyZFIC2lTj3aiYsePVdPcEXDDcY59Kg3KqlEe1wGVClUKNLN
7i0KTV7So0tzKLwjxG9VMgwEzjCcgwIt7DAVEC8bvaN/WyobtBgTDrpEoWfMY72c
VCL4wqBvI/W0fHnVPMEczG4u0Iersv2W9db4q8gIiGHXEWlD0wl/2LsRGNld/hgt
GiF05CC+l8fjKKgTDs99Yn2FUyN9uhyodBpGXr5ci6wd1PR/hmDUQYSKw3JD8p1w
PNAMNxZFwobDRN9EVHf9FR07g7E8uzswJPo9S/42CLAxIqmr9n1xPCWSSZuwB0+O
lx4etRJcRWipiKje21l0pxQBCHVYTGjVEcCQM7+yRb1zB/A8LtxNd+fXGM+eN4RQ
jxYSfrdVooJ0E6FOfi6ddP60Kg/9daJqvZe5pBUJ3VT4HS4mCAtJYVnQjm1hJb1o
fVMsPb8hQBxRSZFOr056Zs2amU1QdEoHuTrfJ9zho1nzC/MiQEpqZHjnFEcF+P8T
oiXzyj4yZCbeio/cox4xFx18P3wcoCZNfQk8gM2L4J31haIAxsiarRx9ostbfjlu
ngjBcbr9Xq0iKfCWiC7h
=H+IX
-----END PGP SIGNATURE-----

--=-Xpurn7YfGr7diNXpC6Wj--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
