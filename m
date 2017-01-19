From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [RFC] IB/hfi1: Fix port ordering issue in a multiport
 device
Date: Wed, 18 Jan 2017 19:17:51 -0500
Message-ID: <1484785071.2406.69.camel@redhat.com>
References: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
         <20170111181042.GC22783@obsidianresearch.com>
         <1484773260.2406.58.camel@redhat.com>
         <20170118210831.GA7590@obsidianresearch.com>
         <934eb6c4-fbba-28d0-d6bb-f036cc9ced5c@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-MkIkoO3N7RKU+BL0szaX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <934eb6c4-fbba-28d0-d6bb-f036cc9ced5c-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-MkIkoO3N7RKU+BL0szaX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-18 at 14:03 -0800, Tadeusz Struk wrote:
> On 01/18/2017 01:08 PM, Jason Gunthorpe wrote:
> >=20
> > EPROBE_DEFER is intended when waiting on other components the
> > driver
> > may need, not for setting stable names.
>=20
> Also EPROBE_DEFER only works during boot time.
> After boot when a module gets rmmod/insmod EPROBE_DEFER has no
> effect.

Are you positive about this? =C2=A0And even if you are, my answer is to fix
the core to honor EPROBE_DEFER post boot.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-MkIkoO3N7RKU+BL0szaX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYgAWvAAoJELgmozMOVy/dMOQQALnpZApCOFnJIV9qQwj/9kTP
1AYfaZSd8GcSqtt3Vo4oaBesuYDqfvRaRb9v1QVC71leVX3R10amy7BctUGBqmpm
0C0ZmMTL8bQpffhquxSouujR8uXhAYSTd7lMj6qmaWYj/SYqzImQ7DStEywhOHgy
ZcrHrcYAXDsaPA7sUZgkR9fJI5+XXYoA7f8jJIdgov/cR+yVPeQFrnjlxNzv16B2
q14VVgU12jz/a7h60548iRfKNqmjwLCapnZ4bTuHpia8UrQzo1osVAyF/Oz0KhEV
99quzOz0PbTOR4xhE+yxoXreFINFmLhL3IYmwYOwAHOxUWTwyRmvELxFH33noPCL
dzkrbjwVCCH224EHa3BODBpBUXzRSLU9NqRNCULXaBmIoqvKIH8VR7DJ5/rbTvMJ
Ya08Sb4s48OX3nUzoF9br9Y8OJzVtwoAgY+IGEqvctsOT6pkqd0yoJP7n2M9JCkM
ptv5GP6KCRiL/Jeh7murqiwgumU7L6Qq67YMyNmnGKTabhjvtm7uyzvtmtPnZEPh
KXl+WG5MTisNoUpBGRk6+eWLB8794w1+8IBbjpLCZQJiubBxH9BCYdOQ49XYX1t2
6z6KoLB/zSgQhRg7SIAdXvaMgSfNuq1nmRTmbIYLit5H+yB4qrrj2Z7FCp/D/FwF
7kUeqooVD4Mf7VNX6Ox3
=OKEa
-----END PGP SIGNATURE-----

--=-MkIkoO3N7RKU+BL0szaX--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
