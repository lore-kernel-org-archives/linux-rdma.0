From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] infiniband: nes: add unlikely() to assert()
Date: Fri, 07 Sep 2018 11:13:21 -0400
Message-ID: <811a6feca9fdea2db59ac392a4711cd897f46cc7.camel@redhat.com>
References: <20180831192418.12346-1-igor.stoppa@huawei.com>
         <20180905060106.GI2977@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-IP+zaWvXiDu0GpMM6jBS"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180905060106.GI2977@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Igor Stoppa <igor.stoppa@gmail.com>
Cc: Faisal Latif <faisal.latif@intel.com>, Igor Stoppa <igor.stoppa@huawei.com>, Chien Tung <chien.tin.tung@intel.com>, Roland Dreier <rolandd@cisco.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-IP+zaWvXiDu0GpMM6jBS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-09-05 at 09:01 +0300, Leon Romanovsky wrote:
> On Fri, Aug 31, 2018 at 10:24:18PM +0300, Igor Stoppa wrote:
> > Typically the assert is expected to not fail.
>=20
> This whole assert can be removed.
>=20
> >=20
> > Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
> > Acked-by: Doug Ledford <dledford@redhat.com>
>=20
> Most probably that I missed discussion, but anyway, does this
> "Acked-by" come from internal or external discussion?

This patch was part of a larger series on lkml.  In that context, I
acked it so that the series could be applied by whomever took it (it
didn't belong on rdma-list as a series since only one patch out of some
large number touched rdma files).  Now it is being resent as not part of
a series, but my ack was preserved.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-IP+zaWvXiDu0GpMM6jBS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAluSlZEACgkQuCajMw5X
L93a6g//WBA/uxKA9aeF2MOYzAqZjiVVIfN+n0yyJCmFaKk8NqYdftjbKx5eAIqY
BfjlBUmvI6Tw3S/EnezPUvfZt3aX5jQcy50lqnlVdLHAsbkwuOylQRLB8pxfukqR
uwOrdgKXJAflvskpP+A7dUsY/N/dfTEd2hNh35/IOm8dqLBVNBTAknMnW9VYlQzZ
FrElzH9siUvdZa9j2IKCW/7GtxCpUFqS3m2RAHjkYqYeA+7lkPJhtJDKhFD+2hRM
MWkA1J0P0BnEszjt00VY3atq8HxmIDdlArwjG1egtNE7ZnsncD5a5HDTnnXAZWR6
OY81FdVcf8JP6Giuxhbd6NCSNoZPqSMliDgrlQCaeLccpDaI5bUczhMTYSNDS1Bz
nq3hGxyGenOS5q4EYHCsYsklhFb0q7u9Mo7k9pjF2nCxP/terbdxgCocJDxp4xkR
00SRx/bPJ7KmAjnxp/A5Tf8838ESMzAo2R9jNSQBIZIeWZ+c6cuGy3j+8ELFTLQE
9datkRx2kY/4i9thf3Ygez20MGaEzE1ZsHKmjRXoFshutYMVxIabEou4pA/em1Pr
23/Z6S7O7mvMsX1t9cvhRPQxGmlPitC9y2RV8tELOSRdY8NHuDG8Z7jHx/Jee46G
fXDWS9hPzioyWlGKZTe0xxPSDqIblhZ7m/Fhb+Y+7OFpyRT9Lys=
=qUlD
-----END PGP SIGNATURE-----

--=-IP+zaWvXiDu0GpMM6jBS--
