From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-rc] uapi: Fix SPDX tags for files referring to the
 'OpenIB.org' license
Date: Mon, 23 Apr 2018 11:11:06 -0400
Message-ID: <1524496266.11756.36.camel@redhat.com>
References: <20180420154910.GA2519@ziepe.ca>
         <20180422.210823.1454088204642743739.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-aTiSFOavqybSiOFpKn2H"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180422.210823.1454088204642743739.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>, jgg@mellanox.com
Cc: linux-rdma@vger.kernel.org, kstewart@linuxfoundation.org, pombredanne@nexb.com, gregkh@linuxfoundation.org, tglx@linutronix.de, swinslow@linuxfoundation.org, santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davejwatson@fb.com
List-Id: linux-rdma@vger.kernel.org


--=-aTiSFOavqybSiOFpKn2H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2018-04-22 at 21:08 -0400, David Miller wrote:
> From: Jason Gunthorpe <jgg@mellanox.com>
> Date: Fri, 20 Apr 2018 09:49:10 -0600
>=20
> > Based on discussion with Kate Stewart this license is not a
> > BSD-2-Clause, but is now formally identified as Linux-OpenIB
> > by SPDX.
> >=20
> > The key difference between the licenses is in the 'warranty'
> > paragraph.
> >=20
> > if_infiniband.h refers to the 'OpenIB.org' license, but
> > does not include the text, instead it links to an obsolete
> > web site that contains a license that matches the BSD-2-Clause
> > SPX. There is no 'three clause' version of the OpenIB.org
> > license.
> >=20
> > Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
>=20
> Acked-by: David S. Miller <davem@davemloft.net>
>=20

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-aTiSFOavqybSiOFpKn2H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrd94oACgkQuCajMw5X
L92qyQ/+N3Lbrhy4z7gxK7j1KPx6+DaH7yKqP1x3vjKkflvVDePAgfNKEgNWqKZv
aq0KDjOH/j3JioIaGQRuVtGx7VX+6bhVGfzd0EG3rN4wSzOpklU7X4sgL5zW8ZQ+
LLYMqTQ+adRZDHaks61gU6nHH8a2Tk2YtE6DaRO3XHzUlzxjVd4tXObDqV6lL2I3
9bG/VRDteswILhyp5fXXFPrMvneXTUc/HuXCCgTyq+FyR89AXX3SwrRMm5lo6Ubp
1StnQmkwSlmo6B9Y770zr3uAm8/EpdanTl6h0Oy3WyER+SPznElbiHK726UJ6BXS
5hOU8K7flfDL9Os/JPIezMcnn/zCgBLCF8R/euzTI6mIjVMpX5bMjFlF3xSTam2H
TkxFRxOiL/hrNrxRPvjOLgFkDdG8E/cZqhsi6Ap6WYeYiibWeT5PdsXD8o716uvE
J17g15RK87Dh9I9ZdgKxfJJ7lNO6vsRtili/IC2mmPZHnPjIOx/dSacDZgaH6taV
6Maquesc/ZACUf/gLoxYfJieagFcwMZTj3g3DgA9EHWwWxa19MFx2iQjBDMIUh7Q
CYnpV4DkCmb+UNhGF82gG75Z9dQKlKUeGX+CkzOud4zQOGei4A2zXFVo2704hHHp
d9jLr7oP6IDPvMvw0Y9E70DcwHRiINWJMjH0dA8DQfeTWBaBaI8=
=slaJ
-----END PGP SIGNATURE-----

--=-aTiSFOavqybSiOFpKn2H--
