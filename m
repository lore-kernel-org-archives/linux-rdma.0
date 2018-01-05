From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] i40iw: Replace mdelay with msleep in i40iw_wait_pe_ready
Date: Fri, 05 Jan 2018 13:47:10 -0500
Message-ID: <1515178030.3403.31.camel@redhat.com>
References: <1514111980-30502-1-git-send-email-baijiaju1990@gmail.com>
         <20180105174441.GA13368@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-EMuaHHgQo8ZPC4ovKLze"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180105174441.GA13368@ssaleem-MOBL4.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>, Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: "Latif, Faisal" <faisal.latif@intel.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-EMuaHHgQo8ZPC4ovKLze
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-01-05 at 11:44 -0600, Shiraz Saleem wrote:
> On Sun, Dec 24, 2017 at 03:39:40AM -0700, Jia-Ju Bai wrote:
> > i40iw_wait_pe_ready is not called in an interrupt handler=20
> > nor holding a spinlock.
> > The function mdelay in it can be replaced with msleep,=20
> > to reduce busy wait.
> >=20
> > Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> > ---
> >  drivers/infiniband/hw/i40iw/i40iw_main.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
>=20
> Thanks!
> Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
>=20
> =20

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-EMuaHHgQo8ZPC4ovKLze
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpPyC4ACgkQuCajMw5X
L92DRQ/9EKRg3u/0Mq4/m5i5I9Yy4arwohKTmYy6QgB38l1HWtoDzhyx0O4bwdea
ymT7h4MXSa7yMwu7vixuhfODLzECwOdMEpLACWSKEz7UW53tiZC7iI4QXso3dle+
occoa3GpeRmJHYW8jufxNSIZTIKxBXgaS+rFB6cuiKCFPlrU6vYHQAZkxSpBjPjj
gKEV1wp4VE4tirqN6i3RVbMPcZhj0yHLTRuHMTydpCWniXPcu0D/R0T+Ipm8nH82
DSIihplO0gcj9UL1Ay98Se1KpCk734SM8aUOM66O4BqpjZ9vl08heQJZZJTqC4sw
mML1+YnvTt4H7WYVBXjeiIhVRya95YJHwG2YYxvOEzr5t6sRo+y949BydRlRKh4D
KRaYA5o/R68U108p8vdl5xYlciCUG6nC7zq/bqoyn2sEGC0225ucH+fkAFnnAdXS
+eL+wfeoNIZDL2OXolefau01yJqnmPfVi/eTQpPiZ6A2qClFgzqoDiThLbmQvRVx
vs8IBp2nTfl6Je4VJyTaLN78qXhxfZ89UBN5rnU8TNYnBY60pSyGCKHp9iqDiWvg
nekhGX9yVL4Wh1og16daEq30lmA8OT863YajcSFsPPmFy8QmuKZQ55yNQ8+7y+lY
kzcStxME5BaW4wr5srHq7SW3o82KEfXdgYS8Dv3p4rS/uTdSfS4=
=EeMK
-----END PGP SIGNATURE-----

--=-EMuaHHgQo8ZPC4ovKLze--
