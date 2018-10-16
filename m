From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/ucm: Fix Spectre v1 vulnerability
Date: Tue, 16 Oct 2018 12:49:24 -0400
Message-ID: <470a9265ef814f602885939306950cd0f1c51b12.camel@redhat.com>
References: <20181016143240.GA6087@embeddedor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-gtLk3VeW6BZw7OvT2jl/"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181016143240.GA6087@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-gtLk3VeW6BZw7OvT2jl/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-10-16 at 16:32 +0200, Gustavo A. R. Silva wrote:
> hdr.cmd can be indirectly controlled by user-space, hence leading to
> a potential exploitation of the Spectre variant 1 vulnerability.
>=20
> This issue was detected with the help of Smatch:
>=20
> drivers/infiniband/core/ucm.c:1127 ib_ucm_write() warn: potential
> spectre issue 'ucm_cmd_table' [r] (local cap)
>=20
> Fix this by sanitizing hdr.cmd before using it to index
> ucm_cmd_table.
>=20
> Notice that given that speculation windows are large, the policy is
> to kill the speculation on the first load and not worry if it can be
> completed with a dependent load/store [1].
>=20
> [1] https://marc.info/?l=3Dlinux-kernel&m=3D152449131114778&w=3D2
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Thanks, applied to for-rc.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-gtLk3VeW6BZw7OvT2jl/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlvGFpQACgkQuCajMw5X
L90W2w//Wt8KVlDA+7A6vNQ0VQit38wbiCZgLq0lhVJBeGzctVHLUBsWXloz7ka2
DcP5iEOdeCDInEye99Zv02v+LbP3iku9sSYEsPrCeGUJwdaC7xks/l99mByOoUsy
D8yP4lTXmZYbGBck8926abjJdKQtXgr8qBTDMA8k2i8inmx/gjgE0ZX2MQQoO1OO
eQNbfZfdM1f3Kw5dKo+okc+Ay5oomKIqxJv2AZ8rd6Uu/tjbgphshZxSo12FBGFq
Ni03ctXlbiEsXIudS8oUD1Q62Fc3m23KBEJsCuAd64VwyCe/y4CdZEl0VzEGDsKL
wc31s86xsHoDTqhhCwN+LJzLJzs7mtlxASE71ybINHdDOZ5amEkqy2l3GJLKW/MU
ZEyoGdc+HmCRp9IypnwdxnhrAPmEEAZTfP9oLINryMxOXMr5ceTmYRJzPAs4Dt9t
Y8MoVOseQvXi7UNJv0/qtvO5DvFX7yjYv81QnLJZx55y1DfN9fLZRyGWeNVJaBHV
MmXiEFDPageBIPUXxTuPCbHPqQROeJQPiN5D9WFbSkHh6fk25B2WNURSzU3w+X+E
TFlLEov4lAj0ZE+0sJ1QTPj5W7Toa4RM7CO8QoVHlCsRI+kIQlYLSXG0PG2GmLx3
rae53eGB6y66DmiabPHsWU7jWk2BZgBPnUKBSreINfxoFytLJRI=
=Dez4
-----END PGP SIGNATURE-----

--=-gtLk3VeW6BZw7OvT2jl/--
