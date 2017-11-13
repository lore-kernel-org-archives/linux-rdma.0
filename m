From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next] iw_cxgb4: remove BUG_ON() usage.
Date: Mon, 13 Nov 2017 15:13:18 -0500
Message-ID: <1510603998.3735.29.camel@redhat.com>
References: <20171103195527.E4AE72BC82@smtp.opengridcomputing.com>
         <e0576722-2c47-9020-34b4-dea7983600a9@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-QAmzbJdCOGfvR+qNiTH7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e0576722-2c47-9020-34b4-dea7983600a9-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-QAmzbJdCOGfvR+qNiTH7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-11-06 at 09:23 -0500, Dennis Dalessandro wrote:
> On 11/2/2017 5:11 PM, Steve Wise wrote:
> > iw_cxgb4 has many BUG_ON()s that were left over from various enhancemne=
ts
> > made over the years.  Almost all of them should just be removed.  Some,
> > however indicate a ULP usage error and can be handled w/o bringing down
> > the system.
> >=20
> > If the condition cannot happen with correctly implemented cxgb4 sw/fw,
> > then remove the BUG_ON.
> >=20
> > If the condition indicates a misbehaving ULP (like CQ overflows), add
> > proper recovery logic.
> >=20
> > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > ---
> >   drivers/infiniband/hw/cxgb4/cm.c       | 25 +++++++++----------------
> >   drivers/infiniband/hw/cxgb4/cq.c       | 10 ----------
> >   drivers/infiniband/hw/cxgb4/id_table.c |  1 -
> >   drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  1 -
> >   drivers/infiniband/hw/cxgb4/provider.c |  4 ++--
> >   drivers/infiniband/hw/cxgb4/qp.c       |  3 ---
> >   drivers/infiniband/hw/cxgb4/t4.h       |  7 ++-----
> >   7 files changed, 13 insertions(+), 38 deletions(-)
>=20
> Awesome to see these go away.
>=20
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks Steve, nice cleanup.  Applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-QAmzbJdCOGfvR+qNiTH7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloJ/N4ACgkQuCajMw5X
L93Q8Q/8DKpFWDnu+5/FHPDtnJ7yGT+xOQCJ0r5Ri3dQJTzmf1X+V/wKiygPJEXN
KaP3KXI4xIZZXaX43fNLJv5peFbHphjz4RKzkWrEXF6vpR0H7n7H/vxF2Yg4VWk6
IocWLTx6S/+Pj5Ax6C6sARVkzDaBgXxU3Sb36Q5e7idB4Ex7cT4sboEgI2SntmgW
1HhXRBAiUTNEUq3NXHPtC/AJmCHpo6/iS/rj/QUTgCmZ1k2Z//bsDeq5Y4g2zBG7
cgtqfxo32w8G2LB+8Zx8rnM4vfIJUxrVL6AhPrqEOmgyjV0oh570m+WOsXe1LXOe
K86dT6W4DEek8HexUJ2719iXTihHMYyaWhca1ajSQ5JwwAn7Bix8Gb0OOpMz5VgC
zDH3OhovGz9XL2FUNnp8ZOSDZGF2oMHeQ/43e2GIIgfi8D5tpdgd0she6yXSmadY
qSqFmyJTceY/HUESSpOdufHpweO3g4NeIgAil/QirWgs8WHfAziV/ReKTY4XdvlK
2HmU6wtoWEdpL4zrrogRfwtG9lAmec70L6vNoeDlkYgAMceBLBm01Va4OcotBq7X
jnwqEyvbKXbr+3EKEkotiOnHQQFKXmum/XL7ARdHIAmazeyVZuVp9Ch3k4sB5YZj
5iEYfTpTusHj7CcyDk9cFdziG42LbiKt3fc55c2MFmyVoRPosm4=
=fj6U
-----END PGP SIGNATURE-----

--=-QAmzbJdCOGfvR+qNiTH7--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
