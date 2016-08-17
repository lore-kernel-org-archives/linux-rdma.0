From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] RDMA/core: Unify style of IOCTL commands
Date: Wed, 17 Aug 2016 17:20:07 +0300
Message-ID: <20160817142007.GI5489@leon.nu>
References: <1471355123-6227-1-git-send-email-leon@kernel.org>
 <1471355123-6227-7-git-send-email-leon@kernel.org>
 <1471357887.2661.28.camel@intel.com>
 <20160816165041.GA5489@leon.nu>
 <1471367364.2661.45.camel@intel.com>
 <20160817051952.GC5489@leon.nu>
 <1471441516.19634.15.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D6z0c4W1rkZNF4Vu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471441516.19634.15.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--D6z0c4W1rkZNF4Vu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 17, 2016 at 01:45:21PM +0000, Dalessandro, Dennis wrote:
> On Wed, 2016-08-17 at 08:19 +0300, Leon Romanovsky wrote:
>=20
>=20
> > > I'm not opposed to trying to unify things, however this seems to be
> > > more than plop down the hfi1 stuff from here and put it over there.
> > > It
> > > is certainly not simplifying anything.
> >=20
> > It is "dark side" of UAPI - inability to change legacy declarations.
> > This is why I didn't remove anything except _NUM() macro.
> >=20
> > The simplification comes from definition of one place for
> > declaration of IOCTLs numbers and exporting it to users. It gives
> > visibility for user space authors too.
>=20
> How often does a user need the IOCTL numbers for MAD and PSM and
> whatever else we come up with at the same time? Why would they care
> about the other IOCTL numbers?=A0

We will need new IOCTLs numbers for ABI and better if they be different
=66rom already defined.

>=20
> I don't really see a problem with keeping them separate, but I'm not
> really opposed to collapsing into one place either.

Thanks

>=20
> -Denny

--D6z0c4W1rkZNF4Vu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtHKXAAoJEORje4g2clinY+8P/iQqGEkjYo2zZHsjhCKZa8Vh
lnRmQIpY6BHS0wjyOVa+pHGD2uTxSfI1VSOjW3nTSAUhFvNqvJNI2Z8Q8HKI1sgq
uQdYuWoIF8Wz6MY5XGezBKGy9CxPKcgGjARZcMhfCT//BEKHscrCWwk8UvJeuByu
rXVoVbWI1joQZiwsiXYcAtAYQx9kuOlanzhIQHOUGSj5LbJBHHE8Z71dbNgure8H
mIZOMjuvyIaQIJJyHyEdAAi2FLoZMu3CresFo2ocnvL5++aAd+4aDJRN6oFDTE69
Afbgn5QtJtxecNam1Px8LGQ9mRPqM0lQ9FHe3anak5FDBvEgWLL4HTUMyxgs7s6x
0FRHWgATFqcKUuJ54aSefZIzxr04k8i4yCwoRlJulKv44qaFcttShbtt+sqiarZQ
YHl3K5wAGjIJVOsT4aCRtwVT5pP5Rd96uphYJ+qSqc2AO99J2wNa/Ji2zUnukLrO
q7uFAmbhyqPgNlcavaRC/B7bgE37pU9lhZkzjZYJCfCTVu6URkNObzZW/mEzeZv0
pqof7g7Wbxdo371n1nbp9OHiYnlbwYonkYS8cPA7r11o/ub2l+v2mWJ3Pxerbksf
qlMJNIh9Phnpm+n+LsCFISQJoJ46k9MQ66t12VtV3dK5Lrsbmf15g1IwTAVF6Q3p
9sew+JJQs0pg3eKZI9rD
=GMaO
-----END PGP SIGNATURE-----

--D6z0c4W1rkZNF4Vu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
