From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] [PATCH 08/21] IB/hfi1: Adjust default MTU to be 10KB
Date: Mon, 18 Apr 2016 15:30:32 +0300
Message-ID: <20160418123032.GM6349@leon.nu>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
 <20160412181708.21853.23423.stgit@scvm10.sc.intel.com>
 <20160418070708.GJ6349@leon.nu>
 <20160418120335.GB17987@phlsvsds.ph.intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bPrm2PuLP7ysUh6c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160418120335.GB17987-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--bPrm2PuLP7ysUh6c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 18, 2016 at 08:03:36AM -0400, Dennis Dalessandro wrote:
> On Mon, Apr 18, 2016 at 10:07:08AM +0300, Leon Romanovsky wrote:
>=20
> >>diff --git a/drivers/staging/rdma/hfi1/qp.c
> >>b/drivers/staging/rdma/hfi1/qp.c
> >>index 29a5ad2..e68d08a 100644
> >>--- a/drivers/staging/rdma/hfi1/qp.c
> >>+++ b/drivers/staging/rdma/hfi1/qp.c
> >>@@ -167,8 +167,12 @@ static inline int opa_mtu_enum_to_int(int mtu)
> >>  */
> >> static inline int verbs_mtu_enum_to_int(struct ib_device *dev, enum ib=
_mtu mtu)
> >> {
> >>-	int val =3D opa_mtu_enum_to_int((int)mtu);
> >>+	int val;
> >>+	/* Constraining 10KB packets to 8KB packets */
> >>+	if (mtu =3D=3D (enum ib_mtu)OPA_MTU_10240)
> >>+		mtu =3D OPA_MTU_8192;
> >>+	val =3D opa_mtu_enum_to_int((int)mtu);
> >
> >Just spotted my attention,
> >Curious names, castings and type conversions.
> >
>=20
> Is there a question being implied here? I'm not clear on what kind of
> response you are looking for here.

No, there is no question here.

mtu is type of "enum ib_mtu", which is converted to int and supplied to
function which has opa_mtu_ENUM_to_int name. From the name of that
function looks that the parameter supplied should be ENUM, but it is not
the case.

>=20
> -Denny

--bPrm2PuLP7ysUh6c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXFNNoAAoJEORje4g2clinOVMQAJq5lbQ7wXSS6dfRD4h+KgSo
xydanE/co1hx88O6poGD6XwjWoowAGw41OD2/2FwVa6z91rUnnL8SilVpV2XocWh
qU73c8qmqPNe725hYVFJy/EPxXXVQDCYv+2urVx14WOra8i0MNvz80bQwNBpoXJH
8WFb9mCz/jMl2JJb4wWcMMp3b/OzJ5ajHGTbuvk5G3xrQNyAuZTLk8sCm4i81WXl
H2VAKmumW4UOhdmvua5DTmio9kuyQwUzIFFI/ml35YN7XbmyWvruWdgTLr64RAxu
yd8Tjnl9VRS169udBMTXep9KisRnETWVh8tUnayTdQ7gifRJc9V4Cb+e4WzzXNVz
CkwcUyScxK2rNOBfWGgP8DM2QSadDKobIfweMBIQ3RVOpqLVDui/IXPu9pehF8uS
2wc2E7I/Jd1WNcaI3CouzX8UA0MLzp+82LwwL10lym68CMMfQwnExeyGKo8QaSBh
mTmImWnQUUMnGde6vP6fszgQZNI15FEQC6SHHrltn37fpL2Gf2vt9RAwtscX/jKx
9RwPNaB7KcTrCDW3UNj9dnBfDla25IkMms1K4al5xvtMIQUCz/j6UPN3J22G4+u4
gnP5Df7TuHgVDMB5CIifUFOikEO91Ef02vPLmDmooOav48ZJMpDEz4c25GansVhB
l4lAjmt4TQMtk5lRN8Lp
=n1De
-----END PGP SIGNATURE-----

--bPrm2PuLP7ysUh6c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
